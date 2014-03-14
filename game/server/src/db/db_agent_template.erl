%% Author: Administrator
%% Created: 2011-3-8
%% Description: TODO: Add description to db_agent_template
-module(db_agent_template).
-include("common.hrl").

-export([
		 init_db/0,
		 get_item_template_info/0,
		 get_item_category_template_info/0,
		 get_shop_template/0,
		 get_equip_enchase_template/0,
		 get_equip_strength_template/0,
		 get_strengthen_template/0,
		 get_hole_template/0,
         get_enchase_template/0,
%%       get_all_function_template/0,
%%       get_item_rebuild_template/0,
		 get_pick_stone_template/0,
		 get_decompose_template/0,
         get_streng_rate_template/0,
%%       get_item_upgrade_template/0,
         get_enchase_stone_template/0,
		 get_stone_compose_template/0,
		 get_streng_addsuccrate_template/0,
		 get_task_template/0,
		 get_token_task_template/0,
		 get_task_award_template/0,
		 get_task_state_template/0,
		 get_rebuild_prop_template/0,
		 get_door_template/0,
		 get_map_template/0,
		 get_exp_template/0,
		 get_npc_template/0,
		 get_formula_template/0,
		 get_item_upgrade_template/0,
		 get_item_uplevel_template/0,
		 get_user_attr_template/0,
		 get_pets_attr_template/0,
		 get_title_template/0,
		 get_dynamic_mon_template/0,
		 get_active_open_time_template/0,
		 get_active_refesh_monster_template/0,
		 get_question_bank_template/0,
		 get_suit_props_template/0,
		 get_shenyou_template/0,
		 get_item_fusion_template/0,
		 
		 get_streng_copper_template/0,
		 get_decompose_copper_template/0,
		 get_challenge_duplicate_template/0,
		 get_duplicate_template/0,
		 get_duplicate_mission_template/0,
		 get_duplicate_lottery_template/1,
		 get_sit_award_template/0,
		 get_daily_award_template/0,
		 get_streng_mudulus_template/0,

		 get_vip_template/0,
		 get_box_template/0,
		 get_smshop_template/0,

		 get_vip_template/0,
		 get_shop_discount_template/0,
		 get_shop_npc_template/0,
		 get_free_war_award_template/0,
		 get_veins_template/0,
		 get_veins_extra_template/0,
		 get_boss_template/0,

		 get_mounts_template/0,
		 get_mounts_stairs_template/0,
		 get_mounts_exp_template/0,
		 get_mounts_quality_template/0,
		 get_mounts_qualification_template/0,
		 get_mounts_grow_up_template/0,
		 get_mounts_star_template/0,
		 get_mounts_diamond_template/0,
		 get_mounts_refined_template/0,
		 
		 get_monster_template/0,
		 get_collect_template/0,
		 get_skill_template/0,
		 get_buff_template/0,
		 get_guilds_template/0,
		 get_guild_summon_template/0,
		 get_guild_prayer_template/0,
		 get_guilds_furnace_leve_template/0,
		 get_guilds_shop_leve_template/0,
		 get_welfare_template/0,
		 get_welfare_exp_template/0,
		 get_activity_open_server_template/0,
		 
		 get_monster_drop/1,
		 get_monster_drop2/1,
		 
		 get_pet_diamond_template/0,
		 get_pet_exp_template/0,
		 get_pet_qualification_exp_template/0,
		 get_pet_grow_up_exp_template/0,
		 get_pet_grow_up_template/0,
		 get_pet_qualification_template/0,
		 get_pet_stairs_template/0,
		 get_pet_star_template/0,
		 get_pet_template/0,
		 get_active_template/0,
		 get_active_rewards_template/0,
		 get_target_template/0,
		 get_amity_template/0,
		 get_yellow_box_template/0,
		 get_activity_seven_template/0
		]).

%%
%% API Functions
%%

%%############数据库初始化##############
%% 数据库连接初始化
init_db() ->
	if ?DB_MODULE =:= db_mysql ->
    		init_mysql_template();
		true ->
			skip
	end,	
	ok.

%% mysql数据库连接初始化
init_mysql_template() ->
	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(mysql_template_config),
	mysql:start_link(mysql_template_dispatcher, ?DB_POOL, Host, Port, User, Password, DB,  fun(_, _, _, _) -> ok end, Encode),
	mysql:connect(mysql_template_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true),
 	misc:write_system_info({self(), mysql_template}, mysql_template, {Host, Port, User, DB, Encode}),
	ok.

