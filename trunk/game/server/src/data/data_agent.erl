%%%----------------------------------------
%%% @Module  : data_agent
%%% @Author  : lxb
%%% @Created : 2012-9-25
%%% @Description: 数据转换常用函数
%%%----------------------------------------
-module(data_agent).


-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
		user_attr_template_get/1,
		item_template_get/1,
		mon_get/1,
		collect_get/1, 
		npc_get/1,
		shop_template_get/1,
		shop_npc_get/1,
		exp_template_get/1,
		item_category_template_get/1,
		item_hole_template_get/1,
		item_enchase_template_get/1,
		item_formula_template_get/1,
		item_upgrade_template_get/1,
		item_uplevel_template_get/1,
%%      item_all_function_template_get/1,
		item_pick_stone_template_get/1,
%%		item_rebuild_template_get/1,
        item_streng_rate_template_get/1,
%%		item_item_upgrade_template_get/1,
        item_enchase_stone_template_get/1,
		item_decompose_template_get/1,
		item_stone_decompose_template_get/1,
		welfare_template_get/1,
		welfare_exp_template_get/1,
		item_fusion_template_get/1,
		
		item_box_template_get/1,
		item_rebuild_prop_template_get/1,
		item_streng_addsucc_template_get/1,
		task_template_get/1,
%% 		task_template_state_get/1,
		task_template_award_get/1,
		token_task_template_get/1,
		monster_template_get/1,
		monster_template_get_by_mapid/1,
		collect_template_get_by_mapid/1,
		skill_template_get/1,
		door_template_get/1,
		map_template_get/1,
		pets_template_get/1,
		user_title_template_get/1,
		get_buff_from_template/1,
		get_active_refesh_monster_template/1,
		get_veins_from_template/1,
		get_veins_extra_from_template/1,
		get_skill_from_template/1,
		get_challenge_duplicate_template/1,
		dynamic_mon_templatee_get/1,
		
		get_question_bank_template/1,
		get_skill_from_template_by_group_and_lv/2,
		get_default_skill_from_template/1,
		get_guild_setting/1,
		get_guild_summon_template/1,
		get_guild_furnace_level/1,
		get_guild_shop_level/1,
		item_streng_copper_template_get/1,
		equip_enchase_template_get/1,
		equip_strength_template_get/1,
		item_strengthen_template_get/1,
		item_decompose_copper_template_get/1,
		duplicate_template_get/1,
		duplicate_template_mission_get/1,
		get_sit_award_from_template/1,
		get_daily_award_template/1,
		item_streng_modulus_template_get/1,
		get_vip_template/1,
		suit_props_template_get/1,
		shop_discount_template_get/1,
		get_free_war_award/1,
		mounts_template_get/1,
		mounts_star_template_get/1,
		mounts_diamond_template_get/1,
		mounts_grow_up_template_get/1,
		mounts_qualification_template_get/1,
		mounts_exp_template_get/1,
		mounts_stairs_template_get/1,
		
		pet_template_get/1,
		pet_star_template_get/1,
		pet_diamond_template_get/1,
		pet_grow_up_template_get/1,
		pet_qualification_template_get/1,
		pet_exp_template_get/1,
		pet_stairs_template_get/1,
		active_template_get/1,
		get_active_from_template/2,
		active_rewards_template_get/1,
		target_template_get/1,
		target_template_condition_get/1,
		get_amity_by_level/1,
		activity_open_server_template_get/1,
	    activity_seven_template_get/1,
		mounts_refined_template_get/1,
		mounts_refined_template_get1/1,
		smshop_template_get/1

		]).

%%====================================================================
%% External functions
%%====================================================================
%% 人物基础属性模板, Id:{career, level}
user_attr_template_get(Id)->
	case config:get_read_data_mode() of
		1->
			case ets:lookup(?ETS_USER_ATTR_TEMPLATE,Id) of
				[]  -> [];
				[H] -> H
			end;
		_->
			data_attr_template:get(Id)
	end.

%%人物称号模板
user_title_template_get(Id) ->
	case config:get_read_data_mode() of
		1->
			case ets:lookup(?ETS_TITLE_TEMPLATE,Id) of
				[]->[];
				[H]->H
			end;
		_ ->
			data_title_templat:get(Id)
	end.
			
%% 宠物基础属性模板 {template_id,level}
pets_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PETS_ATTR_TEMPLATE,Id) of
				[]->
					[];
				[D]->
					D
			end;
		_ ->
			data_pets_template:get(Id)
	end.

