%%%-----------------------------------
%%% @Module  : mod_login
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 用户登陆
%%%-----------------------------------
-module(mod_login).

-include("common.hrl").

%% -compile(export_all).

-export([login/3, logout/2, stop_all/0]).

%%登陆检查入口
%%Data:登陆验证数据
%%Arg:tcp的Socket进程,socket ID
login(start, [Site, UserName, UserID, IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant], Socket) ->
	case lib_account:check_account(Site, UserName, UserID) of
		false ->
			{error, fail1};
		true ->
			check_duplicated_login(Site, UserName),		
			case mod_player:start(Site, UserName, UserID, IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant, Socket) of
				{ok, Pid} -> 
					{ok, Pid};
				_-> 
					mod_player:delete_player_ets(UserID),
					{error, fail2}
			end		
	end.
			
%% 检查此账号是否已经登录, 如果登录 则通知退出
check_duplicated_login(Site, UserName) ->    
	PlayerProcessSiteUserName = misc:player_process_site_and_username(Site,UserName),
	case misc:whereis_name({global, PlayerProcessSiteUserName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> 
					{ok, BinData} = pt_10:write(?PP_ACCOUNT_LOST_CONNECT, [1]),
					gen_server:cast(Pid,{send_to_sid, BinData}),
    				logout(Pid, 1),
					timer:sleep(500),					
					Pid;
				false -> undefined
			end;
		_ ->
			undefined
	end.

%% 把所有在线玩家踢出去
stop_all() ->
    L = ets:tab2list(?ETS_ONLINE),
    do_stop_all(L).

%% 让所有玩家自动退出
do_stop_all([]) -> ok;
do_stop_all([H | T]) ->
    logout(H#ets_users.other_data#user_other.pid, 0),
    do_stop_all(T).

%%退出登陆
logout(Pid, Reason) when is_pid(Pid) ->
    mod_player:stop(Pid, Reason),
    ok.
