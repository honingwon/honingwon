%% Author: wangdahai
%% Created: 2013-4-25
%% Description: TODO: Add description to lib_pvp_duplicate
-module(lib_pvp_duplicate).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([clear_duplicate_and_map/1, get_pvp_duplicate_Points/1,create_duplicate_map/1,check_camp_state/2, pvp_send_result/4,pvp_dup_quit/3,get_user_pvp_info/2]).

%%
%% API Functions
%%
%%创建副本关联地图
create_duplicate_map(MissionTempate) ->
	UniqueId = mod_increase:get_duplicate_auto_id(),
	Id = lib_map:create_copy_id(MissionTempate#ets_duplicate_mission_template.map_id, UniqueId),
	ProcessName = misc:create_process_name(duplicate_pvp_p, [Id, 0]),
	misc:register(global, ProcessName, self()),
	{Map_pid, _} = mod_map:get_scene_pid(Id, undefined, undefined),
	gen_server:cast(Map_pid, {'set_dup_pid', self()}),
 	MonList = tool:split_string_to_intlist(MissionTempate#ets_duplicate_mission_template.monster_list),
 	gen_server:cast(Map_pid, {'create_duplicate_mon', MonList, 0, 1, 1, 1}),	
	{Map_pid,Id}.%%返回map pid 与 uniqueid

%% 清除副本地图
clear_duplicate_and_map(MapPid) ->
	gen_server:cast(MapPid, {stop, duplicate_finish}).
%% 获取副本的出生点
get_pvp_duplicate_Points(MissionTemp) ->
	case data_agent:map_template_get(MissionTemp#ets_duplicate_mission_template.map_id) of
		[] ->
			?WARNING_MSG("get_pvp_duplicate_Points error:~p",[MissionTemp#ets_duplicate_mission_template.mission_id]),
			[];
		TempMap ->
			if
				length(TempMap#ets_map_template.rand_point) > 1 ->
					TempMap#ets_map_template.rand_point;
				true ->
					[{MissionTemp#ets_duplicate_mission_template.pos_x,MissionTemp#ets_duplicate_mission_template.pos_y},
						{MissionTemp#ets_duplicate_mission_template.pos_x,MissionTemp#ets_duplicate_mission_template.pos_y}]
			end
	end.

%%通知战斗结果
pvp_send_result(ActiveId, Result, List1, List2) ->
case Result of
	0 ->
		pvp_end1(ActiveId, Result, List1 ++ List2);
	1 ->
		pvp_end1(ActiveId, Result, List1),
		pvp_end1(ActiveId, 2, List2);
	2 ->
		pvp_end1(ActiveId, Result, List1),
		pvp_end1(ActiveId, 1, List2);
	_ ->
		ok
end.

%% 检查pvp是否出现成功或失败
check_camp_state(List1,List2) ->
	Result1 = check_camp_state1(List1),
	Result2 = check_camp_state1(List2),
	if
		Result1 =:= false andalso Result2 =:= true ->
			2;
		Result1 =:= true andalso Result2 =:= false ->
			1;
		Result1 =:= true andalso Result2 =:= true ->
			-1;
		Result1 =:= false andalso Result2 =:= false ->
			0
	end.
%%离开副本，主动离开或下线
pvp_dup_quit(UserId, List1, List2) ->
	%AwardList = lib_pvp1:get_pvp1_award(0),%%如果多个活动的时候需要修改
	case lists:keyfind(UserId, #pvp_dup_user_info.user_id, List1) of
		false ->
			case lists:keyfind(UserId, #pvp_dup_user_info.user_id, List2) of
				false ->
					{List1, List2};
				Info2 ->
%% 					if
%% 						Info2#pvp_dup_user_info.status =:= 1 ->
%% 							gen_server:cast(Info2#pvp_dup_user_info.pid_user, {'SOCKET_EVENT', ?PP_PLAYER_RELIVE, [6]});
%% 						true ->
%% 							ok
%% 					end,
					%%gen_server:cast(Info#pvp_dup_user_info.pid_user, {'add_duplicate_award',AwardList}),  
					NewList2 = lists:keydelete(UserId, #pvp_dup_user_info.user_id, List2),
					{List1, NewList2}
			end;	
		Info1 ->
%% 				if
%% 					Info1#pvp_dup_user_info.status =:= 1 ->
%% 						gen_server:cast(Info1#pvp_dup_user_info.pid_user, {'SOCKET_EVENT', ?PP_PLAYER_RELIVE, [6]});
%% 					true ->
%% 						ok
%% 				end,
				%gen_server:cast(Info#pvp_dup_user_info.pid_user, {'add_duplicate_award',AwardList}),
				NewList1 = lists:keydelete(UserId, #pvp_dup_user_info.user_id, List1),				
				{NewList1, List2}
	end.
%% 获取用户对象
get_user_pvp_info(UserId, List) ->
	case lists:keyfind(UserId, #pvp_dup_user_info.user_id, List) of
		false ->
			[];
		Info ->
			Info
	end.
%%
%% Local Functions
%%
check_camp_state1([]) ->
	false;
check_camp_state1([H|L]) ->
	if
		H#pvp_dup_user_info.status =:= 0 ->
			true;
		true ->
			check_camp_state1(L)
	end.

pvp_end1(ActiveId, Result, List) ->
	F = fun(Info) ->
			Award = lib_pvp1:get_pvp1_award(Result),
			gen_server:cast(Info#pvp_dup_user_info.pid_user, {pvp_end, ActiveId, Result, Award})
		end,
	lists:foreach(F, List).