%%%-----------------------------------
%%% @Module  : server_reader
%%% @Created : 2011.02.22 
%%% @Description: 读取并处理客户端连接 
%%%-----------------------------------
-module(server_reader).



-include("common.hrl").

-define(TCP_TIMEOUT, 60*1000). % 解析协议超时时间
-define(HEART_TIMEOUT, 60*1000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 30).  % 心跳包超时次数
-define(HEADER_LENGTH, 6). % 消息头长度

%%记录客户端进程
-record(client, {
%% 			t_users,
            user_pid = undefined,
			user_id = 0,
			server_id = 0,
            login  = 0,
            site  = undefined,
            user_name = undefined,
			index = 0,
			key = 0,
            timeout = 0 % 超时次数
     }).

-export([start_link/0, init/0]).

start_link() ->
    {ok, proc_lib:spawn_link(?MODULE, init, [])}.

%%初始化
init() ->
    process_flag(trap_exit, true),
    Client = #client{
                user_pid = undefined,
                login  = 0,
                user_id  = 0,
				site = undefined,
                user_name = undefined,
				index = 0,
				key = 0,
                timeout = 0 
            },
    receive
        {go, Socket} ->
			try
            	get_socket_data(Socket, Client)
			catch 
				_:Reason ->
				  login_lost(Socket, Client, 11, {error, Reason}),
				  ?WARNING_MSG("get_socket_data:~w",[Reason]),
				  ?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
				  error
			end
    end.

%%接收来自客户端的数据 
%%Socket：socket id
%%Client: client记录
get_socket_data(Socket, Client) ->
    Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
    receive
		%% QQ平台tgw
		{inet_async, Socket, Ref, {ok, ?QQ_TWG}} ->
			Len = 27 + length(config:get_test_ip() ++ tool:to_list(config:get_test_port()))  - ?HEADER_LENGTH,
			Ref1 =  async_recv(Socket, Len, ?TCP_TIMEOUT),
			receive
				{inet_async, Socket, Ref1, {ok, Binary}} ->
					get_socket_data(Socket, Client);
				Other ->
					login_lost(Socket, Client, 12, Other)
			end;
		
        %%flash安全沙箱
        {inet_async, Socket, Ref, {ok, ?FL_POLICY_REQ}} ->
            Len = 23 - ?HEADER_LENGTH,
            async_recv(Socket, Len, ?TCP_TIMEOUT),
			lib_send:send_one(Socket, ?FL_POLICY_FILE);		
        %%数据处理
        {inet_async, Socket, Ref, {ok, <<Len:16, IsZip:8,Index:8, Cmd:16>>}} ->
			P = tool:to_list(<<Len:16, IsZip:8, Index:8,Cmd:16>>),
			P1 = string:left(P, 4),
			if (P1 == "GET " orelse P1 == "POST") ->
				   %% 处理http请求
				    P2 = string:right(P, length(P) - 4),
					misc_admin:treat_http_request(Socket, P2),
           		    gen_tcp:close(Socket);
				true -> %%处理其他请求
