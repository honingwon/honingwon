%% Author: Administrator
%% Created: 2011-6-7
%% Description: TODO: Add description to skill_data
-module(skill_data).

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
					list_to_tuple([ets_skill_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),

	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_skill_template", "get/1", "技能模板数据表"),
    F =
    fun(SkillInfo) ->
        Header = header(SkillInfo#ets_skill_template.skill_id),
        Body = body(SkillInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_skill_template{skill_id = SkillId,
					  group_id = GroupId,
					  category_id = CategoryId,
					  active_use_mp = ActiveUseMp,
					  active_type = ActiveType,
					  active_side = ActiveSide,
					  active_target_type = ActiveTargetType,
					  active_target_monster_list = ActiveTargetMonsterList,
					  active_item_category_id = ActiveItemCategoryId,
					  active_item_template_id = ActiveItemTemplatId,
					  cold_down_time = ColdDownTime,
					  range = Range,
					  radius = Radius,
					  effect_number = EffectNumber,
					  skill_effect_list = SkillEffectList,
					  buff_list = BuffList,
					  sound = Sound,
					  wind_effect = WindEffect,
					  attack_effect = AttackEffect,
					  beattack_effect = BeattackEffect,
					  next_skill_id = NextSkillId,
					  update_life_experiences = UpdateLifeExperiences,
					  need_career = NeedCareer,
					  need_god_repute = NeedGodRepute,
					  need_ghost_repute = NeedGhostRepute,	  
					  need_level = NeedLevel,
					  need_item_id = NeedItemId,
					  default_skill = DefaultSkill,
					  straight_time = StraightTime,
					  prepare_time = PrepareTime,
					  current_level = CurrentLevel,
					  place = Place,		  
					  need_copper = NeedCooper,
					  is_big_skill = IsBigSkill,
					  is_single_attack = IsSingleAttack,							  
					  is_shake = IsShake				  
    } = Info,
	

	
	
	BuffData = tool:split_string_to_intlist(SkillEffectList),
	
	F = fun(Buff, List) ->
			    case Buff of
						   {Type1, Value} 
							 ->
							   lists:concat([List, "{", Type1, ",", Value, "},"]);
					       {Type1, Value1, Type2 ,Value2} 
							 ->
							   lists:concat([List, "{", Type1, ",", Value1, ",", Type2, ",", Value2, "},"]);
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
	
	
	
    io_lib:format(
    "    #ets_streng_rate_template{skill_id = ~p,\n"
	" 					  group_id = ~p,\n"
	" 					  category_id = ~p,\n"
	" 					  active_use_mp = ~p,\n"
	" 					  active_type = ~p,\n"
	" 					  active_side = ~p,\n"
	" 					  active_target_type = ~p,\n"
	" 					  active_target_monster_list = ~p,\n"
	" 					  active_item_category_id = ~p,\n"
	" 					  active_item_template_id = ~p,\n"
	" 					  cold_down_time = ~p,\n"
	" 					  range = ~p,\n"
	" 					  radius = ~p,\n"
	" 					  effect_number = ~p,\n"
	" 					  skill_effect_list = ~s,\n"
	" 					  buff_list = ~p,\n"
	" 					  sound = ~p,\n"
	" 					  wind_effect = ~p,\n"
	" 					  attack_effect = ~p,\n"
	" 					  beattack_effect = ~p,\n"
	" 					  next_skill_id = ~p,\n"
	" 					  update_life_experiences = ~p,\n"
	" 					  need_career = ~p,\n"
	" 					  need_god_repute = ~p,\n"
	" 					  need_ghost_repute = ~p,\n"
	" 					  need_level = ~p,\n"
	" 					  need_item_id = ~p,\n"
	" 					  default_skill = ~p,\n"
	" 					  straight_time = ~p,\n"
	" 					  prepare_time = ~p,\n"
	" 					  current_level = ~p,\n"
	" 					  place = ~p,\n"
	" 					  need_cooper = ~p,\n"
	" 					  is_big_skill = ~p,\n"
	" 					  is_single_attack = ~p,\n"
    " 					  is_shake = ~p\n"				 				 				 				 
    "    };\n",
    [SkillId,GroupId, CategoryId,ActiveUseMp,ActiveType,
	 ActiveSide,ActiveTargetType, ActiveTargetMonsterList,ActiveItemCategoryId,ActiveItemTemplatId,
	 ColdDownTime,Range, Radius,EffectNumber,InfoListData,
	 BuffList,Sound, WindEffect,AttackEffect,BeattackEffect,
	 NextSkillId,UpdateLifeExperiences, NeedCareer,NeedGodRepute,NeedGhostRepute,
	 NeedLevel,NeedItemId, DefaultSkill,StraightTime,PrepareTime,
	 CurrentLevel,Place, NeedCooper,IsBigSkill,IsSingleAttack,IsShake]).



last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

