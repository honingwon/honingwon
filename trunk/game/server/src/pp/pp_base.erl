%%%--------------------------------------
%%% @Module  : pp_base
%%% @Author  : ygzj
%%% @Created : 2010.09.23
%%% @Description:  基础功能
%%%--------------------------------------
-module(pp_base).
-export([handle/3]).
-include("common.hrl").
%% -include("record.hrl").

%%退出登陆
%% handle(?PP_ACCOUNT_LOGIN, Status, logout) ->
%%     gen_server:cast(Status#player.other#player_other.pid, 'LOGOUT'),
%%     {ok, BinData} = pt_10:write(?PP_ACCOUNT_LOGIN, []),
%%     lib_send:send_to_sid(Status#r_user_info.pid_send, BinData);

%%心跳包 
handle(?PP_ACCOUNT_HEARTBEAT, Status, _R) ->
	%?DEBUG("PP_ACCOUNT_HEARTBEAT:~p",[Status#ets_users.id]),
	Now = misc_timer:now_milseconds(),
	if	Status#ets_users.other_data#user_other.heartbeat_time =:= 0 ->
			NewOther = Status#ets_users.other_data#user_other{heartbeat_time = Now};
		Status#ets_users.other_data#user_other.heartbeat_time > Now - 26000 ->
			NewOther = Status#ets_users.other_data, 
		 	mod_player:stop(self(), "move is fast.");
		true ->
			NewOther = Status#ets_users.other_data#user_other{heartbeat_time = Now}
	end,
		NewStatus = Status#ets_users{other_data = NewOther},
	{update, NewStatus};

handle(_Cmd, _Status, _Data) ->
    ?DEBUG("pp_base no match", []),
    {error, "pp_base no match"}.
