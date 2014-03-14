%% Author: Administrator
%% Created: 2011-3-15
%% Description: TODO: Add description to misc_account
-module(misc_account).

%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
%% -export([
%% 		 treat_http_request/2
%% 		]).

%%
%% API Functions
%%

%% 
%% 
%% %% 处理http请求
%% treat_http_request(Socket, Packet0) ->
%% 	case gen_tcp:recv(Socket, 0, ?RECV_TIMEOUT) of
%% 		{ok, Packet} ->
%% 			P = lists:concat([Packet0, tool:to_list(Packet)]),
%% 			check_http_command(Socket, tool:to_binary(P)),
%% 			{http_request, ok};
%% 		{error, Reason} ->
%% 			{http_request, Reason}
%% 	end.
%% 
%% get_cmd_parm(Packet) ->
%% 	Packet_list = string:to_lower(tool:to_list(Packet)),
%% 	try
%% 		case string:str(Packet_list, " ") of
%% 			0 -> no_cmd;
%% 			N -> CM = string:substr(Packet_list,2,N-2),
%% 				 case string:str(CM, "?") of
%% 					 0 -> [CM, ""];
%% 				 	N1 -> [string:substr(CM,1,N1-1),  string:substr(CM, N1+1)]
%% 				 end
%% 		end
%% 	catch
%% 		_:_ -> no_cmd
%% 	end.
%% 
%% %% 检查分析并处理http指令
%% check_http_command(Socket, Packet) ->
%% %% 		——加载角色信息:		/login_roles_list.ashx?					(ok)
%% %% 		——创建角色: 			/create_role.ashx?						(ok)
%% 	try
%% 		case get_cmd_parm(Packet) of
%% 			[Name, Param] ->	
%% %% 	io:format("check_http_command:~p ~n",[[Name, Param]]),				
%% 				http_handle(Name, Param, Socket),
%% 				ok;
%% 			_ -> 
%% 				error_cmd
%% 		end
%% 	catch 
%% 		_:_ -> error
%% 	end.
%% 
%% http_handle("crossdomain.xml", _Param, _Socket) ->
%% 	ok;
%% %% 	io:format("?FL_POLICY_FILE1:~s~n",[?FL_POLICY_FILE1]),
%% %% 	gen_tcp:send(Socket, ?FL_HTTP_HEAD),
%% 	
%% %% 	gen_tcp:send(Socket, ?FL_HTTP_TYPE),
%% %% 	gen_tcp:send(Socket, ?FL_POLICY_FILE1);
%% 
%% http_handle("login_roles_list.ashx", Param, Socket) ->
%%  	[_, User, _, Site, _, Time, _, Sign, _, _Rand] = string:tokens(Param, "=&"),
%% 	Ret = lib_account:is_valid(User, Site, Time, Sign),
%% 	case Ret of
%% 		true ->
%% 			L = lib_account:get_role_list(User, Site),
%% 			{ok, Bin} = write_roles_list(L),
%%             write_return_client(Socket, 1, "Success", Bin);
%% 		_ -> 
%% 			write_return_client(Socket, 0, "valid is fail", <<>>),
%% 			false
%% 	end;
%% 
%% http_handle("create_role.ashx", Param, Socket) ->
%% 	[_, User, _, Site, _, Time, _, Sign, _, Nick, _, Sex, _, Career, _, _Rand] = string:tokens(Param, "=&"),
%% 	Ret = lib_account:is_valid(User, Site, Time, Sign),
%% 	case Ret of
%% 		true ->
%% 			L = lib_account:get_role_list(User, Site),
%% 			case length(L) >= 1 of 
%% 				true ->
%% 			%% 		todo	创建角色失败,已经有角色
%% 					write_return_client(Socket, 0, "the account has nick", <<>>),
%% 					ignore;
%% 				false ->
%% 					do_create_role(Socket, Site, User, Nick, Sex, Career)
%% 			end;
%% 		_ -> 
%% 			write_return_client(Socket, 0, "valid is fail", <<>>),
%% 			false
%% 	end;
%% 
%% http_handle(Name, Param, Socket) ->
%% 	misc_admin:treate_http_command(Name, Param, Socket),	
%% 	ok.
%% 
%% 
%% write_return_client(Socket, IsSucc, Mess, Bin) ->
%% 	MessBin = tool:to_binary(Mess),
%%     MessLen = byte_size(MessBin),
%% 	SendData = <<IsSucc:8, MessLen:16, MessBin/binary, Bin/binary>>,
%% 	gen_tcp:send(Socket, SendData).
%% 
%% 
%% 
%% write_roles_list(L) ->
%%     N = length(L),
%%     F = fun([UserID, Username, Nickname, Sex, Level]) ->
%%             UL = byte_size(Username),
%% 			NL = byte_size(Nickname),
%%             <<UserID:64,  
%% 			  Sex:8, 
%% 			  Level:32, 
%% 			  UL:16, 
%% 			  Username/binary,
%% 			  NL:16,
%% 			  Nickname/binary>>
%%     end,
%%     LB = tool:to_binary([F(X) || X <- L]),
%%     {ok, <<N:16, LB/binary>>}.
%% 
%% 
%% 
%% do_create_role(Socket, Site, User, Nick, Sex, Career) ->
%% 	case lib_account:validate_name(Nick) of  %% 角色名合法性检测
%% 		{false, _Msg} ->
%%          %% todo 名称非法
%% 			write_return_client(Socket, 0, "nick is not accept", <<>>),
%% 			ignore;
%%        	true ->
%%             case lib_account:create_role(Site, User, Nick, Sex, Career) of
%%                 {true, UserId} ->			
%% 					write_return_client(Socket, 1, "success", <<UserId:64>>);
%%                 false ->
%%                  	%% todo 角色创建失败  系统问题
%% 					write_return_client(Socket, 1, "system is fail", <<>>)
%%             end
%%     end.

%%
%% Local Functions
%%

