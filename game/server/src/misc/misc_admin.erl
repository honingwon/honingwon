%%%----------------------------------------
%%% @Module  : misc_admin
%%% @Created : 2011.03.08
%%% @Description: 系统状态管理和查询
%%%----------------------------------------
-module(misc_admin).
%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").


%%
%% Exported Functions
%%
-compile(export_all).

%% 处理http请求【需加入身份验证或IP验证】
treat_http_request(Socket, Packet0) ->
	case gen_tcp:recv(Socket, 0, ?RECV_TIMEOUT) of 
		{ok, Packet} -> 
			P = lists:concat([Packet0, tool:to_list(Packet)]),
			check_http_command(Socket, tool:to_binary(P));
		{error, Reason} -> 
			{http_request,  Reason}
	end.

%% 加入http来源IP验证 
check_ip(Socket) ->
	MyIp = misc:get_ip(Socket),
	Re = lists:any(fun(Ip) ->tool:to_binary(MyIp)=:=tool:to_binary(Ip) end,config:get_http_ips()),
	case Re of
		false ->
			?WARNING_MSG("misc_admin  ip error:~s",[MyIp]);
		_ ->
			skip
	end,
	Re.

get_cmd_parm(Packet) ->
	Packet_list = tool:to_list(Packet),
	try
		case string:str(Packet_list, " ") of
			0 -> no_cmd;
			N -> 
				CM = string:substr(Packet_list,2,N-2),
				case string:str(CM, "?") of
					0 -> [CM, ""];
				 	N1 -> [string:substr(CM,1,N1-1),  string:substr(CM, N1+1)]
				 end
		end
	catch
		_:_ -> no_cmd
	end.


%% 检查分析并处理http指令
check_http_command(Socket, Packet) ->
%% 		——节点信息查询:		/get_node_status?					
%% 		——踢人下线：			/kickuser?id						
%% 		——安全退出游戏服务器：	/safe_quit?node						
%%		——获取在线人数			/online_count?							
%%		——投诉回复			/complain_reply?
%%		——后台赠送			/admin_send_gift?
%% 		——发送公告			/send_sys_msg?
%%		——获取各个地图人物数量	/get_map_player_count
%% 		——重新加载模块			/cl?module_name
%%		——多倍经验开关			/multexp_control?
	try
		case get_cmd_parm(Packet) of
			[Cmd, Param] ->	
				treate_http_command(Cmd, Param, Socket),
				ok;
			_ -> 
				error_cmd
		end
	catch 
		_:Reason ->
			?WARNING_MSG("misc_admin  is exception:~w~n",[Reason])
	end.
			
