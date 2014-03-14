%% Author: wangdahai
%% Created: 2013-9-27
%% Description: TODO: Add description to lib_sys_first
-module(lib_sys_first).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([init_sys_first/0,check_pvp_first/1,update_pvp_first/2,remove_pvp_first/0]).

%%
%% API Functions
%%

init_sys_first() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_sys_first] ++ Info),
                  ets:insert(?ETS_SYS_FIRST, Record)
           end,
    case db_agent_sys:get_sys_first() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.

check_pvp_first(UserId) ->
	case ets:lookup(?ETS_SYS_FIRST, ?PVP_FIRST_TYPE) of
		[] ->
			0;
		[Info] when Info#ets_sys_first.user_id =:= UserId ->
			1;
		_ ->
			0
	end.

update_pvp_first(UserId, Time) ->%%秒为单位
	ETime = misc_timer:now_seconds() + Time,
	case ets:lookup(?ETS_SYS_FIRST, ?PVP_FIRST_TYPE) of
		[] ->
			Record = #ets_sys_first{type = 1,
									user_id = UserId,
									expires_time = ETime},
			db_agent_sys:add_sys_first(Record),
			ets:insert(?ETS_SYS_FIRST, Record);
			%%更新数据库	
		[Re] ->
			NewInfo = Re#ets_sys_first{user_id = UserId,expires_time = ETime },
			db_agent_sys:update_sys_first(NewInfo),
			ets:insert(?ETS_SYS_FIRST, NewInfo)
%% 			ets:lookup_element(?ETS_SYS_FIRST, ?PVP_FIRST_TYPE, 
%% 					[{#ets_sys_first.user_id, UserId},{#ets_sys_first.expires_time, ETime}])
			%%更新数据库	
	end,
	gen_server:cast(mod_first_manage:get_mod_first_manage_pid(), {update_first}).

remove_pvp_first() ->
	case ets:lookup(?ETS_SYS_FIRST, ?PVP_FIRST_TYPE) of
		[] ->
			skip;
		[Record] ->
			NewInfo = Record#ets_sys_first{	user_id = 0,expires_time = 0 },
			db_agent_sys:update_sys_first(NewInfo),
			ets:insert(?ETS_SYS_FIRST, NewInfo),
			%?DEBUG("pvp____:~p",[Record#ets_sys_first.user_id]),
			case lib_player:get_online_info(Record#ets_sys_first.user_id)of
				[] ->
					skip;
				UserInfo ->
					gen_server:cast(UserInfo#ets_users.other_data#user_other.pid, {update_pvp_first, 0, UserInfo#ets_users.camp})
			end
	end.
%%
%% Local Functions
%%