%% 怪物模板
mon_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			MS = ets:fun2ms(fun(T) when T#ets_monster_template.monster_id == Id -> T end),
   			case ets:select(?ETS_MONSTER_TEMPLATE, MS)	of
  				[] -> [];
   				[H] -> H
    		end;
		_-> 
			data_mon_template:get(Id)
	end.
%% 采集模板
collect_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			%MS = ets:fun2ms(fun(T) when T#ets_collect_template.template_id == Id -> T end),
   			%case ets:select(?ETS_COLLECT_TEMPLATE, MS)	of
			case ets:lookup(?ETS_COLLECT_TEMPLATE, Id) of
  				[] -> [];
   				[H] -> H
    		end;
		_-> 
			data_collcet_template:get(Id)
	end.
%% npc模板
npc_get(Id) ->
	case config:get_read_data_mode() of
		1 ->	
%%    			MS = ets:fun2ms(fun(T) when T#ets_npc_template.npc_id == Id -> T end),
%%    			case ets:select(?ETS_NPC_TEMPLATE, MS)	of
			case ets:lookup(?ETS_NPC_TEMPLATE, Id) of
  				[] -> [];
   				[H] -> H 
    		end;		
		_-> 
			data_npc_template:get(Id)
	end.	
%% 经验模板
exp_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->	
			case ets:lookup(?ETS_EXP_TEMPLATE, Id) of
  				[] -> [];
   				[H] -> H 
    		end;		
		_-> 
			data_exp_template:get(Id)
	end.	
%% 商店模板{shop_id, template_id, pay_type}
shop_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SHOP_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_shop_template:get(Id)
	end.

shop_npc_get(ShopId) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SHOP_NPC_TEMPLATE, ShopId) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_shop_npc_template:get(ShopId)
	end.

%% 物品模板
item_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ITEM_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_template:get(Id)
	end.

%% 物品类型模板
item_category_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ITEM_CATEGORY_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_category_template:get(Id)
	end.

%% 物品打孔模板
item_hole_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_HOLE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_hole_template:get(Id)
	end.

%% 物品镶嵌模板
item_enchase_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ENCHASE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_enchase_template:get(Id)
	end.

%% 开工炉功能消耗模板
%%item_all_function_template_get(Id) ->
%%	case config:get_read_data_mode() of
%%		1 ->
%%			case ets:lookup(?ETS_ALL_FUNCTION_TEMPLATE, Id) of
%%				[] -> 
%%					[];
%%				[D] ->
%%					D
%%			end;
%%		_ ->
%%			data_item_function_template:get(Id)
%%	end.

%% 装备镶嵌加成信息配置模版
equip_enchase_template_get(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_EQUIP_ENCHASE_TEMPLATE, Level) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			[]
			%% data_item_enchase_template:get(Id)
	end.

%% 装备强化加成信息配置模版
equip_strength_template_get(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_EQUIP_STRENGTH_TEMPLATE, Level) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			[]
			%% data_item_strengthen_template:get(Id)
	end.

%% 强化基础信息配置模版
item_strengthen_template_get(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_STRENGTHEN_TEMPLATE, Level) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			[]
			%% data_item_strengthen_template:get(Id)
	end.

%% 强化消耗金钱
item_streng_copper_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_STRENG_COPPER_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_streng_copper_template:get(Id)
	end.
%% 洗练消耗金钱
item_decompose_copper_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_DECOMPOSE_COPPER_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_decompose_copper_template:get(Id)
	end.



item_pick_stone_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PICK_STONE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_pick_template:get(Id)
	end.


%% item_rebuild_template_get(Id) ->
%% 	case config:get_read_data_mode() of
%% 		1 ->
%% 			case ets:lookup(?ETS_REBUILD_TEMPLATE, Id) of
%% 				[] -> 
%% 					[];
%% 				[D] ->
%% 					D
%% 			end;
%% 		_ ->
%% 			data_item_rebuild_template:get(Id)
%% 	end.

item_streng_rate_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_STRENG_RATE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_streng_template:get(Id)
	end.

item_streng_modulus_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_STRENG_MODULUS_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_streng_modulus_template:get(Id)
	end.

dynamic_mon_templatee_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_DYNAMIC_MON_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			dynamic_mon_templatee:get(Id)
	end.


item_streng_addsucc_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_STRENG_ADDSUCCRATE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_streng_addsucc_template:get(Id)
	end.





item_rebuild_prop_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_REBUILD_PROP_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_rebuild_prop_template:get(Id)
	end.


item_formula_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_FORMULA_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_formula_template:get(Id)
	end.

welfare_template_get(LoginDay) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_WELFARE_TEMPLATE, LoginDay) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_welfare_template:get(LoginDay)
	end.

welfare_exp_template_get(TypeId) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_WELFARE_EXP_TEMPLATE, TypeId) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_welfare_exp_template:get(TypeId)
	end.