%% 检查分析并处理http指令
treate_http_command(Cmd, Param, Socket) ->	
	try
	case check_ip(Socket) of
		false ->
				?WARNING_MSG("misc_admin  cmd :~s param:~s ",[Cmd,Param]),
				gen_tcp:send(Socket,  <<"404 Not Found">>),
				{http_request,  no_right};	
		_ ->
		case [Cmd, Param] of	
			["get_node_status", _] ->
				Data = get_nodes_info(), 
				Data_len = length(tool:to_list(Data)),
				if Data_len == 0 ->
					   	gen_tcp:send(Socket, <<"error!">>);
					true -> 
						gen_tcp:send(Socket, Data)
				end;
			["cl", Parm] ->		
				Data = reload_module(Parm), 
				Data_len = length(tool:to_list(Data)),
				if Data_len == 0 ->
					   	gen_tcp:send(Socket, <<"error!">>);
					true -> 
						gen_tcp:send(Socket, Data)
				end;
			["kickuser", Parm] ->	
				operate_to_player(kickuser, http_lib:url_decode(Parm)),
				gen_tcp:send(Socket, <<"success">>);	
			["banchat", Parm] ->
				Info = string:tokens(Parm, "="),
				if 
					length(Info) =:= 4 ->
						[Nick, BanDate, IsBan, Msg] = Info;
					true ->
						[Nick, BanDate, IsBan] = Info,
						Msg = []
				end,
				operate_to_player(banchat, [http_lib:url_decode(Nick), list_to_integer(BanDate),
											list_to_integer(IsBan), http_lib:url_decode(Msg)]),
				gen_tcp:send(Socket, <<"success">>);
			["forbid_login", Parm] ->
				Info = string:tokens(Parm, "="),
				if 
					length(Info) =:= 4 ->
						[Nick, Forbid_Date, IsForbid, Msg] = Info;
					true ->
						[Nick, Forbid_Date, IsForbid] = Info,
						Msg = []
				end,
				operate_to_player(forbid_login, [http_lib:url_decode(Nick), list_to_integer(Forbid_Date),
											list_to_integer(IsForbid), http_lib:url_decode(Msg)]),
				gen_tcp:send(Socket, <<"success">>);
			["forbid_login_byid", Parm] ->
				Info = string:tokens(Parm, "="),
				if 
					length(Info) =:= 4 ->
						[Id, Forbid_Date, IsForbid, Msg] = Info;
					true ->
						[Id, Forbid_Date, IsForbid] = Info,
						Msg = []
				end,
				operate_to_player(forbid_login_byid, [list_to_integer(Id), list_to_integer(Forbid_Date),
											list_to_integer(IsForbid), http_lib:url_decode(Msg)]),
				gen_tcp:send(Socket, <<"success">>);
			["safe_quit", Parm] ->	
				gen_tcp:send(Socket, <<"success">>),
				safe_quit(Parm),
				gen_tcp:send(Socket, <<"success">>),
				ok;	
			["online_count", _Parm] ->		
				Data = get_online_count(), 
				Data_len = length(tool:to_list(Data)),
				if Data_len == 0 ->
					   	gen_tcp:send(Socket, <<"0">>);
					true -> 
						gen_tcp:send(Socket, Data)
				end;
			["complain_reply", Parm] ->
				[RecId, RecNick, SendNick, Context] = string:tokens(Parm, "="),		
				lib_mail:send_sys_mail(http_lib:url_decode(SendNick), ?GM_ID,  http_lib:url_decode(RecNick), list_to_integer(RecId), [], ?Mail_Type_GM,
									   ?_LANG_GM_INFO_MAIL_TITLE, http_lib:url_decode(Context), 0, 0, 0, 0),
				gen_tcp:send(Socket, <<"success">>);
			["player_break_away", Parm] ->
				[UserId] = string:tokens(Parm, "="),		
				Pid = lib_player:get_player_pid(UserId),
				gen_server:cast(Pid, {player_break_away}),
				gen_tcp:send(Socket, <<"success">>);
			["admin_send_gift", Parm] ->
				[ItemInfo,MoneyInfo,UserInfo,Title, Content] = string:tokens(Parm, "="),
				lib_mail:send_mail_multiple_item(http_lib:url_decode(ItemInfo),http_lib:url_decode(MoneyInfo),http_lib:url_decode(UserInfo),http_lib:url_decode(Title),http_lib:url_decode( Content)),
				gen_tcp:send(Socket, <<"success">>);
			["admin_send_gift2", Parm] ->
				[ItemInfo,MoneyInfo,UserInfo,Title, Content] = string:tokens(Parm, "="),
				lib_mail:send_mail_multiple_item_by_userName(http_lib:url_decode(ItemInfo),http_lib:url_decode(MoneyInfo),http_lib:url_decode(UserInfo),http_lib:url_decode(Title),http_lib:url_decode( Content)),
				gen_tcp:send(Socket, <<"success">>);
			["send_sys_mail",Parm] ->
				[Search,Title, Content] = string:tokens(Parm, "="),
				[AccountString,Action,Min_lev,Max_lev] = string:tokens(http_lib:url_decode(Search), "$"),
				lib_mail:send_mail_multiple(AccountString,list_to_integer(Action),list_to_integer(Min_lev),list_to_integer(Max_lev),http_lib:url_decode(Title),http_lib:url_decode(Content)),
				gen_tcp:send(Socket, <<"success">>);
			["send_sys_msg", Parm] ->
				[ID,OP,MsgType, SendType, StartTime, EndTime, Interval, Content] = string:tokens(Parm, "="),	
				mod_sysmsg:update_msg(list_to_integer(ID),list_to_integer(OP),http_lib:url_decode(MsgType),list_to_integer(SendType),list_to_integer(StartTime),list_to_integer(EndTime),list_to_integer(Interval),http_lib:url_decode(Content)),
				gen_tcp:send(Socket, <<"success">>);	
			["get_map_player_count", _] ->
				MapList = ets:tab2list(?ETS_MAP_TEMPLATE),			
				Fun = fun(MapInfo, InfoData) ->
							  if
								  MapInfo#ets_map_template.type =:= 1 ->
									  Map_Pid = mod_map:get_scene_pid(MapInfo#ets_map_template.map_id),
									  Num = gen_server:call(Map_Pid,{'total_player'}),
									  lists:concat([InfoData, '|', MapInfo#ets_map_template.map_id, ',', Num]);
								  true ->
									  InfoData
							  end
					  end,
				Res = lists:foldl(Fun, [[]], MapList),
				gen_tcp:send(Socket, tool:to_binary(Res));
			["user_pay", Parm] ->
				[TempUserName, Site] = string:tokens(Parm, "="),
				UserName = http_lib:url_decode(TempUserName),
				PlayerProcessSiteUserName = misc:player_process_site_and_username(Site, UserName),
				case misc:whereis_name({global, PlayerProcessSiteUserName}) of
					Pid when is_pid(Pid) ->
						PayInfo = db_agent_admin:get_user_pay(Site, UserName),
						case PayInfo of
							[] ->
								skip;
							_ ->
								gen_server:cast(Pid,{'user_pay', PayInfo})
						end;
					_ -> 
						skip
				end,
				gen_tcp:send(Socket, <<"success">>);
			["unite_pay", Parm] ->
				[TempUserName, Site, ServerId] = string:tokens(Parm, "="),
				UserName = http_lib:url_decode(TempUserName),
				PlayerProcessSiteUserName = misc:player_process_site_and_username(Site, UserName),
				case misc:whereis_name({global, PlayerProcessSiteUserName}) of
					Pid when is_pid(Pid) ->
						gen_server:cast(Pid,{'unite_pay',UserName,Site,list_to_integer(ServerId)});
					_ -> 
						skip
				end,
				gen_tcp:send(Socket, <<"success">>);
			["multexp_control", Parm] ->
				[Mult_ID, TempIsOpen] = string:tokens(Parm, "="),
				IsOpen = list_to_integer(TempIsOpen),
				L1 = mod_node_interface:server_list(),
							L = 
								case ets:match(?ETS_SYSTEM_INFO,{'_', server_node_info, '$3'}) of
									[[My_server_node]] -> L1 ++ [My_server_node];
									_ -> L1
								end,
				if IsOpen =:= 1 ->
					case db_agent_admin:get_mult_by_id(list_to_integer(Mult_ID)) of
						[] ->
							skip;
						[Exp_rate, Begin_date, End_date, Begin_time, End_time] ->
							lists:foreach(fun(S) ->  rpc:cast(S#t_server_node.node, lib_statistics, set_multexp, 
													[{list_to_integer(Mult_ID), IsOpen, Exp_rate, Begin_date, End_date, Begin_time, End_time}]) end, L);
						_ ->
							skip
					end;
				   true ->
					   lists:foreach(fun(S) ->  rpc:cast(S#t_server_node.node, lib_statistics, set_multexp, 
													[{list_to_integer(Mult_ID), IsOpen, 0, 0, 0, 0, 0}]) end, L)
				end,
				gen_tcp:send(Socket, <<"success">>);
			["open_active",Parm] ->
				mod_active:open_active(list_to_integer(Parm)),
				gen_tcp:send(Socket, <<"success">>);
			
			_ -> 		
				?PRINT("Error _ Cmd ~n"),
				error_cmd
		end
	end
	  catch
		_:Reason ->
			?WARNING_MSG("misc_admin is exception:~w~n",[Reason])
	end.


%% 获取在线人数
get_online_count() ->
	Total_user_count = get_online_count(num),
	lists:concat(['online_count:',Total_user_count]).

get_online_count(num) ->
	L1 = mod_node_interface:server_list(),
	L = 
		case ets:match(?ETS_SYSTEM_INFO,{'_', server_node_info, '$3'}) of
			[[My_server_node]] -> L1 ++ [My_server_node];
			_ -> L1
		end,	
	Count_list =
    if 
        L == [] -> [0];
        true ->
			Info_list =
				lists:map(
			  		fun(S) ->
						{_Node_name, User_count} = 
					  		case rpc:call(S#t_server_node.node, mod_node_interface, online_state, []) of
								{badrpc, _} ->
                                    {error, 0};
                                [_State, Num, _] ->
                                    {S#t_server_node.node, Num}
							end,
						User_count
					end,
			  		L),
			Info_list
    end,
	lists:sum(Count_list).

%% 获取节点列表
get_node_info_list() ->
	L1 = mod_node_interface:server_list(),
	L2 = 
		case ets:match(?ETS_SYSTEM_INFO,{'_', server_node_info, '$3'}) of
			[[My_server_node]] -> L1 ++ [My_server_node];
			_ -> L1
		end,	
	L = lists:usort(L2),
	Info_list =
		lists:map(
	  		fun(S) ->
				{Node_status, Node_name, User_count} = 
			  		case rpc:call(S#t_server_node.node, mod_node_interface, online_state, []) of
						{badrpc, _} ->
                              {fail, S#t_server_node.node, 0};
                       [_State, Num, _] ->
                              {ok,   S#t_server_node.node, Num}
					end,	
				Node_info = 
					try 
					case rpc:call(S#t_server_node.node, misc_admin, node_info, []) of
				  		{ok, Node_info_0} ->
							Node_info_0;
						_ ->
							error
					end
					catch
						_:_ -> error
					end,							
				{Node_status, Node_name, User_count, Node_info}
			end,
	  		L),
	{ok, Info_list}.

% 获取各节点状态
get_nodes_info() ->
	case get_node_info_list() of
		{ok, Node_info_list} ->
			Count_list =
				lists:map(
				  fun({_Node_status, _Node_name, User_count, _Node_info})->
						  User_count
				  end,
				  Node_info_list),	
			Total_user_count = lists:sum(Count_list),	
			
			Node_ok_list =
				lists:map(
				  fun({Node_status, _Node_name, _User_count, _Node_info})->
						  case Node_status of
							  fail -> 0;
							  _ ->  1
						  end
				  end,
				  Node_info_list),	
			Total_node_ok = lists:sum(Node_ok_list),	
			Temp1 = 
				case Total_node_ok =:= length(Node_info_list) of
					true -> [];
					_ -> lists:concat(['/',Total_node_ok])
				end,
			
			All_Connect_count_str = lists:concat(['Nodes_count: [', length(Node_info_list),
								'] ,total_connections: [', Total_user_count, Temp1,
								']    [',misc:time_format(misc_timer:now()),
								']']),
			Info_list =
				lists:map(
				  fun({Node_status, Node_name, _User_count, Node_info})->
						  case Node_status of
							  fail ->
								lists:concat(['Node: ',Node_name,'[Warning: this node may be crashed or busy.]\t\n']);
							  _ ->
								lists:concat(['Node: ',Node_name,'\t\n',Node_info])
						  end
				  end,
				  Node_info_list),	

			lists:concat([All_Connect_count_str, 
						'\t\n', 
						'------------------------------------------------------------------------\t\n',
						Info_list]);		
		_ ->
			''
	end.

%% 获取本节点的基本信息
node_info() ->
  	Info = get_node_info(),
 	{ok, Info}.

get_node_info() ->
	Server_no = 
		case ets:match(?ETS_SYSTEM_INFO,{'_',server_no,'$3'}) of
			[[S_no]] -> S_no;
			_ -> undefined
		end,
	Log_level = 
		case ets:match(?ETS_SYSTEM_INFO,{'_',log_level,'$3'}) of
			[[Log_l]] -> Log_l;
			_ -> undefined
		end,	
												 
	Info_log_level = lists:concat(['    Server_no:[', Server_no
								   ,'], Log_level:[', Log_level
								   ,'], Process_id:[',os:getpid(),']\t\n']),
	 
	Info_tcp_listener =	
		lists:concat(
			case ets:match(?ETS_SYSTEM_INFO,{'_',tcp_listener,'$3'}) of
				[[{Host_tcp, Port_tcp, Start_time}]] ->
					['    Tcp listener? [Yes]. IP:[',Host_tcp,
					 		'], Port:[',Port_tcp,
					 		'], Connections:[',ets:info(?ETS_ONLINE, size),
					 		'], Start_time:[',misc:time_format(Start_time),					 		
					 		']\t\n'];
				_ ->
					[]
			end),
	
	Info_mysql =	
		lists:concat(
			case ets:match(?ETS_SYSTEM_INFO,{'_',mysql,'$3'}) of
				[[{Host_mysql, Port_mysql, User_mysql, DB_mysql, Encode_mysql}]] ->
					['    Mysql connected? [Yes]. IP:[',Host_mysql,
					 		'], Port:[',Port_mysql,
					 		'], User:[',User_mysql,
					 		'], DB:[',DB_mysql,
					 		'], Encode:[',Encode_mysql,
					 		']\t\n'];
				_ ->
					[]
			end),
	
	Info_mongo =	
		lists:concat(
			case ets:match(?ETS_SYSTEM_INFO,{'_',mongo,'$3'}) of
				[[{PoolId_mongo, Host_mongo, Port_mongo, DB_mongo, EmongoSize_mongo}]] ->
					['    Mongodb master? [Yes]. PoolId:[',PoolId_mongo,
					 		'], Host:[',Host_mongo,
					 		'], Port:[',Port_mongo,
					 		'], DB:[',DB_mongo,
					 		'], Size:[',EmongoSize_mongo,
					 		']\t\n'];
				_ ->
					[]
			end),
	
	Info_mongom_slave =	
		lists:concat(
			case ets:match(?ETS_SYSTEM_INFO,{'_',mongo_slave,'$3'}) of
				[[{PoolId_mongo_slave, Host_mongo_slave, Port_mongo_slave, DB_mongo_slave, EmongoSize_mongo_slave}]] ->
					['    Mongodb slave? [Yes]. PoolId:[',PoolId_mongo_slave,
					 		'], Host:[',Host_mongo_slave,
					 		'], Port:[',Port_mongo_slave,
					 		'], DB:[',DB_mongo_slave,
					 		'], Size:[',EmongoSize_mongo_slave,
					 		']\t\n'];
				_ ->
					[]
			end),
	
	Info_stat_socket = 
		try
			case ets:info(?ETS_STAT_SOCKET) of
				undefined ->
					[];
				_ ->
					Stat_list_socket_out = ets:match(?ETS_STAT_SOCKET,{'$1', socket_out , '$3','$4'}),
					Stat_list_socket_out_1 = lists:sort(fun([_,_,Count1],[_,_,Count2]) -> Count1 > Count2 end, Stat_list_socket_out),
					Stat_list_socket_out_2 = lists:sublist(Stat_list_socket_out_1, 10),
					Stat_info_socket_out = 
					lists:map( 
	  					fun(Stat_data) ->
							case Stat_data of				
								[Cmd, BeginTime, Count] ->
									TimeDiff = timer:now_diff(misc_timer:now(), BeginTime)/(1000*1000)+1,
									lists:concat(['        ','Cmd:[', Cmd, 
												'], packet_avg/sec:[', Count, '/',round(TimeDiff),' = ',round(Count / TimeDiff),']\t\n']);
								_->
									''
							end 
	  					end, 
						Stat_list_socket_out_2),
					if length(Stat_info_socket_out) > 0 ->
						lists:concat(['    Socket packet_out statistic_top10:\t\n', Stat_info_socket_out]);
			   		   true ->
				   		[]
					end			
			end
		catch
			_:_ -> []
		end,	
	
	Info_stat_db = 
		try
			case ets:info(?ETS_STAT_DB) of
				undefined ->
					[];
				_ ->
					Stat_list_db = ets:match(?ETS_STAT_DB,{'$1', '$2', '$3', '$4', '$5'}),
					Stat_list_db_1 = lists:sort(fun([_,_,_,_,Count1],[_,_,_,_,Count2]) -> Count1 > Count2 end, Stat_list_db),
					Stat_list_db_2 = lists:sublist(Stat_list_db_1, 5), 
					Stat_info_db = 
					lists:map( 
	  					fun(Stat_data) ->
							case Stat_data of				
								[_Key, Table, Operation, BeginTime, Count] ->
									TimeDiff = timer:now_diff(misc_timer:now(), BeginTime)/(1000*1000)+1,
									lists:concat(['        ','Table:[', lists:duplicate(30-length(tool:to_list(Table))," "), Table, 
												'], op:[', Operation,
												'], avg/sec:[', Count, '/',round(TimeDiff),' = ',round(Count / TimeDiff),']\t\n']);
								_->
									''
							end 
	  					end, 
						Stat_list_db_2),
					if length(Stat_info_db) > 0 ->
						lists:concat(['    Table operation statistic_top5:\t\n', Stat_info_db]);
			   		   true ->
				   		[]
					end			
			end
		catch
			_:_ -> []
		end,	

	Process_info_detail = 
		try
			get_monitor_process_info_list()
		catch
			_:_ -> {ok, []} 
		end,
	
	Info_process_queue_top = 
		try
			case get_process_info(Process_info_detail, 5, 2, 0, msglen) of 
				{ok, Process_queue_List, Process_queue_List_len} ->
					Info_process_queue_list = 
					lists:map( 
	  					fun({Pid, RegName, Mlen, Qlen, Module, Other, Messgaes}) ->
							if 	is_atom(RegName) -> 
									lists:concat(['        ','regname:[', RegName, erlang:pid_to_list(Pid), 
												  '],q:[', Qlen ,
												  '],m:[', Mlen ,
												  '],i:[', Other ,
												  Messgaes ,
												  ']\t\n']);
								is_atom(Module) ->
									lists:concat(['        ','module:[', Module, erlang:pid_to_list(Pid), 
												  '],q:[', Qlen ,
												  '],m:[', Mlen ,
												  '],i:[', Other ,
												  Messgaes ,
												  ']\t\n']);
								true ->
									lists:concat(['        ','pid:[', erlang:pid_to_list(Pid) ,
												  '],q:[', Qlen ,
												  '],m:[', Mlen ,
												  '],i:[', Other ,
												  Messgaes ,
												  ']\t\n'])
							end	
						end,
					Process_queue_List),
					lists:concat(['    Message_queue_top5: [', Process_queue_List_len, ' only processes being monitored', ']\t\n',Info_process_queue_list]);
				_ ->
					lists:concat(['    Message_queue_top5: [error_1]\t\n'])
			end
		catch
			_:_ -> lists:concat(['    Message_queue_top5: [error_2]\t\n'])
		end,
	
	Info_process_memory_top = 
		try
			case get_process_info(Process_info_detail, 5, 0, 0, memory) of 
				{ok, Process_memory_List, Process_memory_List_len} ->
					Info_process_memory_list = 
					lists:map( 
	  					fun({Pid, RegName, Mlen, Qlen, Module, Other, _Messgaes}) ->
							if 	is_atom(RegName) -> 
									lists:concat(['        ','regname:[', RegName, erlang:pid_to_list(Pid), 
												  '],q:[', Qlen ,
												  '],m:[', Mlen ,
												  '],i:[', Other ,
												  ']\t\n']);
								is_atom(Module) ->
									lists:concat(['        ','module:[', Module, erlang:pid_to_list(Pid), 
												  '],q:[', Qlen ,
												  '],m:[', Mlen ,
												  '],i:[', Other ,
												  ']\t\n']);
								true ->
									lists:concat(['        ','pid:[', erlang:pid_to_list(Pid) ,
												  '],q:[', Qlen ,
												  '],m:[', Mlen ,
												  '],i:[', Other ,
												  ']\t\n'])
							end	
						end,
					Process_memory_List),
					lists:concat(['    Process_memory_top5: [', Process_memory_List_len,' only processes being monitored', ']\t\n',Info_process_memory_list]);
				_ ->
					lists:concat(['    Message_memory_top5: [error_1]\t\n'])
			end
		catch
			_:_ -> lists:concat(['    Message_memory_top5: [error_2]\t\n'])
		end,

	System_process_info = 
		try
			lists:concat(["    System process: \t\n",
						 "        ",
						 "process_count:[", erlang:system_info(process_count) ,'],',
						 "processes_limit:[", erlang:system_info(process_limit) ,'],',
						 "ports_count:[", length(erlang:ports()),']',
						 "\t\n"
						])
		catch
			_:_ -> []
		end,
	
	System_memory_info = 
		try
			lists:concat(["    System memory: \t\n",
						 "        ",
						 "total:[", erlang:memory(total) ,'],',
						 "processes:[", erlang:memory(processes) ,'],',
						 "processes_used:[", erlang:memory(processes_used) ,'],\t\n',
						 "        ",
						 "system:[", erlang:memory(system) ,'],',
						 "atom:[", erlang:memory(atom) ,'],',
						 "atom_used:[", erlang:memory(atom_used) ,'],\t\n',
						 "        ",
						 "binary:[", erlang:memory(binary) ,'],',
						 "code:[", erlang:memory(code) ,'],',
						 "ets:[", erlang:memory(ets) ,']',
						 "\t\n"
						])
		catch
			_:_ -> []
		end,
	
	LL1 = string:tokens(binary_to_list(erlang:system_info(info)),"="),
	Atom_tab =
		case lists:filter(fun(I)-> string:str(I,"index_table:atom_tab") == 1 end, LL1) of
			[] -> [];
			[Index_table] -> binary:replace(list_to_binary(Index_table), <<"\n">>, <<", ">>, [global])
		end,
	System_other_info = 
		try
			System_load = mod_node_interface:get_system_load(),
			{{input,Input},{output,Output}} = statistics(io),
			
			lists:concat(["    System other: \t\n",
						 "        ",
						 "atom_tab:[", binary_to_list(Atom_tab) ,'],\t\n', 
						 "        ",						  
						 "run_queue:[", statistics(run_queue) ,'],',
						 "input:[", Input ,'],',
						 "output:[", Output ,'],',
						 "wallclock_time:[", io_lib:format("~.f", [System_load]) ,'],',						  
						 "\t\n"
						])
		catch
			_:_ -> []
		end,

	Info_mod_guild =	
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_guild ,'$3'}) of
				[[GuildPid, _]] ->
					['    Mod_guild here? [yes]. Pid:[',erlang:pid_to_list(GuildPid),
					 		']\t\n'];
				_ ->
					[]				
			end),	

	Info_mod_sale =	
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_sale ,'$3'}) of
				[[SalePid, _]] ->
					['    Mod_sale here? [yes]. Pid:[',erlang:pid_to_list(SalePid),
					 		']\t\n'];
				_ ->
					[]				
			end),

	Info_mod_rank =	
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_rank ,'$3'}) of
				[[RankPid, _]] ->
					['    Mod_rank here? [yes]. Pid:[',erlang:pid_to_list(RankPid),
					 		']\t\n'];
				_ ->
					[]			
			end),

	Info_mod_shop =	
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_shop ,'$3'}) of
				[[ShopPid, _]] ->
					['    Mod_shop here? [yes]. Pid:[',erlang:pid_to_list(ShopPid),
					 		']\t\n'];
				_ ->
					[]			
			end),
		
	Info_mod_master_apprentice = 
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_master_apprentice ,'$3'}) of
				[[MasterPid, _]] ->
					['    Mod_master_apprentice here? [yes]. Pid:[',erlang:pid_to_list(MasterPid),
					 		']\t\n'];
				_ ->
					[]				
			end),		

	Info_mod_dungeon_analytics = 
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_dungeon_analytics ,'$3'}) of
				[[DungeonAlyPid, _]] ->
					['    Mod_dungeon_analytics here? [yes]. Pid:[',erlang:pid_to_list(DungeonAlyPid),
					 		']\t\n'];
				_ ->
					[]				
			end),	
	
	Info_mod_carry =	
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_carry ,'$3'}) of
				[[CarryPid, _]] ->
					['    Mod_carry here? [yes]. Pid:[',erlang:pid_to_list(CarryPid),
					 		']\t\n'];
				_ ->
					[]			
			end),

	Info_mod_system =	
		lists:concat(
		    case ets:match(?ETS_MONITOR_PID,{'$1', mod_system ,'$3'}) of
				[[SystemPid, _]] ->
					['    Mod_system here? [yes]. Pid:[',erlang:pid_to_list(SystemPid),
					 		']\t\n'];
				_ ->
					[] 			
			end),
	
	Info_scene =  
		try 
			case ets:info(?ETS_MONITOR_PID) of
				undefined ->
					[];
				_ ->
					Stat_list_scene = ets:match(?ETS_MONITOR_PID,{'$1', mod_scene ,'$3'}),
					Stat_info_scene = 
						lists:map( 
						  fun(Stat_data) ->
								  case Stat_data of				
									  [_SceneAgentPid, {SceneId, Worker_Number}] ->
										  MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id =:= SceneId  -> 
																  [T#ets_users.id] 
														  end),
										  Players = ets:select(?ETS_ONLINE, MS),
										  lists:concat([SceneId,'(', Worker_Number ,')_', length(Players), ', ']);
									  _->
										  ''
								  end
						  end,
						  Stat_list_scene),
					case Stat_list_scene of
						[] -> [];
						_ -> lists:concat(['    Scene here: [',Stat_info_scene,']\t\n'])
					end
			end
		catch
			_:_ -> []
		end,
	
	Info_dungeon = 
		try
			case ets:info(?ETS_MONITOR_PID) of
				undefined ->
					[];
				_ ->
					Stat_list_dungeon = ets:match(?ETS_MONITOR_PID,{'$1', mod_dungeon ,'$3'}),
					Stat_info_dungeon = [],
