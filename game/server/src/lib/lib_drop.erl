%% Author: 冯伟平
%% Created: 2011-3-24
%% Description: TODO: 掉落相关
-module(lib_drop).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-define(DROP_ITEM_LOOP_TIME,30*1000). % 掉落物状态维持时间（2分钟锁定，2分钟不锁定，消失）
-define(DROP_ITEM_MAX_RANDOM,10000).	% 掉落物随机上限


-export([get_monster_drop/1,
 		 get_monster_drop2/1,
		 get_drop_item_from_list/1,
		 split_monster_drop_by_state/1,
		 get_drop_item_from_list_by_random_list/5,
		 get_drop_item_local_list/0
		]).

%%
%% API Functions
%%
%% 获取怪物模板对应的掉落物列表
get_monster_drop(MonsterID) ->
	F = fun(Info) -> list_to_tuple([ets_monster_item_template|Info]) end,
	[F(X) || X <- db_agent_template:get_monster_drop(MonsterID)].

%%拆成普通掉落和任务掉落
split_monster_drop_by_state(MonsterDropList) ->
	split_monster_drop_by_state1(MonsterDropList,[],[]).

split_monster_drop_by_state1([],CL,TL) -> {CL,TL};
split_monster_drop_by_state1(MonsterDropList,CL,TL) ->
	[H|T] = MonsterDropList,
	case H#ets_monster_item_template.state =:= 1 of
		true ->
			NCL = [H|CL],
			NTL = TL;
		_ ->
			NCL = CL,
			NTL = [H|TL]
	end,
	split_monster_drop_by_state1(T,NCL,NTL).


%% 处理掉落物-此列表中的掉落物每次随机只会掉落一件
%% 返回掉落列表，掉落次数，随机掉落列表（每次掉落不再取随机数，而是直接在此表里取值然后取出对应掉落）
get_monster_drop2(MonsterID) ->
	{DropList,DropRollTimes} = get_monster_drop2_1(MonsterID),
	F = fun(_Number,L) ->
				RC = util:rand(1,?DROP_ITEM_MAX_RANDOM),
				[get_monster_drop2_3(DropList,RC)|L]
		end,
	RandomL = lists:foldr(F,[],lists:seq(1,?DROP_ITEM_LIST_ROUND)),
	{DropList,DropRollTimes,RandomL}.
				
get_monster_drop2_1(MonsterID) ->
	case db_agent_template:get_monster_drop2(MonsterID) of
		[] ->
			{[],0};
		Ret ->
			F = fun(Info) -> list_to_tuple([ets_monster_drop_item_template|Info]) end,
			get_monster_drop2_2([F(X) || X <- Ret])
	end.

get_monster_drop2_2(Ret) ->
	F = fun(Info,{L,Times,Range,Index}) ->
%% 				%item_template_id,drop_times,drop_rate,drop_number,isbind
%% 				[ItemTemplateID,DropTimes,DropRate,DropNumber,IsBind] = Info,
				RangeLow = Range + 1,
				RangeHigh = Range + Info#ets_monster_drop_item_template.drop_rate,
				Record = #r_drop_item_template{
										index = Index,
										item_template_id = Info#ets_monster_drop_item_template.item_template_id,		%%物品模板
										item_drop_range_low = RangeLow,		%%落点下限
										item_drop_range_high = RangeHigh,	%%落点上限
										drop_number = Info#ets_monster_drop_item_template.drop_number,				%%掉落数量
										is_bind = Info#ets_monster_drop_item_template.isbind
									 },
				{[Record|L],Info#ets_monster_drop_item_template.drop_times ,RangeHigh,Index+1}
		end,
	{TmpDropList,DropRollTimes,_Range,_Index} = lists:foldr(F,{[],0,0,1},Ret),
	{lists:reverse(TmpDropList),DropRollTimes}.

get_monster_drop2_3([],_RC) -> 0;	%取不到物品用0
get_monster_drop2_3(DropList,RC) ->
	[H|T] = DropList,
	if H#r_drop_item_template.item_drop_range_low =< RC andalso
								  H#r_drop_item_template.item_drop_range_high >= RC ->
			H#r_drop_item_template.index;
	   true ->
		   get_monster_drop2_3(T,RC)
	end.

%% 产生随机掉落位置
get_drop_item_local_list() ->
	F = fun(_Number,L) ->
				TmpLocX = util:rand(1,75),
				TmpLocY = util:rand(1,75),
				[{TmpLocX,TmpLocY}|L]
		end,
	lists:foldr(F,[],lists:seq(1,?DROP_LOCAL_LIST_ROUND)).


%% 在掉落物列表中随机产生掉落物 - 对应固定掉落，在此列表中的每项都会随机一次
get_drop_item_from_list(MonsterDropList) ->
	get_drop_item_from_list1(MonsterDropList,[]).

get_drop_item_from_list1([],L) -> L;
get_drop_item_from_list1(MonsterDropList,L) ->
	[H|T] = MonsterDropList,
	RC = util:rand(1,?DROP_ITEM_MAX_RANDOM),
	case H#ets_monster_item_template.random >= RC of
		true ->
			NL = [H|L];
		_ ->
			NL = L
	end,
	get_drop_item_from_list1(T,NL).
	
%% 通过随机列表取对应掉落 - 对应不固定掉落，通过实例化怪物时产生的随机列表取对应位置进行掉落
get_drop_item_from_list_by_random_list(_DropList,0,_DropRandomTimes,_DropRandomList,L) -> L;
get_drop_item_from_list_by_random_list(DropList,DropTimes,DropRandomTimes,DropRandomList,L) ->
	Nth =
		if DropRandomTimes =< ?DROP_ITEM_LIST_ROUND ->
			   DropRandomTimes;
		   true ->
			   1
		end,
	DropListNth = lists:nth(Nth,DropRandomList),
	if DropListNth > 0 ->
		   DropItem = lists:nth(DropListNth,DropList),
		   get_drop_item_from_list_by_random_list(DropList,DropTimes-1,Nth+1,DropRandomList,[DropItem|L]);
	   true ->
			get_drop_item_from_list_by_random_list(DropList,DropTimes-1,Nth+1,DropRandomList,L)
	end.
	
%%
%% Local Functions
%%