item_upgrade_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ITEM_UPGRADE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_upgrade_template:get(Id)
	end.

item_uplevel_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ITEM_UPLEVEL_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_uplevel_template:get(Id)
	end.


item_decompose_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_DECOMPOSE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_decompose_template:get(Id)
	end.

item_stone_decompose_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_STONE_COMPOSE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_stone_decompose_template:get(Id)
	end.

item_fusion_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ITEM_FUSION_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_fusion_template:get(Id)
	end.


item_box_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_BOX_DATA, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_item_box_template:get(Id)
	end.


suit_props_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SUIT_PROPS_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_suit_props_template:get(Id)
	end.


%%获取优惠商品
shop_discount_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SHOP_DISCOUNT_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_stone_decompose_template:get(Id)
	end.

%% item_item_upgrade_template_get(Id) ->
%% 	case config:get_read_data_mode() of
%% 		1 ->
%% 			case ets:lookup(?ETS_ITEM_UPGRADE_TEMPLATE, Id) of
%% 				[] -> 
%% 					[];
%% 				[D] ->
%% 					D
%% 			end;
%% 		_ ->
%% 			data_item_upgrade_template:get(Id)
%% 	end.

%% 物品镶嵌宝石匹配模板
item_enchase_stone_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ITEM_STONE_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			data_enchase_stone_template:get(Id)
	end.
%% 取任务模板
task_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_TASK_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_task_template:get(Id)
	end.

task_template_award_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_TASK_AWARD_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_task_award_template:get(Id)
	end.

token_task_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_TOKEN_TASK_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_token_task_template:get(Id)
	end.

%% 取副本模板
duplicate_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_DUPLICATE_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_duplicate_template:get(Id)
	end.

duplicate_template_mission_get(Id) ->
	case config:get_read_data_mode() of
		1 -> 
			case ets:lookup(?ETS_DUPLICATE_MISSION_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_task_award_template:get(Id)
	end.


%%根据怪物ID获取Template信息
monster_template_get(MonId) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MONSTER_TEMPLATE,MonId) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_monster_template:get(MonId)
	end.
%% 怪物地图模板
monster_template_get_by_mapid(MapId) ->
	case config:get_read_data_mode() of
		1 ->
			MS = ets:fun2ms(fun(T) when T#ets_monster_template.map_id == MapId -> T end),
   			case ets:select(?ETS_MONSTER_TEMPLATE, MS)	of
  				[] -> [];
   				H -> H
    		end;
		_-> 
			data_monster_template_map:get(MapId)
	end.
%% 采集地图模板
collect_template_get_by_mapid(MapId) ->
	case config:get_read_data_mode() of
		1 ->
			MS = ets:fun2ms(fun(T) when T#ets_collect_template.map_id == MapId -> T end),
   			case ets:select(?ETS_COLLECT_TEMPLATE, MS)	of
  				[] -> [];
   				H -> H
    		end;
		_-> 
			data_collect_template_map:get(MapId)
	end.
%% 	技能模板
skill_template_get(SkillId) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SKILL_TEMPLATE, SkillId) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_skill_template:get(SkillId)
	end.
%% 门模板
door_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_DOOR_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_door_template:get(Id)
	end.
%% 地图模板
map_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MAP_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_map_template:get(Id)
	end.
%%获取题库模版信息
get_question_bank_template(ID) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_QUESTION_BANK_TEMPLATE, ID) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			question_bank_template:get(ID)
	end.
%%获取日常刷怪模版信息
get_active_refesh_monster_template(ID) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ACTIVE_REFRESH_MONSTER_TEMPLATE, ID) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			active_refesh_monster_template:get(ID)
	end.

%取ID对应的buff template信息
get_buff_from_template(BuffID) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_BUFF_TEMPLATE, BuffID) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_buff_template:get(BuffID)
	end.