create_mysql_connect(Count) ->
	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(mysql_template_config),
	LTemp =
    case Count > 1 of
        true ->
            lists:duplicate(Count, dummy);
        false ->
            [dummy]
    end,

    % 启动conn pool
    [begin
		   {ok, _ConnPid} = mysql:connect(mysql_template_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true)
    end || _ <- LTemp],
	ok.

%% 获取所有物品信息
get_item_template_info() ->
    ?DB_MODULE:select_all(mysql_template_dispatcher,t_item_template, "*", []).

%% 物品类型模板
get_item_category_template_info() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_item_category_template, "*", []).


%% 商店模板
get_shop_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_shop_template, "*", []).

%% 优惠商品模板
get_shop_discount_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_shop_discount_template, "*", []).


%% 优惠商品模板
get_shop_npc_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_shop_npc_template, "*", []).

%% 装备镶嵌加成模版
get_equip_enchase_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_equip_enchase_template, "*", []).

%% 装备强化加成模版
get_equip_strength_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_equip_strength_template, "*", []).
%% 物品强化模板
get_strengthen_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_strengthen_template, "*", []).

%% 物品打孔模板
get_hole_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_hole_template, "*", []).

get_box_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_box_template, "*", []).

get_smshop_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_smshop_template, "*", []).


%% 物品镶嵌模板
get_enchase_template() ->
    ?DB_MODULE:select_all(mysql_template_dispatcher,t_enchase_template, "*", []).

%% get_all_function_template() ->
%%     ?DB_MODULE:select_all(mysql_template_dispatcher,t_all_function_template, "*", []).

get_streng_copper_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_streng_copper_template, "*", []).

get_decompose_copper_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_decompose_copper_template, "*", []).


get_formula_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_formula_template, "*", []).

get_item_upgrade_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_item_upgrade_template, "*", []).

get_item_uplevel_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_item_uplevel_template, "*", []).

get_pick_stone_template() ->
    ?DB_MODULE:select_all(mysql_template_dispatcher,t_pick_stone_template, "*", []).

%% get_item_rebuild_template() ->
%% 	?DB_MODULE:select_all(mysql_template_dispatcher,t_rebuild_template, "*", []).
	
get_streng_rate_template() ->
    ?DB_MODULE:select_all(mysql_template_dispatcher,t_streng_rate_template, "*", []). 

get_streng_mudulus_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_streng_modulus_template, "*", []). 

get_rebuild_prop_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_rebuild_prop_template, "*", []). 

get_decompose_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_decompose_template, "*", []).

get_stone_compose_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_stone_compose_template, "*", []).

get_streng_addsuccrate_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_streng_addsuccrate_template, "*", []).
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
get_suit_props_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_suit_props_template, "*", []).
	
%% get_item_upgrade_template() ->
%%     ?DB_MODULE:select_all(mysql_template_dispatcher,t_item_upgrade_template, "*", []). 

%% 物品镶嵌对应宝石模板
get_enchase_stone_template() ->
    ?DB_MODULE:select_all(mysql_template_dispatcher,t_item_stone_template, "*", []).

%% 装备熔炼模版
get_item_fusion_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher, t_item_fusion_template, "*", []).

%% 活动开启时间模版
get_active_open_time_template() ->
	 ?DB_MODULE:select_all(mysql_template_dispatcher,t_active_open_time_template, "active_id, open_week, open_time, continue_time, 0, other, award", []).

%% 日常活动刷怪采集物模版
get_active_refesh_monster_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_active_refresh_monster_template,"*",[]).

%% 题库题目模版
get_question_bank_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_question_bank_template,"*",[]).

%% 江湖令任务模板
get_token_task_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_token_task_template, "*", []).

%% 任务模板
get_task_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_task_template, "*", []).

%% 任务奖励模板
get_task_award_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_task_award_template, "*", []).

%% 任务状态模板
get_task_state_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_task_state_template, "*", []).

%% 门模板
get_door_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_door_template, "*", []).

%% 地图模板
get_map_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_map_template, "*", []).

%% 经验模板
get_exp_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_exp_template, "*", []).