%% 					lists:map( 
%% 	  					fun(Stat_data) ->
%% 							case Stat_data of				
%% 								[_,{{_,Dungeon_scene_id, Scene_id, _, Dungeon_role_list,_ ,_, _ }}] ->
%% 									lists:concat([Scene_id,'(',Dungeon_scene_id,')','_', length(Dungeon_role_list), ', ']);
%% 								_->
%% 									''
%% 							end 
%% 	  					end, 
%% 						Stat_list_dungeon),
					case Stat_list_dungeon of
						[] -> [];
						_ -> lists:concat(['    Dungeon here: [',Stat_info_dungeon,']\t\n'])
					end			
			end
		catch
			_:_ -> []
		end,	

	lists:concat([Info_log_level, 
				Info_mod_guild, Info_mod_sale, Info_mod_rank, Info_mod_shop, Info_mod_master_apprentice,
				Info_mod_dungeon_analytics, Info_mod_carry, Info_mod_system,
				Info_scene, Info_dungeon, 
				Info_tcp_listener, Info_stat_socket,
				Info_mysql, Info_mongo, Info_mongom_slave, Info_stat_db, 
				Info_process_queue_top, Info_process_memory_top, 
				System_process_info, System_memory_info, System_other_info,
				'------------------------------------------------------------------------\t\n']).

