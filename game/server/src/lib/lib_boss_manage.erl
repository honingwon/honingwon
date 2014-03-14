%% Author: wangdahai
%% Created: 2013-5-14
%% Description: TODO: Add description to lib_boss_manage
-module(lib_boss_manage).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([init_boss_template/0, update_boss_dead/2, update_boss_relive/2, pack_boss_alive_num/1, loop_boss_relive/ 1]).

%%
%% API Functions
%%

%% 在地图模版与怪物模版后执行，并且同生成怪物
init_boss_template() ->
	Now = misc_timer:now_seconds(),
	F = fun(Info, List) ->
			Record = list_to_tuple([ets_boss_template] ++ Info),
			Position = tool:split_string_to_intlist(Record#ets_boss_template.relive_position),
			ReliveTime2 = init_open_time(Record#ets_boss_template.relive_time2),
			if
				Record#ets_boss_template.state =:= 1 ->
					MapPid = mod_map:get_scene_pid(Record#ets_boss_template.map_id),
					N = length(Position),
					I = util:rand(1, N),
					{X,Y} = lists:nth(I, Position),
					gen_server:cast(MapPid, {'create_boss', Record#ets_boss_template.boss_id, X , Y, Record#ets_boss_template.boss_type,Now}),
					DeadTime = 0;
				true ->
					DeadTime = Now
			end,
			NewRecord = Record#ets_boss_template{relive_time2 = ReliveTime2, dead_time = DeadTime, relive_position = Position},
			[NewRecord|List]
		end,
	case db_agent_template:get_boss_template() of
		[] ->
			[];
		List when is_list(List) ->
			lists:foldl(F, [], List);
		_ ->
			[]	
	end.
%%更新boss死亡
update_boss_dead(MonsterId, List) ->
	NewList = case lists:keyfind(MonsterId, #ets_boss_template.boss_id, List) of
		false ->
			List;
		Info ->
			NewInfo = Info#ets_boss_template{state = 0, dead_time = misc_timer:now_seconds()},
			lists:keyreplace(MonsterId, #ets_boss_template.boss_id, List, NewInfo)
	end,
	Bin = pack_boss_alive_num(NewList),
	lib_send:send_to_all(Bin),
	NewList.

update_boss_relive(MonsterId, List) ->
	NewList = case lists:keyfind(MonsterId, #ets_boss_template.boss_id, List) of
		false ->
			List;
		Info ->
			NewInfo = Info#ets_boss_template{state = 1, dead_time = 0},
			lists:keyreplace(MonsterId, #ets_boss_template.boss_id, List, NewInfo)
	end,
	Bin = pack_boss_alive_num(NewList),
	lib_send:send_to_all(Bin),
	NewList.

pack_boss_alive_num(List) ->
	F = fun(Info,Num) ->
			if
				Info#ets_boss_template.state =:= 0 ->
					Num;
				true ->
					Num + 1
			end
		end,
	Num = lists:foldl(F, 0, List),
	{ok, Bin} = pt_23:write(?PP_BOSS_ALIVE_NUM,[Num]),
	Bin.

loop_boss_relive(List) ->
	Now = misc_timer:now_seconds(),
	Week = misc_timer:get_week(Now),
	F = fun(Info,NewList) ->
			if
				Info#ets_boss_template.state =:= 0 andalso Info#ets_boss_template.boss_type =:= 0 
					andalso Info#ets_boss_template.dead_time + Info#ets_boss_template.relive_time =< Now ->
					case data_agent:map_template_get(Info#ets_boss_template.map_id) of
						[] ->
							ok;
						TempMap ->
							case data_agent:monster_template_get(Info#ets_boss_template.boss_id) of
								[] ->
									ok;
								TempMonster ->
									MapPid = mod_map:get_scene_pid(Info#ets_boss_template.map_id),
									N = length(Info#ets_boss_template.relive_position),
									I = util:rand(1, N),
									{X,Y} = lists:nth(I, Info#ets_boss_template.relive_position),
									gen_server:cast(MapPid, {'create_boss', Info#ets_boss_template.boss_id, X , Y, Info#ets_boss_template.boss_type, Now}),
									ChatStr = ?GET_TRAN(?_LANG_NOTICE_RELIVE_BOSS, [TempMonster#ets_monster_template.name, TempMap#ets_map_template.name]),
									lib_chat:chat_sysmsg_roll([ChatStr])
							end
					end,
					NewInfo = Info#ets_boss_template{state = 1, dead_time = 0},
					[NewInfo|NewList];
				Info#ets_boss_template.state =:= 0 andalso Info#ets_boss_template.boss_type =:= 1 
					andalso Info#ets_boss_template.relive_time band (1 bsl Week) > 0->
					Time = misc_timer:get_time(Now),
					loop_boss_relive1(Info#ets_boss_template.relive_time2, Time, Info,Now),
					[Info|NewList];
				true ->
					[Info|NewList]
			end
		end,
	lists:foldl(F, [], List).

%%
%% Local Functions
%%
loop_boss_relive1([],_Time,Info,_Now) ->
	Info;
loop_boss_relive1([V|L],Time,Info,Now) ->
	if		
		V =:= Time ->
			Pid = mod_map:get_scene_pid(Info#ets_boss_template.map_id),
			{X,Y} = lists:nth(1, Info#ets_boss_template.relive_position),
			gen_server:cast(Pid, {create_boss, Info#ets_boss_template.boss_id,X,Y,Info#ets_boss_template.boss_type, Now});%%直接调用地图召唤boss
		true ->
			loop_boss_relive1(L,Time,Info,Now)
	end.	

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
