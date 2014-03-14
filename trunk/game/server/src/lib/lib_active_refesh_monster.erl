%% Author: wangdahai
%% Created: 2013-6-3
%% Description: TODO: Add description to lib_active_refesh_monster
-module(lib_active_refesh_monster).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([init_refesh_monster_template/0,refresh_monster/1]).

%%
%% API Functions
%%
init_refesh_monster_template() ->
	F = fun(Info) ->
			Record = list_to_tuple([ets_active_refresh_monster_template] ++ Info),
			MonsterList = tool:split_string_to_intlist(Record#ets_active_refresh_monster_template.monsters),
			CollectList = tool:split_string_to_intlist(Record#ets_active_refresh_monster_template.collects),
			MapList = tool:split_string_to_intlist(Record#ets_active_refresh_monster_template.maps, ","),
			init_map_monster1(MapList,MonsterList,CollectList,Record)
		end,
	case db_agent_template:get_active_refesh_monster_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end.

refresh_monster(ActiveId) ->
	case data_agent:get_active_refesh_monster_template(ActiveId) of
		[] ->
			[];
		Temp ->
			refresh_monster1(Temp)
	end.


%%
%% Local Functions
%%
%%刷新怪物

refresh_monster1(Temp) ->
	N = length(Temp#ets_active_refresh_monster_template.maps),
	List = if
		N =:= Temp#ets_active_refresh_monster_template.refresh_map_num ->
			Temp#ets_active_refresh_monster_template.maps;
		N > Temp#ets_active_refresh_monster_template.refresh_map_num ->			
			L = lists:seq(1, N),
			IndexList = refresh_monster2(L, N, Temp#ets_active_refresh_monster_template.refresh_map_num , []),
			refresh_monster3(Temp#ets_active_refresh_monster_template.maps, IndexList);
		true ->
			?DEBUG("refresh_monster1 error:~p",[Temp#ets_active_refresh_monster_template.active_id]),
			[]			
	end,
	
	refresh_monster4(List),
	List.

refresh_monster4(List) ->
	F = fun(Info) ->
			{MapId, MList, CList} = Info,
			if
				MapId =:= ?GUILD_MAP_ID ->
					mod_guild:open_active_summon_monster(MList);
				true ->
					MapPid = mod_map:get_scene_pid(MapId),			
					refresh_monster5(MList, MapPid),
					refresh_monster6(CList, MapPid)
			end			 
		end,
	lists:foreach(F, List).

refresh_monster6(CList, MapPid) ->
	F = fun(CollId) ->
			gen_server:cast(MapPid, {create_collect, CollId})
		end,
	lists:foreach(F, CList).
refresh_monster5(MList, MapPid) ->
	F = fun(MonId) ->
			gen_server:cast(MapPid, {create_monster, MonId})
		end,
	lists:foreach(F, MList).

refresh_monster3(List, IndexList) ->
	F = fun(Index, NewList) ->
			Info = lists:nth(Index, List),
			[Info|NewList]
		end,
	lists:foldl(F, [], IndexList).

refresh_monster2(_List, _Length, 0, NewList) ->
	NewList;
refresh_monster2(List, Length, RandNum, NewList) ->
	Nth = util:rand(1, Length),
	{NewList1,Info} = tool:delete_with_index(List, Nth),
	refresh_monster2(NewList1, Length - 1, RandNum - 1, NewList ++ Info).

%%初始化怪物信息
init_map_monster1(MapList,MonList,ColList,Record)->
	N1 = length(MapList),
	if
		MonList =:= [] ->
			NewMonList = lists:duplicate(N1, []);
		true ->
			NewMonList = MonList
	end,
	N2 = length(NewMonList),
	if
		ColList =:= [] ->
			NewColList = lists:duplicate(N1, []);
		true ->
			NewColList = ColList
	end,
	N3 = length(NewColList),
	if
		N1 =:= N2 andalso N1 =:= N3 ->
			NewMapList = init_map_monster2(MapList,MonList,NewColList,[]),
			NewRecord = Record#ets_active_refresh_monster_template{maps = NewMapList},
			ets:insert(?ETS_ACTIVE_REFRESH_MONSTER_TEMPLATE, NewRecord);
		true ->
			?DEBUG("init_refesh_montser_template error:~p",[Record#ets_active_refresh_monster_template.active_id])
	end.
init_map_monster2([],[],[],List) ->
	List;
init_map_monster2([H1|MapList],[H2|MonList],[H3|ColList],List) ->
	init_map_monster2(MapList,MonList,ColList,[{H1,tool:to_list(H2),tool:to_list(H3)}|List]).