get_process_info(Process_info_detail, Top, MinMsgLen, MinMemSize, OrderKey) ->
	case Process_info_detail of
		{ok, RsList} ->
			Len = erlang:length(RsList),
			FilterRsList = 
			case OrderKey of 
				msglen ->
					lists:filter(fun({_,_,_,Qlen,_,_,_}) -> Qlen >= MinMsgLen end, RsList);
				memory ->
					lists:filter(fun({_,_,Qmem,_,_,_,_}) -> Qmem >= MinMemSize end, RsList);
				_ ->
					lists:filter(fun({_,_,_,Qlen,_,_,_}) -> Qlen >= MinMsgLen end, RsList)
			end,
			RsList2 = 
				case OrderKey of
					msglen ->
						lists:sort(fun({_,_,_,MsgLen1,_,_,_},{_,_,_,MsgLen2,_,_,_}) -> MsgLen1 > MsgLen2 end, FilterRsList);
					memory ->
						lists:sort(fun({_,_,MemSize1,_,_,_,_},{_,_,MemSize2,_,_,_,_}) -> MemSize1 > MemSize2 end, FilterRsList);
					_ ->
						lists:sort(fun({_,_,_,MsgLen1,_,_,_},{_,_,_,MsgLen2,_,_,_}) -> MsgLen1 > MsgLen2 end, FilterRsList)
				end,
			NewRsList = 
				if Top =:= 0 ->
					   RsList2;
				   true ->
					   if erlang:length(RsList2) > Top ->
							  lists:sublist(RsList2, Top);
						  true ->
							  RsList2
					   end
				end,
			{ok,NewRsList, Len};
		_->
			{error,'error'}
	end.

