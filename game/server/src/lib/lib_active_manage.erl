%% Author: wangdahai
%% Created: 2013-4-17
%% Description: TODO: Add description to lib_active
-module(lib_active_manage).

%%
%% Include files
%%
-include("common.hrl"). 
%%
%% Exported Functions
%%
-export([init_active_open_time/0, active_loop/1, open_active/2, join_active/3, quit_active/3]).

%%
%% API Functions
%%
init_active_open_time() ->
	F = fun(Info,List) ->
				Record = list_to_tuple([ets_active_open_time_template] ++ Info),
				Open_Time = init_open_time(Record#ets_active_open_time_template.open_time),
				NewRecord = Record#ets_active_open_time_template{open_time = Open_Time},
				[NewRecord|List]
		end,
	case db_agent_template:get_active_open_time_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foldl(F, [], List);
		_ ->
			skip
	end.
	

%%管理活动开始时间
active_loop(ActiveList) ->
	Now = misc_timer:now_seconds(),
	Week = misc_timer:get_week(Now),
	
	F = fun(Info,List) ->
			case Info#ets_active_open_time_template.open_week band (1 bsl Week) of
				0 ->
					%?DEBUG("TIME INFO:~p",[Week]),
					[Info|List];
				_ ->
					Time = misc_timer:get_time(Now),
					case active_loop1(Info#ets_active_open_time_template.open_time, Time, Info) of
						[] ->
							%%移除数据库中数据
							List;
						NewInfo ->
							[NewInfo|List]
					end
					
			end	
		end,
	lists:foldl(F, [], ActiveList).

active_loop1([], _Time, Info) ->
	Info;
active_loop1([V|L], Time, Info) ->
	Temp = V - Time,
	if
		Temp < 0 ->
			active_loop1(L, Time, Info);
		Temp =< 60 andalso Info#ets_active_open_time_template.other =/= 1 -> %% 1表示活动能够已经开始
			case get_active_pid(Info#ets_active_open_time_template.active_id) of
						undifend ->
							?DEBUG("active is not exist:~p",[Info#ets_active_open_time_template.active_id]),
							Info#ets_active_open_time_template{other = 0, time = 0};
						Pid ->	
							gen_server:cast(Pid,{set_continue_time, Info#ets_active_open_time_template.continue_time}),	
							?WARNING_MSG("active start:~p",[{Pid,Info#ets_active_open_time_template.active_id}]),
							if	Info#ets_active_open_time_template.continue_time < 10 -> %%活动时长小于10秒的为一次性活动
									[];
								true ->
									gen_server:cast(mod_active:get_active_pid(), {start,Info#ets_active_open_time_template.active_id, Pid}),
									if Info#ets_active_open_time_template.active_id =:= ?QUESTION_ACTIVE_ID 
										orelse Info#ets_active_open_time_template.active_id =:= ?PATROL_ACTIVE_ID ->
											gen_server:cast(Pid, {set_question_award, Info#ets_active_open_time_template.award});
										true -> ok
									end,
									{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_START, [Info#ets_active_open_time_template.active_id, 1,
																				   Info#ets_active_open_time_template.continue_time]),
									lib_send:send_to_all(Bin),
									Info#ets_active_open_time_template{other = 1, time = V}
							end							
			end;			
%% 		Temp =< 1800 andalso Info#ets_active_open_time_template.other =:= 0 -> %% 0表示活动关闭中2表示活动即将开启
%% 			
%% 			{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_START, [Info#ets_active_open_time_template.active_id, 2]),
%% 			lib_send:send_to_all(Bin),
%% 			Info#ets_active_open_time_template{other = 2, time = V};
		true ->
			active_loop1(L, Time, Info)
	end.
	
%%临时使用开启指定活动
open_active(ActiveId,ActiveList) ->
	F = fun(Info,List) ->
			case Info#ets_active_open_time_template.active_id =:= ActiveId of
				true when(Info#ets_active_open_time_template.other =/= 1) ->
					case get_active_pid(ActiveId) of
						undifend ->
							[Info|List];
						Pid ->
							{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_START, [Info#ets_active_open_time_template.active_id, 1,
																			Info#ets_active_open_time_template.continue_time]),
							lib_send:send_to_all(Bin),
							gen_server:cast(mod_active:get_active_pid(), {start,ActiveId,Pid}),
							gen_server:cast(Pid, {set_continue_time, Info#ets_active_open_time_template.continue_time}),
							if ActiveId =:= ?QUESTION_ACTIVE_ID orelse ActiveId =:= ?PATROL_ACTIVE_ID ->
									gen_server:cast(Pid, {set_question_award, Info#ets_active_open_time_template.award});
								true -> ok
							end,
							NewInfo = Info#ets_active_open_time_template{other = 1},
							[NewInfo|List]
					end;
				false ->
					[Info|List]
			end
		end,
	lists:foldl(F, [], ActiveList).

join_active(ActiveId, SendPid, UserInfo) ->
	case get_active_pid(ActiveId) of
		undefine ->
			ok;
		Pid ->
			gen_server:cast(Pid, {join_active,SendPid, UserInfo})
	end.
quit_active(ActiveId, SendPid, UserId) ->
	case get_active_pid(ActiveId) of
		undefine ->
			ok;
		Pid ->
			gen_server:cast(Pid, {quit_active,SendPid, UserId})
	end.

%%
%% Local Functions
%%
init_open_time(Open_Time) ->
	SList = string:tokens(binary_to_list(Open_Time), ","),
	F = fun(S, L) ->
			case string:tokens(S, ":") of
				[M,N] ->
					{V1,_} = string:to_integer(M),
					{V2,_} = string:to_integer(N),
					[V1 * 3600 + V2 * 60|L];
				_ ->
					L
			end
		end,
	lists:foldr(F,[],SList).

%% 必须确保活动在进行中才能调用这个方法
get_active_pid(ActiveId) ->
		%?DEBUG("get_active_pid:~p",[ActiveId]),
		case ActiveId of
			?PVP1_ACTIVE_ID ->
				mod_pvp1:get_pvp1_pid();
			1002 ->%%京城捉贼
				mod_active_refesh_monster:get_active_refesh_monster_pid(ActiveId);
			1003 ->%%惩恶扶伤
				mod_active_refesh_monster:get_active_refesh_monster_pid(ActiveId);
			?GUILD_POUNCE_ACTIVE_ID ->%%帮派突袭
				mod_active_refesh_monster:get_active_refesh_monster_pid(ActiveId);
			?QUESTION_ACTIVE_ID ->
				mod_active_question:get_active_question_pid();
			?PATROL_ACTIVE_ID ->
				mod_active_patrol:get_active_patrol_pid();
			?RESOURCE_WAR_ACTIVE_ID ->%%资源战
				mod_resource_war:get_mod_resource_war_pid();
			?PVP_FIRST_ACTIVE_ID -> %天下第一
				mod_pvp_first:get_mod_pvp_first_pid();
			?MONSTER_ACTIVE_ID -> %世界boss
				mod_active_monster:get_mod_monster_pid();
			?GUILD_FIGHT_ACTIVE_ID -> %%帮会乱斗
				mod_guild_fight:get_mod_guild_fight_pid();
			?KING_FIGHT_ACTIVE_ID ->	%% 王城战
				mod_king_fight:get_mod_king_fight_pid();
			_ ->
				mod_active_refesh_monster:get_active_refesh_monster_pid(ActiveId)
		end.
