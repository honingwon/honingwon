%%%--------------------------------------
%%% @Module  : pp_account
%%% @Author  : txj
%%% @Created : 2010.02.27
%%% @Description:用户账户管理
%%%--------------------------------------
-module(pp_account).
-export([handle/3]).
-include("common.hrl").

-define(GUEST_NAME, "游客").

%% -include("record.hrl").
-compile(export_all).

%%登陆验证
handle(?PP_ACCOUNT_LOGIN, [], {UserName, Site, Server_id, Tick, Sign}) ->
	Ret = lib_account:is_valid(UserName, Site, Server_id, Tick, Sign),
	case Ret of
		{true, NewSite,_} ->
			L = lib_account:get_role_list(UserName, Server_id, NewSite),
			{true, L, NewSite};	

		_ ->
			{error, ?_LANG_ACCOUNT_LOGIN_FAIL}
	end;


%% 创建角色,判断角色名是
handle(?PP_ACCOUNT_CREATE, Socket, [UserName, Site, Server_id, NickName, Sex, Career]) when  is_list(UserName), is_list(NickName)->
	L = lib_account:get_role_list(UserName, Server_id, Site),
	case length(L) >= 1 of 
		true ->
%% 		todo	创建角色失败,已经有角色
			ignore;
		false ->
    		case lib_account:validate_name(NickName) of  %% 角色名合法性检测
       			{false, Msg} ->
            			{ok, BinData} = pt_10:write(?PP_ACCOUNT_CREATE, [0, Msg , 0]),
            			lib_send:send_one(Socket, BinData);
        		true ->
            		case lib_account:create_role(Site, Server_id, UserName, NickName, Sex, Career) of
                		{true, UserId} ->		
							{ok, BinData} = pt_10:write(?PP_ACCOUNT_CREATE, [1, ?_LANG_ACCOUNT_CREATE_SUCCESS, UserId]),
							lib_send:send_one(Socket, BinData);
						is_exist ->
							{ok, BinData} = pt_10:write(?PP_ACCOUNT_CREATE, [0, ?_LANG_ACCOUNT_CREATE_IS_EXIST, 0]),
							lib_send:send_one(Socket, BinData);
                		false ->
                    		{ok, BinData} = pt_10:write(?PP_ACCOUNT_CREATE, [0, ?_LANG_ACCOUNT_CREATE_FAIL, 0]),
							lib_send:send_one(Socket, BinData)
            		end
    		end
	end,
	ok;

handle(?PP_ACCOUNT_GUEST, _Socket, []) ->
	Guest_id = mod_increase:get_guest_auto_id(), 
	NickName = lists:concat([?GUEST_NAME, tool:to_list(Guest_id)]),
	Sex = util:rand(0,1),
	Career = util:rand(1,3), 
    Site = "guest",
	lib_account:create_role(Site, tool:to_list(Guest_id), NickName, Sex, Career),
	%case lib_account:create_role(Site, tool:to_list(Guest_id), NickName, Sex, Career) of
	%	{true, UserId} ->
	%		{ok, BinData} = pt_10:write(?PP_ACCOUNT_GUEST, [1, ?_LANG_ACCOUNT_CREATE_SUCCESS, Guest_id, UserId]),
	%		lib_send:send_one(Socket, BinData);
	%	false ->
	%		{ok, BinData} = pt_10:write(?PP_ACCOUNT_CREATE, [0, ?_LANG_ACCOUNT_CREATE_FAIL, Guest_id, 0]),
	%		lib_send:send_one(Socket, BinData)
	%end,
	L = lib_account:get_role_list(tool:to_list(Guest_id), Site),
    {true, L, Site, tool:to_list(Guest_id)};	


%%心跳包
handle(?PP_ACCOUNT_HEARTBEAT, _Socket, _R) ->
	?DEBUG("~w",[heartbeat]),
	%目前客户端不需要回发
   % {ok, BinData} = pt_10:write(?PP_ACCOUNT_HEARTBEAT, []),
    %lib_send:send_one(Socket, BinData);
	ok;
	
%% 按照accid创建一个角色，或自动分配一个角色
%handle(10010, _Socket, Accid)->
 %	get_player_id(Accid);


handle(10020, _Socket, _R) ->
    lib_account:getin_createpage();

handle(Cmd, _Socket, Data) ->
    ?WARNING_MSG("handle_account no match_/~p/~p/", [Cmd, Data]),
    {error, "handle_account no match"}.


%%根据accid取id。
get_player_id(Accid)->
%% io:format("Accid__/~p/ ~n", [Accid]),	
	PlayerInfo = 
		case Accid =:= 0 of
			true -> [];
			false -> ?DB_MODULE:select_row(t_users, "id, nick_name", [{id, Accid}],[],[1])
		end,
    case PlayerInfo of
        [Id, Nickname]->
			{true, Accid, Id,  Nickname};
        []->
			Ret = misc:get_http_content(config:get_guest_account_url(server)),
			if Ret =:= ""  ->
				   	{true, 0, 0,  <<>>};
			   true ->
				   try
				   	[New_Accid, Name] = string:tokens(Ret, "/"),
					NewAccid = tool:to_integer(New_Accid),
            		Realm = 100, %%util:rand(1,3),
            		Career = util:rand(1,5),
            		Sex = util:rand(1,2),
					Result = 
            		case lib_account:create_role(NewAccid, Name, Name, Realm, Career, Sex, guest) of
                		{true, RoleId} ->
							{true, NewAccid, RoleId, Name};
                		false ->
							{true, 0, 0,  <<>>}
            		end,
					Result
				  catch
						_:_ -> {true, 0, 0,  <<>>}
				  end
			   end
    end.