get_process_info_detail_list(Process, NeedModule, Layer) ->
	RootPid =
		if erlang:is_pid(Process) ->
			   Process;
		   true ->
			   case misc:whereis_name({local, Process}) of
				   undefined ->
					   error;
				   ProcessPid ->
					   ProcessPid
			   end
		end,
	case RootPid of
		error ->
			{error,lists:concat([Process," is not process reg name in the ", node()])};
		_ ->
			AllPidList = misc:get_process_all_pid(RootPid,Layer),
			RsList = misc:get_process_info_detail(NeedModule, AllPidList,[]),
			{ok, RsList}
	end.

get_monitor_process_info_list() ->
	Monitor_process_info_list =	
		try
			case ets:match(?ETS_MONITOR_PID,{'$1','$2','$3'}) of
				List when is_list(List) ->
					lists:map(
					  	fun([Pid, Module, Pars]) ->
							get_process_status({Pid, Module, Pars})
						end,
						List);	 
				_ ->
					[]
			end
		catch
			_:_ -> []
		end,			
	{ok, Monitor_process_info_list}.

%% get_process_status({Pid, Module, Pars}) when Module =/= mcs_role_send ->
%% 	{'', '', -1, -1, '', '', ''};
get_message_queue_len(Pid) ->
	try 
	    case erlang:process_info(Pid, [message_queue_len]) of
			[{message_queue_len, Qlen}] ->	Qlen;
			 _ -> -1
		end
	catch 
		_:_ -> -2
	end.