%% 取ID对应的筋脉模版
get_veins_from_template(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_VEINS_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_->
			data_veins_template:get(Id)
	end.

get_veins_extra_from_template(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_VEINS_EXTRA_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_->
			data_veins_extra_template:get(Id)
	end.
%取id对应的试炼副本模版信息
get_challenge_duplicate_template(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_CHALLENGE_DUPLICATE_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_challenge_duplicate_template:get(Id)
	end.

%取ID对应的skill template信息
get_skill_from_template(SkillID) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SKILL_TEMPLATE, SkillID) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_skill_template:get(SkillID)
	end.

%取组ID/级别条件对应的skill template
get_skill_from_template_by_group_and_lv(SkillGroupID,Lv) ->
	case config:get_read_data_mode() of
		1 ->
			MS = ets:fun2ms(fun(T) when T#ets_skill_template.group_id =:= SkillGroupID, T#ets_skill_template.current_level =:= Lv -> T end),
			case ets:select(?ETS_SKILL_TEMPLATE, MS) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_skill_template:get_by_group_and_lv(SkillGroupID,Lv)
	end.

%获取对应职业的默认技能
get_default_skill_from_template(Career) ->
	case config:get_read_data_mode() of
		1 ->
			MS = ets:fun2ms(fun(T) when T#ets_skill_template.need_career =:= Career,T#ets_skill_template.default_skill =:= 1,
										T#ets_skill_template.current_level =:= 1 -> T end),
			case ets:select(?ETS_SKILL_TEMPLATE, MS) of
				[] ->
					[];
				[D|_L] ->
					D
			end;
		_ ->
			data_skill_template:get_default_skill_from_template(Career)
	end.

%% 获取默认帮会信息
get_guild_setting(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_GUILD_TEMPLATE,Level) of
				[] -> [];
				[D] -> D
			end;
		_ ->
			data_guild_template:get_guild_setting(Level)
	end.

get_guild_summon_template(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_GUILD_SUMMON_TEMPLATE,Id) of
				[] -> [];
				[D] -> D
			end;
		_ ->
			data_guild_template:get_guild_summon_template(Id)
	end.

%% 获取默认帮会神炉等级信息
get_guild_furnace_level(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_FURNACE_LEVEL_TEMPLATE,Level) of
				[] -> [];
				[D] -> D
			end;
		_ ->
			data_guild_template:get_guild_furnace_level(Level)
	end.

%% 获取帮会商城等级信息
get_guild_shop_level(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SHOP_LEVEL_TEMPLATE,Level) of
				[] -> [];
				[D] -> D
			end;
		_ ->
			data_guild_template:get_guild_shop_level(Level)
	end.


%取level对应的sit award template信息
get_sit_award_from_template(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SIT_AWARD_TEMPLATE, Level) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_sit_award_template:get(Level)
	end.

% 取模板对应每日奖励
get_daily_award_template(ID) ->
	case config:get_read_data_mode() of
		1 ->
			case ID of
				0 -> %读第一个
					get_daily_award_template1(ets:tab2list(?ETS_DAILY_AWARD_TEMPLATE),0);
				_ ->
					ets:lookup(?ETS_DAILY_AWARD_TEMPLATE,ID)
			end;
		_ ->
			data_daily_award_template:get(ID)
	end.

get_daily_award_template1([],V) -> [V];
get_daily_award_template1(L,V) ->
	[H|T] = L, 
	if is_record(V,ets_daily_award_template) =:= false ->
		    get_daily_award_template1(T,H);
		H#ets_daily_award_template.award_id < V#ets_daily_award_template.award_id ->
			get_daily_award_template1(T,H);
		true ->
			get_daily_award_template1(T,V)
	end.

%% 获取vip模板
get_vip_template(VipID) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_VIP_TEMPLATE, VipID) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_vip_template:get(VipID)
	end.

%%获取神魔对阵奖品
get_free_war_award(Key) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_FREE_WAR_AWARD_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_free_ward_award_template:get(Key)
	end.


mounts_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_mounts_template_template:get(Key)
	end.

mounts_grow_up_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_GROW_UP_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_mounts_grow_up_template:get(Key)
	end.


mounts_qualification_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_QUALIFICATION_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_mounts_qualification_template:get(Key)
	end.

mounts_star_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_STAR_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_mounts_star_template:get(Key)
	end.


mounts_diamond_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_DIAMOND_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_mounts_diamond_template:get(Key)
	end.

mounts_exp_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_EXP_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_mounts_exp_template:get(Key)
	end.

mounts_stairs_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_STAIRS_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_mounts_stairs_template:get(Key)
	end.

mounts_refined_template_get(Key) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_REFINED_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			[]
	end.

mounts_refined_template_get1(Key) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_MOUNTS_REFINED_TEMPLATE1, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			[]
	end.




pet_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PET_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_pet_template_template:get(Key)
	end.

pet_grow_up_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PET_GROW_UP_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_pet_grow_up_template:get(Key)
	end.


pet_qualification_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PET_QUALIFICATION_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_pet_qualification_template:get(Key)
	end.

pet_star_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PET_STAR_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_pet_star_template:get(Key)
	end.


pet_diamond_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PET_DIAMOND_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_pet_diamond_template:get(Key)
	end.

pet_exp_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PET_EXP_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_pet_exp_template:get(Key)
	end.

pet_stairs_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_PET_STAIRS_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_pet_stairs_template:get(Key)
	end.


active_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ACTIVE_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_active_template:get(Key)
	end.

get_active_from_template(Type,Id) ->
	case config:get_read_data_mode() of
		1 ->
			if
				Type =:= ?TASKACTIVE  ->
					MS = ets:fun2ms(fun(T) when T#ets_active_template.type =:= Type  -> T end),
					List = ets:select(?ETS_ACTIVE_TEMPLATE, MS),
					get_active_from_template1(List,Id,[]);
				Type =:= ?ACTIVE_PVP orelse Type =:= ?ACTIVE_TOKEN orelse Type =:= ?STRENG_EQUIP
				orelse Type =:= ?TAO_BAO orelse Type =:= ?BUY_SHOP orelse Type =:= ?REBUILD_EQUIP ->
					List = ets:tab2list(?ETS_ACTIVE_TEMPLATE),
					case lists:keyfind(Type, #ets_active_template.type, List) of
						false ->
							[];
						D ->
							D
					end;
				Type =:= ?DUPLICATEACTIVE ->
					MS = ets:fun2ms(fun(T) when T#ets_active_template.type =:= Type, T#ets_active_template.duplicate_id =:= Id -> T end),
					case ets:select(?ETS_ACTIVE_TEMPLATE, MS) of
						[] ->
							[];
						[D] ->
							D
					end;
				Type =:= ?ACTIVE ->
					MS = ets:fun2ms(fun(T) when T#ets_active_template.type =:= Type, T#ets_active_template.active_id =:= Id -> T end),
					case ets:select(?ETS_ACTIVE_TEMPLATE, MS) of
						[] ->
							[];
						[D] ->
							D
					end;
				Type =:= ?ONLINE_TIME ->
					MS = ets:fun2ms(fun(T) when T#ets_active_template.type =:= Type -> T end),
					case ets:select(?ETS_ACTIVE_TEMPLATE, MS) of
						[] ->
							[];
						[D] ->
							D
					end;
				true ->
					[]
			end;
		_ ->
			data_active_template:get_by_type_and_id(Type,Id)
	end.


get_active_from_template1([],_Id,V) -> V;
get_active_from_template1([H|T],Id,V) ->
	case lists:keyfind(Id, 1, H#ets_active_template.task_id) of
		false ->
			get_active_from_template1(T,Id,V);
		_ ->
			get_active_from_template1([],Id,H)
	end.
		

active_rewards_template_get(Key) ->	
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ACTIVE_REWARDS_TEMPLATE, Key) of
				[] ->
					[];
				[D] ->
					D;
				_ ->
					[]
			end;
		_ ->
			data_active_rewards_template:get(Key)
	end.


target_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_TARGET_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_target_template:get(Id)
	end.


target_template_condition_get(Condition) ->
	case config:get_read_data_mode() of
		1 ->
			MS = ets:fun2ms(fun(T) when T#ets_target_template.condition =:= Condition -> T end),
			case ets:select(?ETS_TARGET_TEMPLATE, MS) of
				[] ->
					[];
				List ->
					List
			end;
		_ ->
			data_target_template:get_by_type(Condition)
	end.

get_amity_by_level(Level) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_AMITY_TEMPLATE, Level) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			data_amity_template:get(Level)
	end.


activity_open_server_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ACTIVITY_OPEN_SERVER_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			activity_open_server_template:get(Id)
	end.

activity_seven_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_ACTIVITY_SEVEN_TEMPLATE, Id) of
				[] ->
					[];
				[D] ->
					D
			end;
		_ ->
			activity_seven_template_get:get(Id)
	end.


smshop_template_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_SMSHOP_TEMPLATE, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			smshop_template:get(Id)
	end.

