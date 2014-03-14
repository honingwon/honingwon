%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to monster_data
-module(monster_data).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create/1]).

%%
%% API Functions
%%

create([Infos]) ->
	FInfo = fun(Info) ->
					list_to_tuple([ets_monster_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_monster_template", "get/1", "怪物模板数据表"),
    F =
    fun(MonsterInfo) ->
        Header = header(MonsterInfo#ets_monster_template.monster_id),
        Body = body(MonsterInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_monster_template{monster_id = MonsterId,
        			  level = Level,
					  monster_type = MonsterType,
					  max_hp = MaxHp,
					  hp_recover = HpRecover,
					  acthurt_max = ActhurtMax,
					  acthurt_min = ActhurtMin,
					  targethurt_max = TargethurtMax,
					  targethurt_min = TargethurtMin,
					  camp = Camp,
					  act_type = ActType,
					  attack_physics = AttackPhysics,
					  attack_range = AttackRange,
					  attack_magic = AttackMagic,
					  attack_vindictive = AttackVindictive,
					  attack_speed = AttackSpeed,
					  attack_distince = AttackDistince,
					  defanse_physics = DefansePhysics,
        			  defanse_range = DefanseRange,
					  defanse_magic = DefanseMagic,
					  defanse_vindictive = DefanseVindictive,
					  hit = Hit,
					  dodge = Dodge,
					  tough = Tough,
					  block = Block,
					  reduce_range = ReduceRange,
					  redece_magic = RedeceMagic,
					  reduce_vindictive = ReduceVindictive,
					  immune_buff = ImmuneBuff,
					  skill = Skill,
					  exp_fixed = ExpFixed,
					  exp = Exp,
					  move_speed = MoveSpeed,
					  act_distince = ActDistince,
					  return_distince = ReturnDistince,
					  guard_distince = GuardDistince,
					  reborn_time = RebornTime,
					  map_id = MaId,
					  lbornl_points = LbornlPoints,
					  abnormal_rate = AbnormalRate,
					  anti_abnormal_rate = AntiAbnormalRate
    } = Info,
	
	
	
	
	BuffData = tool:split_string_to_intlist(Skill),
	
	F = fun(Buff, List) ->
			    case Buff of
						   {Type1, Value} 
							 ->
							   lists:concat([List, Type1, ",", Value]);
						   _ ->
							   List
					   end
		end,
	TempListData = lists:foldl(F, [], BuffData),	
	
	if
		length(TempListData) > 0 ->
			TempList1 = lists:sublist(TempListData, 1, length(TempListData) -1),
			InfoListData = lists:concat(["[", TempList1, "]"]);
		true ->
			InfoListData = "[]"
	end,
	
	
	BuffData2 = binary_to_list(LbornlPoints),
	He = string:tokens(BuffData2, "|"),
	
	F1 = fun(Elem,List) ->
				lists:concat([List,"[",Elem,"],"])
		end,
	Buff = lists:foldl(F1, [], He),
	TempList2 = lists:sublist(Buff, 1, length(Buff) -1),
	InfoListData2 = lists:concat(["[", TempList2, "]"]),
	
	%%io:format("Buff: ~s~n",[InfoListData2]),
	
	
	
    io_lib:format(
    "    #ets_exp_template{monster_id = ~p,\n"
    " 					  level = ~p,\n"
    " 					  monster_type = ~p,\n"
    " 					  max_hp = ~p,\n"
    " 					  hp_recover = ~p,\n"
	"					  acthurt_max = ~p,\n"
    " 					  acthurt_min = ~p,\n"
    " 					  targethurt_max = ~p,\n"
    " 					  targethurt_min = ~p,\n"
	" 					  camp = ~p,\n"
	" 					  act_type = ~p,\n"
    " 					  attack_physics = ~p,\n"
	"					  attack_range = ~p,\n"
    " 					  attack_magic = ~p,\n"
    " 					  attack_vindictive = ~p,\n"
    " 					  attack_speed = ~p,\n"
    " 					  attack_distince = ~p,\n"
	"					  defanse_physics = ~p,\n"
    " 					  defanse_range = ~p,\n"
    " 					  defanse_magic = ~p,\n"
    " 					  defanse_vindictive = ~p,\n"
    " 					  hit = ~p,\n"
	"					  dodge = ~p,\n"
    " 					  tough = ~p,\n"
    " 					  block = ~p,\n"
    " 					  reduce_range = ~p,\n"
	" 					  redece_magic = ~p,\n"
	" 					  reduce_vindictive = ~p,\n"
    " 					  immune_buff = ~p,\n"
	"					  skill = ~s,\n"
    " 					  exp_fixed = ~p,\n"
    " 					  exp = ~p,\n"
	" 					  move_speed = ~p,\n"
	" 					  act_distince = ~p,\n"
    " 					  return_distince = ~p,\n"
	"					  guard_distince = ~p,\n"
    " 					  reborn_time = ~p,\n"
    " 					  map_id = ~p,\n"
	" 					  lbornl_points = ~s,\n"	
    " 					  abnormal_rate = ~p,\n"
	" 					  anti_abnormal_rate = ~p\n"				 				 				 				 
    "    };\n",
    [MonsterId, Level, MonsterType, MaxHp, HpRecover, ActhurtMax, ActhurtMin,
	 TargethurtMax, TargethurtMin, Camp, ActType, AttackPhysics, AttackRange, AttackMagic, 
	 AttackVindictive, AttackSpeed, AttackDistince, DefansePhysics, DefanseRange, 
	 DefanseMagic, DefanseVindictive, Hit, Dodge, Tough, Block, ReduceRange,
	 RedeceMagic, ReduceVindictive, ImmuneBuff, InfoListData, ExpFixed, 
	 Exp, MoveSpeed, ActDistince, ReturnDistince, GuardDistince, RebornTime, 
	 MaId, InfoListData2, AbnormalRate, AntiAbnormalRate]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