get_process_status({Pid, Module, Pars}) ->
	Other = 
		case Module of
			mod_player -> 
				{PlayerId} = Pars,
				case erlang:process_info(Pid,[dictionary]) of
					undefined -> 
						lists:concat([PlayerId, "__", dead]);
					[{_, Dic1}] ->
						case lists:keyfind(last_msg, 1, Dic1) of 
							{last_msg, Last_msg} -> 
								Last_msg1 = io_lib:format("~p", Last_msg),
								lists:concat([PlayerId, "__", Last_msg1]);
							_-> 	
								lists:concat([PlayerId])
						end
				end;			
			_->
				''
		end,
	
	try 
	 case erlang:process_info(Pid, [message_queue_len,memory,registered_name, messages]) of
		[{message_queue_len,Qlen},{memory,Mlen},{registered_name, RegName},{messages, _MessageQueue}] ->
			Messages = '',
			{Pid, RegName, Mlen, Qlen, Module, Other, Messages};
		_ -> 
			{'', '', -1, -1, '', '', ''}
	 end
	catch 
		_:_ -> {'', '', -1, -1, '', '', ''}
	end.


%% ===================针对玩家的各类操作=====================================
operate_to_player(Method, Args) ->
	case Method of
		kickuser ->
			Id = lib_player:get_role_id_by_name(Args),
			case lib_player:get_player_pid(Id) of
				[] ->
					skip;
				Pid ->
					gen_server:cast(Pid, {stop, admin})
			end;
		banchat ->
			[Nick, BanDate, IsBan, Reason] = Args,
			Id = lib_player:get_role_id_by_name(Nick),
			case lib_player:get_player_pid(Id) of
				[] ->
					skip;
				Pid ->
					gen_server:cast(Pid, {ban_chat, IsBan, BanDate, Reason})
			end;
		forbid_login ->
			[Nick, ForbidDate, IsForbid, Reason] = Args,
			case IsForbid of
				1 ->
					db_agent_user:delete_forbid_status(Nick);
				0 ->
					Id = lib_player:get_role_id_by_name(Nick),
					case lib_player:get_player_pid(Id) of
						[] ->
							db_agent_user:set_forbid_status_by_nick(Nick,ForbidDate);
						Pid ->
							gen_server:cast(Pid, {forbid_login, IsForbid, ForbidDate, Reason})
					end;
				_ ->
					skip
			end;
		forbid_login_byid ->
			[Id, ForbidDate, IsForbid, Reason] = Args,
			case IsForbid of
				1 ->
					db_agent_user:delete_forbid_status_by_id(Id,ForbidDate);
				0 ->
					case lib_player:get_player_pid(Id) of
						[] ->
							db_agent_user:set_forbid_status_by_id(Id,ForbidDate);
						Pid ->
							gen_server:cast(Pid, {forbid_login, IsForbid, ForbidDate, Reason})
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end.