%% npc模板
get_npc_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_npc_template, "*", []).

%%人物基础属性模板
get_user_attr_template()->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_user_attr_template,"*",[]).

%%宠物基础属性模板
get_pets_attr_template()->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pets_attr_template,"*",[]).

%%人物称号模板 
get_title_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_title_template,"*",[]).

get_dynamic_mon_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_dynamic_mon_template, "*", []).

%%副本神游模板表
get_shenyou_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_shenyou_template, "*", []).

%% 试炼副本模板
get_challenge_duplicate_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_challenge_duplicate_template, "id,limit_id,storey,duplicate_id,star_time,gift", []).

%% 副本状态模板
get_duplicate_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_duplicate_template, "*", []).

%% 副本状态模板
get_duplicate_mission_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_duplicate_mission_template, "*", []).

%% 副本抽奖模版
get_duplicate_lottery_template(DuplicateId) ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_duplicate_lottery_template, "*", [{duplicate_id,DuplicateId}]).

%%打坐奖励模板表
get_sit_award_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_sit_award_template, "*", []).

%%每日奖励模板表
get_daily_award_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_daily_award_template, "*", []).

%%Vip模板表
get_vip_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_vip_template, "*" , []).

%%神魔斗法奖励
get_free_war_award_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_free_war_award_template, "*", []).

%%筋脉模版表
get_veins_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_veins_template, "*", []).

%%筋脉额外奖励模版表
get_veins_extra_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_veins_extra_template, "*", []).

get_mounts_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_template, "*", []).

get_mounts_stairs_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_stairs_template, "*", []).

get_mounts_exp_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_exp_template, "*", []).

%% 坐骑洗练模版表
get_mounts_refined_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher, t_mounts_refined_template, "*", []).

get_mounts_quality_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_quality_template, "*", []).

get_mounts_qualification_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_qualification_template, "*", []).

get_mounts_grow_up_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_grow_up_template, "*", []).

get_mounts_star_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_star_template, "*", []).

get_mounts_diamond_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_mounts_diamond_template, "*", []).

get_collect_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_collect_template, "*", []).

get_monster_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_monster_template, "*", []).

get_skill_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_skill_template, "*", []).

get_buff_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_buff_template, "*", []).


get_guilds_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_guilds_template, "*", []).

get_guild_summon_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_guild_summon_template, "*", []).

get_guild_prayer_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_guild_prayer_template, "*", []).

get_guilds_furnace_leve_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_guilds_furnace_leve_template, "*", []).

get_guilds_shop_leve_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_guilds_shop_leve_template, "*", []).

%获取怪物模板对应掉落
get_monster_drop(MonsterID) ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_monster_item_template, "*", 
								[{monster_template_id, MonsterID}]).

%%2011-05-25修改，增加t_monster_drop_item_template.
%%对应随机落点方式取掉落物，即怪目前有三种掉落
get_monster_drop2(MonsterID) ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_monster_drop_item_template, "*",
								[{monster_template_id,MonsterID}]).
	

get_pet_diamond_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_diamond_template, "*", []).

get_pet_exp_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_exp_template, "*", []).

get_pet_qualification_exp_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_qualification_exp_template, "*", []).

get_pet_grow_up_exp_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_grow_up_exp_template, "*", []).

get_pet_grow_up_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_grow_up_template, "*", []).

get_pet_qualification_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_qualification_template, "*", []).

get_pet_stairs_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_stairs_template, "*", []).

get_pet_star_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_star_template, "*", []).

get_pet_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_pet_template, "*", []).


get_active_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_active_template, "*", []).
%%野外boss模版
get_boss_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_boss_template, "boss_id,boss_type,map_id,relive_time,relive_time2,relive_position,state,other", []).

get_active_rewards_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_active_rewards_template, "*", []).

get_target_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_target_template, "*", []).

get_amity_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_amity_template, "*", []).


get_welfare_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_welfare_template, "*", []).

get_welfare_exp_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_welfare_exp_template, "*", []).

get_activity_open_server_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_activity_open_server_template, "*", [{is_open,1}]).


get_yellow_box_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_yellow_box_template, "*", []).

get_activity_seven_template() ->
	?DB_MODULE:select_all(mysql_template_dispatcher,t_activity_seven_template, "*", []).

%%
%% Local Functions
%%