%% ?DEBUG("~w,~w ~w ~w",[Client#client.index,Index, Client#client.key,Cmd]),
					if
						Client#client.index =:= (Index bxor Client#client.key) 
						  orelse Cmd=:= 10001 
						  orelse Cmd=:= 20001 ->
							login_parse_packet(Socket,  Client, Cmd, Len);
						true ->
							?WARNING_MSG("login_lost:~s",["indexerror"]),
							login_lost(Socket, Client, 11, {error,indexerror})
					end
            end;
        %%超时处理
        {inet_async, Socket, Ref, {error,timeout}} ->
            case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
                true ->
                    login_lost(Socket, Client, 11, {error,timeout});
                false ->
                    get_socket_data(Socket,  Client#client{timeout = Client#client.timeout+1})
            end;
        %%用户断开连接或出错
        Other -> 
            login_lost(Socket, Client, 12, Other)
    end.

%%处理登陆 
%%Socket：socket id
%%Client: client记录
login_parse_packet(Socket, Client, Cmd, Len) ->	
	BodyLen = Len - ?HEADER_LENGTH + 2,		
	case BodyLen > 0 of
		true ->
			Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
			receive
			{inet_async, Socket, Ref1, {ok, Binary}} ->				
				case routing(Client, Cmd, Binary) of		
					{ok, login, [Key,UserName, Site,Server_id, Tick, Sign]} ->
						case pp_account:handle(?PP_ACCOUNT_LOGIN, [], {UserName, Site, Server_id, Tick, Sign}) of
							{true, L, NewSite} ->
								{Type, IP, Port} = mod_node_interface:get_server_list(),
								IsVip = lib_account:is_vip(L),								
								case Type  of
									ok ->
										Client1 = Client#client{														
                                                		login = 1,
														server_id = Server_id,
                                                		site = NewSite,
														key = Key,
                                                		user_name = UserName
                                            			},
                              			{ok, BinData} = pt_10:write(?PP_ACCOUNT_USERSLIST_RETURN,  [L, IP, Port]),
                               			lib_send:send_one(Socket, BinData),
                                		get_socket_data(Socket,  process_index(Client1));
									full when IsVip =:= true ->
										Client1 = Client#client{														
                                                		login = 1,
                                                		site = NewSite,
														key = Key,
                                                		user_name = UserName
                                            			},
                              			{ok, BinData} = pt_10:write(?PP_ACCOUNT_USERSLIST_RETURN,  [L, IP, Port]),
                               			lib_send:send_one(Socket, BinData),
                                		get_socket_data(Socket, process_index(Client1));
									_ ->
										{ok, BinData} = pt_10:write(?PP_ACCOUNT_LOGIN, [0, ?_LANG_ACCOUNT_PLAYER_FULL]),
										lib_send:send_one(Socket, BinData),
										login_lost(Socket, Client, 2, "player full")
								end;
							{error, Reason} ->
								{ok, BinData} = pt_10:write(?PP_ACCOUNT_LOGIN, [0, Reason]),
								lib_send:send_one(Socket, BinData),
								login_lost(Socket, Client, 2, "login fail")
						end;
					{ok, create, [Career, Sex, NickName]} ->
                          case Client#client.login == 1 of
                             true ->
                               	Data1 = [Client#client.user_name, Client#client.site, Client#client.server_id, NickName, Sex, Career],
                                pp_account:handle(?PP_ACCOUNT_CREATE, Socket, Data1),
                                get_socket_data(Socket, process_index(Client));
                             false ->
                                login_lost(Socket, Client, 4, "create fail")
                           end;		
					
%% 					{ok, guest_create, []} ->
%% 						{true, L, Site, GuestID} = pp_account:handle(?PP_ACCOUNT_GUEST,Socket,[]),
%% 						{IP, Port} = mod_node_interface:get_server_list(),
%% 								Client1 = Client#client{														
%%                                                 		login = 1,
%%                                                 		site =  Site,
%%                                                 		user_name = GuestID
%%                                             		},
%%                         {ok, BinData} = pt_10:write(?PP_ACCOUNT_USERSLIST_RETURN,  [L, IP, Port]),
%%                         lib_send:send_one(Socket, BinData),
%% 						get_socket_data(Socket, Client1);
%% 						skip;
%% 					
%% 					{ok, guest_login, [UserID,GuestName]} ->
%% 						[{_,_,Is_open}] = ets:lookup(service_open,1),
%% %% 						if Is_open > 0 ->
%% 						if Is_open =:= -1 ->
%% 							   NewSite = "guest",
%% 							   NewInfant = 0,
%% 							   LoginData = [NewSite, GuestName, UserID, NewInfant],
%% 							   case mod_login:login(start, LoginData, Socket) of
%% 								   {ok, Pid} ->
%% 									   Pid ! {'select'},
%% 									   do_parse_packet_catch_ex(Socket, Client#client{	
%% 																			login = 1,			
%% 																			site = NewSite,
%% 																			user_name = GuestName,																
%% 																			user_pid = Pid,																						  
%% 																			user_id = UserID});	
%% 								   {error, _Reason} ->
%% %% 										 todo 发送选择失败
%% 									   ignore 
%% 							   end;
%% 						   true ->
%% 							   login_lost(Socket, Client, 10, "socket is cloesd")
%% 						end;
%% 						skip;
						
					%% 网页直接登陆
					{ok, http_login, [Key,UserName, Site, Server_id, Tick, Sign, UserId]} ->
						[{_, _, Is_open}] = ets:lookup(service_open,1),
						if	Is_open > 0  ->
							case lib_account:is_valid(UserName, Site, Server_id, Tick, Sign) of
								{true, NewSite,Data} ->
									[_Time,IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant] = Data,
									LoginData = [NewSite, UserName, UserId, IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant],
									case lib_account:check_forbid(UserId) of
										true ->
											case mod_login:login(start, LoginData, Socket) of
												{ok, Pid} ->
													Pid ! {'select'},
													do_parse_packet_catch_ex(Socket, Client#client{	
																			login = 1,		
																			key = Key,	
																			site = NewSite,
																			user_name = UserName,																
																			user_pid = Pid,	
																			user_id = UserId});	
												{error, _Reason} ->
													ignore
											end;
										_ ->
											{ok, BinData} = pt_10:write(?PP_ACCOUNT_LOST_CONNECT, [3]),
											lib_send:send_one(Socket, BinData),
											login_lost(Socket, Client, 10, "account is forbid")
									end;
                             	false ->
                                	login_lost(Socket, Client, 5, "select fail")
							end;
						true ->