%% 取得本节点的角色状态
get_player_info_local(Id) ->
	case ets:lookup(?ETS_ONLINE, Id) of
   		[] -> [];
   		[_R] -> 
			[]
	end.

%% 安全退出游戏服务器
safe_quit(Node) ->
	case Node of
		[] ->
%% 			mod_node_interface:stop_game_server(ets:tab2list(?ETS_SERVER_NODE));
			main:server_stop_all();
		_ ->
			rpc:cast(tool:to_atom(Node), main, server_stop, [])
	end,
	ok.

%% 重新加载模块
reload_module(Module_name) ->
	try 
		case c:l(tool:to_atom(Module_name)) of
			{module, _Module_name} -> lists:concat(["reload (", Module_name, ") ok."]);
			{error, What} -> lists:concat(["reload (", Module_name, ") error_1[", What , "]."]);
			_ -> lists:concat(["reload (", Module_name, ") error_2."])
		end
	catch 
		_:_ -> lists:concat(["reload (", Module_name, ") error_3."])
	end.

%% 请求加载基础数据
load_base_data(Parm) ->
	Parm_1 = 
		case Parm of 
			[] -> [];
			_ -> [tool:to_atom(Parm)]
		end,
	mod_node_interface:load_base_data(ets:tab2list(?ETS_SERVER_NODE), Parm_1),
	ok.