%% 							{ok, BinData} = pt_10:write(?PP_ACCOUNT_LOGIN, [0, ?_LANG_ACCOUNT_PLAYER_FULL]),
%% 							lib_send:send_one(Socket, BinData),
							login_lost(Socket, Client, 10, "socket is cloesd")
						end;
					
					{ok, heartbeat} ->
						get_socket_data(Socket, process_index(Client));
						
					Other ->
						login_lost(Socket, Client, 8, Other)
				end;
			{inet_async, Socket, Ref, {error,timeout}} ->
				case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
					true ->
						login_lost(Socket, Client, 11, {error,timeout});
					false ->
						get_socket_data(Socket, Client#client{timeout = Client#client.timeout+1})
				end;
			Other ->
              	login_lost(Socket, Client, 9, Other)
			end;
		false ->
			login_lost(Socket, Client, 10, "other fail")
	end.
	
%%接收来自客户端的数据 - 登陆后进入游戏逻辑
%%Socket：socket id
%%Client: client记录
do_parse_packet_catch_ex(Socket, Client) ->
	NewClient = process_index(Client),
	try
		do_parse_packet(Socket, NewClient)
	catch
		_:Reason ->
			login_lost(Socket, Client, 11, {error, Reason}),
			?WARNING_MSG("do_parse_packet:~w",[Reason]),
			?WARNING_MSG("do_parse_packet:~p",[erlang:get_stacktrace()]),
			error
	end.		

do_parse_packet(Socket, Client) ->
    Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
    receive
        {inet_async, Socket, Ref, {ok, <<Len:16, IsZip:8,Index:8, Cmd:16>>}} ->
%% 			?DEBUG("~w,~w ~w",[Client#client.index,Index, Client#client.key]),
			if
				Client#client.index =:= (Index bxor Client#client.key) ->
					BodyLen = Len - ?HEADER_LENGTH + 2,
					RecvData = 
		            case BodyLen > 0 of
		                true ->
		                    Ref1 = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
		                    receive
		                       {inet_async, Socket, Ref1, {ok, Binary}} ->
								   case IsZip of
									   0 ->
										   {ok,Binary};
									   1 ->
										   UnBinary = zlib:uncompress(Binary),
										   {ok, UnBinary}
								   end;
		                       Other ->
		                            {fail, Other}
		                    end;
		                false ->
							{ok, <<>>}
		            end,
					case RecvData of
						{ok, BinData} ->
				            case routing(Client, Cmd, BinData) of	
								{ok, Data} ->
									gen_server:cast(Client#client.user_pid, {'SOCKET_EVENT', Cmd, Data});
		                        _Other2 ->					
									io:format("Other2 cmd:~w~n",[Cmd])
		                    end,
							
							do_parse_packet(Socket, process_index(Client));
						{fail, Other3} -> 		
							do_lost(Socket, Client, Cmd, Other3, 3)			
					end;
				true ->
					?WARNING_MSG("login_lost:~s",["indexerror"]),
					login_lost(Socket, Client, 11, {error,indexerror})
			end;
        %%超时处理
        {inet_async, Socket, Ref, {error,timeout}} ->		
            case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
                true ->
                    do_lost(Socket, Client, 0, {error,timeout}, 4);
                false -> 
                    do_parse_packet(Socket,Client#client{timeout = Client#client.timeout+1})            
            end;
        %%用户断开连接或出错
        Other ->
            do_lost(Socket, Client, 0, Other, 5)
    end.

%%登录断开连接
login_lost(Socket, _Client, _Location, Reason) ->
	timer:sleep(100),
    gen_tcp:close(Socket),
    exit({unexpected_message, Reason}).

%%退出游戏
do_lost(_Socket, Client, _Cmd, Reason, _Location) ->
    mod_login:logout(Client#client.user_pid, 0),
    exit({unexpected_message, Reason}).

%%路由
%%组成如:pt_10:read
routing(_Client, Cmd, Binary) ->
    %%取前面二位区分功能类型  
    [H1, H2, _, _, _] = integer_to_list(Cmd),
    Module = list_to_atom("pt_"++[H1,H2]),
    Module:read(Cmd, Binary).

%% 接受信息
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
    case prim_inet:async_recv(Sock, Length, Timeout) of
        {error, Reason} -> 	
			throw({Reason});
        {ok, Res}       ->  
			Res;
        Res             ->	
			Res
    end.

%% 处理序号
process_index(Client)->
	Index = Client#client.index+1,
	NewIndex = if
				Index > 255 ->
					0;
				true ->
					Index
			end,
	Client#client{index = NewIndex}.
	

