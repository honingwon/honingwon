%%%------------------------------------
%%% @Module  : mod_kernel
%%% @Author  : txj
%%% @Created : 2011.02.22
%%% @Description: 核心服务
%%%------------------------------------
-module(mod_kernel).
-behaviour(gen_server).
-export([
            start_link/0
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl"). 

-define(AUTO_LOAD_GOODS, 10*60*1000).  	%%每10分钟加载一次数据(正式上线后，去掉)

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).


%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	misc:write_monitor_pid(self(),?MODULE, {0}),
    %%初始ets表
    ok = init_ets(),
	%% 加载基础数据 
	ok = load_base_data(),
	%% 对外开放服务的延迟处理
	ets:new(service_open, [{keypos, #service_open.id}, named_table, public, set]),
	case config:get_service_wait_time() of
		undefined -> 
			ets:insert(service_open,#service_open{id = 1, is_open = 1});
		Wait_time -> 
			ets:insert(service_open,#service_open{id = 1, is_open = 0}),
			erlang:send_after(Wait_time*1000, self(), open_service)
	end,	
%% 	erlang:send_after(?AUTO_LOAD_GOODS, self(), reload_data),  %% 重复加载一次数据(正式上线后，去掉)
    {ok, 1}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_kernel handle_call is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{reply, ok, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_kernel handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.
%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
	try
		do_info(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_kernel handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(normal, Status) ->
	misc:delete_monitor_pid(self()),
    {ok, Status}.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%%=========================================================================
%% 业务处理函数
%%=========================================================================
%% 加载基础数据
load_base_data() ->
	
	load_template_data(attr),	
	load_template_data(pets),
	load_template_data(item),
	load_template_data(mon),
	load_template_data(collect),
	load_template_data(npc),
	load_template_data(exp),
	load_template_data(skill),
	load_template_data(veins),
	load_template_data(buff),
	load_template_data(guild),
	load_template_data(guild_furnace_level),
	load_template_data(guild_summon),
	load_template_data(guild_prayer),
	load_template_data(guild_shop_level),
	load_template_data(task),
	load_template_data(welfare),
	load_template_data(welfare_exp),
	load_template_data(token_task),
	load_template_data(door),
	load_template_data(map),
	load_template_data(title),
	load_template_data(duplicate),
	load_template_data(sit_award),
	load_template_data(daily_award),
	load_template_data(shenyou),
	load_template_data(vip),
	load_template_data(free_war_award),
	load_template_data(mounts),
	load_template_data(active),
	load_template_data(target),
	load_template_data(challenge),
	load_template_data(active_refresh_monster),
	load_template_data(question_bank),
	load_template_data(amity),
	load_template_data(active_open_server),
	load_template_data(yellow_box),
	load_template_data(top_config),
	load_template_data(king_war_info),
	ok.

%% 人物基础属性
load_template_data(attr) ->
	ok = lib_player:init_user_attr_template(),
	ok;

%% 宠物基础属性
load_template_data(pets) ->
	ok = lib_pet:init_template(),
	ok;

%% 人物称号
load_template_data(title) ->
	ok = lib_player:init_user_title_template(),
	ok;

%% 副本模板
load_template_data(duplicate) ->
	ok = lib_duplicate:init_template_duplicate(),
	ok;

%% 技能
load_template_data(skill) ->
	ok = lib_skill:init_template_skill(),
	ok;

%% 经脉
load_template_data(veins) ->
	ok = lib_veins:init_template_veins(),
	ok;

%% buff
load_template_data(buff) ->
	ok = lib_buff:init_template_buff(),
	ok;

%% 帮会各级别模板 
load_template_data(guild) ->
	ok = lib_guild:init_template_guild(),
	ok;

%% 帮会各级别模板 
load_template_data(guild_furnace_level) ->
	ok = lib_guild:init_template_guild_furnace_level(),
	ok;
%帮会活动召唤模版
load_template_data(guild_summon) ->
	ok = lib_guild:init_guild_summon_template(),
	ok;

load_template_data(guild_prayer) ->
	ok = lib_guild:init_guild_prayer_template(),
	ok;

%% 帮会各级别模板 
load_template_data(guild_shop_level) ->
	ok = lib_guild:init_template_guild_shop_level(),
	ok;

%% 物品
load_template_data(item) ->
    ok = item_util:init_item_template(),
	ok;

%% 怪物
load_template_data(mon) -> 
	ok = lib_mon:init_template_mon(),
	ok;

%% 采集
load_template_data(collect) -> 
	ok = lib_collect:init_template_collect(),
	ok;

%% npc
load_template_data(npc) -> 
	ok = lib_npc:init_template_npc(),
	ok;

%% 经验
load_template_data(exp) ->
	ok = lib_exp:init_template_exp(),
	ok;

%% 任务
load_template_data(task) ->
	lib_task:init_template_task(),
	ok;
%% 福利奖励
load_template_data(welfare) ->
	lib_welfare:init_welfare_template(),
	ok;
%% 经验福利兑换
load_template_data(welfare_exp) ->
	lib_welfare:init_welfare_exp_template(),
	ok;
%% 江湖令模版
load_template_data(token_task) ->
	lib_token_task:init_template_token_task(),
	ok;
%% 门模板
load_template_data(door) ->
	lib_door:init_template_door(),
	ok;

%%地图模板
load_template_data(map) -> 
	lib_map:init_template_map(),
	ok;

%%打坐修炼模板
load_template_data(sit_award) ->
 	lib_sit:init_template_sit_award(),
	ok;

%% 每日奖励模板
load_template_data(daily_award) ->
	lib_daily_award:init_template_daily_award(),
	ok;

%% 每日奖励模板
load_template_data(shenyou) ->
	lib_shenyou:init_shenyou_template(),
	ok;

%% vip模板
load_template_data(vip) ->
	lib_vip:init_vip_award(),
	ok;

load_template_data(free_war_award) ->
	lib_free_war:init_free_war_award(),
	ok;

load_template_data(mounts) ->
	lib_mounts:init_template(),
	ok;

%% 活动
load_template_data(active) ->
	lib_active:init_template(),
	ok;
%% 试炼副本模版
load_template_data(challenge) ->
	lib_challenge_duplicate:init_challenge_duplicate(),
	ok;

load_template_data(active_refresh_monster) ->
	lib_active_refesh_monster:init_refesh_monster_template(),
	ok;
load_template_data(question_bank) ->
	lib_active_question:init_question_bank_template(),
	ok;
%% 友好度
load_template_data(amity) ->
	lib_friend:init_template_amity(),
	ok;

load_template_data(active_open_server) ->
	lib_active_open_server:init_template(),
	ok;

load_template_data(yellow_box) ->
	lib_yellow:init_template(),
	ok;

load_template_data(target) ->
	lib_target:init_template_target(),
	ok;


load_template_data(top_config) ->
	lib_top:init_top_config(),
	ok;

%王城战信息
load_template_data(king_war_info) ->
	lib_king_fight:init_king_war_info_ets(),
	ok.



%%初始ETS表
init_ets() ->
	%% 	模板数据
	ets:new(?ETS_WORLD_DATA, [{keypos, #ets_world_data.key}, named_table, public, set]),%% 物品模板表
    ets:new(?ETS_ITEM_TEMPLATE, [{keypos, #ets_item_template.template_id}, named_table, public, set]),%% 物品模板表
    ets:new(?ETS_ITEM_CATEGORY_TEMPLATE, [{keypos, #ets_item_category_template.item_category_id}, named_table, public ,set]),%% 物品类型表
	ets:new(?ETS_SHOP_TEMPLATE, [{keypos, #ets_shop_template.id}, named_table, public ,set]),%% 商店模板表 ,key{shop_id,template_id,pay_type}
	ets:new(?ETS_REBUILD_PROP_TEMPLATE, [{keypos, #ets_rebuild_prop_template.quality}, named_table, public ,set]), %% 洗练属性几率模板
	ets:new(?ETS_STRENGTHEN_TEMPLATE, [{keypos, #ets_strengthen_template.level}, named_table, public ,set]), %% 强化基础配置信息模板
	ets:new(?ETS_EQUIP_ENCHASE_TEMPLATE, [{keypos, #ets_equip_enchase_template.level}, named_table, public ,set]), %% 装备镶嵌加成配置信息模板
	ets:new(?ETS_EQUIP_STRENGTH_TEMPLATE, [{keypos, #ets_equip_strength_template.level}, named_table, public ,set]), %% 装备强化加成配置信息模板
	ets:new(?ETS_ITEM_FUSION_TEMPLATE, [{keypos, #ets_item_fusion_template.item_template_id1}, named_table, public ,set]), %% 装备熔炼配置信息模板
	
	ets:new(?ETS_STONE_COMPOSE_TEMPLATE, [{keypos, #ets_stone_compose_template.stone_level}, named_table, public ,set]), %%宝石合成金钱消耗模板
	ets:new(?ETS_HOLE_TEMPLATE, [{keypos, #ets_hole_template.holeflag}, named_table, public, set]), %%物品打孔模板
	ets:new(?ETS_ITEM_STONE_TEMPLATE, [{keypos, #ets_item_stone_template.category_id}, named_table, public, set]), %%物品镶嵌宝石模板
    ets:new(?ETS_ENCHASE_TEMPLATE, [{keypos, #ets_enchase_template.stone_level}, named_table, public, set]), %%物品镶嵌模板
	
	ets:new(?ETS_SHOP_DISCOUNT_TEMPLATE, [{keypos, #ets_shop_discount_template.id}, named_table, public ,set]),%% 优惠抢购商品模板表

	ets:new(?ETS_SHOP_NPC_TEMPLATE, [{keypos, #ets_shop_npc_template.shop_id}, named_table, public ,set]),%% 商店NPC对应NPC编号模板表
	ets:new(?ETS_BOX_DATA, [{keypos, #ets_box_data.id}, named_table, public, set]),
	ets:new(?ETS_SMSHOP_TEMPLATE, [{keypos, #ets_smshop_template.id}, named_table, public, set]),
	
	ets:new(?ETS_SUIT_PROPS_TEMPLATE, [{keypos, #ets_suit_props_template.id}, named_table, public, set]),
	
%%  ets:new(?ETS_ALL_FUNCTION_TEMPLATE, [{keypos, #ets_all_function_template.id}, named_table, public, set]), %%开工炉功能消耗模板
   
	ets:new(?ETS_STRENG_COPPER_TEMPLATE, [{keypos, #ets_streng_copper_template.streng_level}, named_table, public, set]),
	ets:new(?ETS_DECOMPOSE_COPPER_TEMPLATE, [{keypos, #ets_decompose_copper_template.quality}, named_table, public, set]),
	
	ets:new(?ETS_PICK_STONE_TEMPLATE, [{keypos, #ets_pick_stone_template.stone_level}, named_table, public, set]),  %%宝石摘取系数模板
%%  ets:new(?ETS_REBUILD_TEMPLATE, [{keypos, #ets_rebuild_template.id}, named_table, public, set]),      %%洗练成功几率模板
    ets:new(?ETS_STRENG_RATE_TEMPLATE, [{keypos, #ets_streng_rate_template.id}, named_table, public, set]), %%强化成功率加成表
	ets:new(?ETS_STRENG_MODULUS_TEMPLATE, [{keypos, #ets_streng_modulus_template.id}, named_table, public, set]),
	
	ets:new(?ETS_DYNAMIC_MON_TEMPLATE, [{keypos, #ets_dynamic_mon_template.level}, named_table, public, set]),

	ets:new(?ETS_STRENG_ADDSUCCRATE_TEMPLATE, [{keypos, #ets_streng_addsuccrate_template.failacount}, named_table, public, set]),
	
	ets:new(?ETS_FORMULA_TEMPLATE, [{keypos, #ets_formula_template.formula_id}, named_table, public, set]), %%配方模板
	ets:new(?ETS_DECOMPOSE_TEMPLATE, [{keypos, #ets_decompose_template.quality}, named_table, public, set]), %%装备分解模板
	ets:new(?ETS_ITEM_UPGRADE_TEMPLATE, [{keypos, #ets_item_upgrade_template.item_template_id}, named_table, public, set]), %%装备升级模版
	ets:new(?ETS_ITEM_UPLEVEL_TEMPLATE, [{keypos, #ets_item_uplevel_template.item_template_id}, named_table, public, set]), %%装备精炼模版
	ets:new(?ETS_MONSTER_TEMPLATE, [{keypos, #ets_monster_template.monster_id}, named_table, public, set]),	%%基础_怪物信息
    ets:new(?ETS_NPC_TEMPLATE, [{keypos, #ets_npc_template.npc_id}, named_table, public, set]),			%%基础_NPC信息
	
	ets:new(?ETS_TOKEN_TASK_TEMPLATE, [{keypos, #ets_token_task_template.type}, named_table, public, set]),			%%江湖令任务模板信息

	ets:new(?ETS_TASK_TEMPLATE, [{keypos, #ets_task_template.task_id}, named_table, public, set]),			%%任务模板信息
	ets:new(?ETS_TASK_STATE_TEMPLATE,[{keypos, #ets_task_state_template.task_state_id}, named_table, public, set]), %%任务状态信息
	ets:new(?ETS_TASK_AWARD_TEMPLATE,[{keypos, #ets_task_award_template.award_id}, named_table, public, set]),
	
	ets:new(?ETS_WELFARE_TEMPLATE,[{keypos, #ets_welfare_template.login_day}, named_table, public, set]),		%%福利奖励模版信息
	ets:new(?ETS_WELFARE_EXP_TEMPLATE,[{keypos, #ets_welfare_exp_template.type_id}, named_table, public, set]),	%%经验福利兑换模版信息

	ets:new(?ETS_SKILL_TEMPLATE, [{keypos, #ets_skill_template.skill_id}, named_table, public, set]),    %%基础技能信息
	ets:new(?ETS_VEINS_TEMPLATE, [{keypos, #ets_veins_template.acupoint_id}, named_table, public, set]),    %%基础经脉信息
	ets:new(?ETS_VEINS_EXTRA_TEMPLATE, [{keypos, #ets_veins_extra_template.need_level}, named_table, public, set]),    %%经脉奖励信息
	ets:new(?ETS_BUFF_TEMPLATE, [{keypos, #ets_buff_template.buff_id}, named_table, public, set]),		 %%buff信息
	
	ets:new(?ETS_GUILD_SUMMON_TEMPLATE, [{keypos, #ets_guild_summon_template.id}, named_table, public, set]),	%%帮会活动召唤信息
	ets:new(?ETS_GUILD_PRAYER_LIST, [{keypos, #ets_guild_prayer_list.id}, named_table, public, set]),	%%帮会活动召唤信息
	ets:new(?ETS_GUILD_TEMPLATE, [{keypos, #ets_guilds_template.guild_level}, named_table, public, set]),	%%基础帮会等级信息
	ets:new(?ETS_FURNACE_LEVEL_TEMPLATE, [{keypos, #ets_guilds_furnace_leve_template.furnace_level}, named_table, public, set]),	%%会神炉等级信息
	ets:new(?ETS_SHOP_LEVEL_TEMPLATE, [{keypos, #ets_guilds_shop_leve_template.shop_level}, named_table, public, set]),	%%帮会商城等级信息
	
	ets:new(?ETS_DOOR_TEMPLATE, [{keypos, #ets_door_template.door_id}, named_table, public, set]),   	 %%门模板信息
	ets:new(?ETS_MAP_TEMPLATE, [{keypos, #ets_map_template.map_id}, named_table, public ,set]),			 %% 地图模板信息
	ets:new(?ETS_EXP_TEMPLATE, [{keypos, #ets_exp_template.level}, named_table, public ,set]),			 %% 经验模板
	ets:new(?ETS_USER_ATTR_TEMPLATE,[{keypos, #ets_user_attr_template.career}, named_table, public ,set]),       %% 人物基础属性模板 
	ets:new(?ETS_PETS_ATTR_TEMPLATE,[{keypos, #ets_pets_attr_template.template_id}, named_table, public ,set]),  %% 宠物基础属性模板
	
	ets:new(?ETS_TITLE_TEMPLATE,[{keypos, #ets_title_template.id}, named_table, public ,set]),                   %% 人物称号模板
	
	ets:new(?ETS_QUESTION_BANK_TEMPLATE,[{keypos, #ets_question_bank_template.id}, named_table, public ,set]),		%% 题库模板
	ets:new(?ETS_COLLECT_TEMPLATE,[{keypos, #ets_collect_template.template_id}, named_table, public ,set]),		%% 采集模板
	ets:new(?ETS_CHALLENGE_DUPLICATE_TEMPLATE,[{keypos, #ets_challenge_duplicate_template.id}, named_table, public ,set]),		%% 试炼副本模板
	ets:new(?ETS_SHENYOU_TEMPLATE,[{keypos, #ets_shenyou_template.id}, named_table, public ,set]),		%% 副本神游模板
	ets:new(?ETS_ACTIVE_REFRESH_MONSTER_TEMPLATE,[{keypos, #ets_active_refresh_monster_template.active_id}, named_table, public ,set]),		%% 日常模板
	ets:new(?ETS_DUPLICATE_TEMPLATE,[{keypos, #ets_duplicate_template.duplicate_id}, named_table, public ,set]),		%% 副本模板
	ets:new(?ETS_DUPLICATE_MISSION_TEMPLATE,[{keypos, #ets_duplicate_mission_template.mission_id}, named_table, public ,set]),		%% 关卡模板
	
 	ets:new(?ETS_SIT_AWARD_TEMPLATE,[{keypos, #ets_sit_award_template.level}, named_table, public ,set]),	%% 打坐奖励模板表
	ets:new(?ETS_DAILY_AWARD_TEMPLATE,[{keypos, #ets_daily_award_template.award_id}, named_table, public, set]),	%%每日奖励模板表
	ets:new(?ETS_VIP_TEMPLATE, [{keypos, #ets_vip_template.vip_id}, named_table, public, set]),	%% vip 模板
	ets:new(?ETS_FREE_WAR_AWARD_TEMPLATE, [{keypos, #free_war_award.level_index}, named_table, public, set]),	%% 神魔斗法奖励模板表

	
	ets:new(?ETS_MOUNTS_TEMPLATE, [{keypos, #ets_mounts_template.template_id}, named_table, public, set]),						%% 坐骑模板表
	ets:new(?ETS_MOUNTS_STAIRS_TEMPLATE, [{keypos, #ets_mounts_stairs_template.template_id}, named_table, public, set]),		%% 坐骑品阶模板表	
	ets:new(?ETS_MOUNTS_EXP_TEMPLATE, [{keypos, #ets_mounts_exp_template.level}, named_table, public, set]),					%% 坐骑经验模板表	
	ets:new(?ETS_MOUNTS_QUALIFICATION_TEMPLATE, [{keypos, #ets_mounts_qualification_template.template_id}, named_table, public, set]),	%% 坐骑资质模板表	
	ets:new(?ETS_MOUNTS_GROW_UP_TEMPLATE, [{keypos, #ets_mounts_grow_up_template.template_id}, named_table, public, set]),		%% 坐骑成长模板表	
	ets:new(?ETS_MOUNTS_STAR_TEMPLATE, [{keypos, #ets_mounts_star_template.template_id}, named_table, public, set]),			%% 坐骑星级模板表	
	ets:new(?ETS_MOUNTS_DIAMOND_TEMPLATE, [{keypos, #ets_mounts_diamond_template.template_id}, named_table, public, set]),		%% 坐骑钻级模板表
	ets:new(?ETS_MOUNTS_REFINED_TEMPLATE, [{keypos, #ets_mounts_refined_template.template_id}, named_table, public, set]),		%% 坐骑洗练模板表
	ets:new(?ETS_MOUNTS_REFINED_TEMPLATE1, [{keypos, #ets_mounts_refined_template.template_id}, named_table, public, set]),		%% 坐骑洗练模板表1

	ets:new(?ETS_PET_TEMPLATE, [{keypos, #ets_pet_template.template_id}, named_table, public, set]),							%% 宠物模板表
	ets:new(?ETS_PET_STAIRS_TEMPLATE, [{keypos, #ets_pet_stairs_template.template_id}, named_table, public, set]),				%% 宠物品阶模板表	
	ets:new(?ETS_PET_EXP_TEMPLATE, [{keypos, #ets_pet_exp_template.level}, named_table, public, set]),							%% 宠物经验模板表
	
	ets:new(?ETS_PET_QUALIFICATION_EXP_TEMPLATE, [{keypos, #ets_pet_qualification_exp_template.level}, named_table, public, set]),	%% 宠物资质经验模板表	
	ets:new(?ETS_PET_GROW_UP_EXP_TEMPLATE, [{keypos, #ets_pet_grow_up_exp_template.level}, named_table, public, set]),			%% 宠物成长经验模板表	

	ets:new(?ETS_PET_QUALIFICATION_TEMPLATE, [{keypos, #ets_pet_qualification_template.template_id}, named_table, public, set]),%% 宠物资质模板表	
	ets:new(?ETS_PET_GROW_UP_TEMPLATE, [{keypos, #ets_pet_grow_up_template.template_id}, named_table, public, set]),			%% 宠物成长模板表	
	ets:new(?ETS_PET_STAR_TEMPLATE, [{keypos, #ets_pet_star_template.template_id}, named_table, public, set]),					%% 宠物星级模板表	
	ets:new(?ETS_PET_DIAMOND_TEMPLATE, [{keypos, #ets_pet_diamond_template.template_id}, named_table, public, set]),			%% 宠物钻级模板表

%% 	ets:new(?ETS_ACTIVE_EVERYDAY_TEMPLATE, [{keypos, #ets_active_everyday_template.id}, named_table, public, set]),				%% 每日活动配置表
    ets:new(?ETS_ACTIVE_TEMPLATE, [{keypos, #ets_active_template.id}, named_table, public, set]),								%% 活跃度模板表
	ets:new(?ETS_ACTIVE_REWARDS_TEMPLATE, [{keypos, #ets_active_rewards_template.id}, named_table, public, set]),				%% 活跃度奖励表

	ets:new(?ETS_TARGET_TEMPLATE, [{keypos, #ets_target_template.target_id}, named_table, public, set]),						%% 目标模板表
	ets:new(?ETS_AMITY_TEMPLATE, [{keypos, #ets_amity_template.level}, named_table, public, set]),								%% 友好度模板表
	ets:new(?ETS_ACTIVITY_OPEN_SERVER_TEMPLATE, [{keypos, #ets_activity_open_server_template.id}, named_table, public, set]),	%% 开服活动度模板表
	ets:new(?ETS_YELLOW_BOX_TEMPLATE, [{keypos, #ets_yellow_box_template.id}, named_table, public, set]),						%% 黄钻模板表
	ets:new(?ETS_ACTIVITY_SEVEN_TEMPLATE, [{keypos, #ets_activity_seven_template.id}, named_table, public, set]),				%% 7天活动模板表	



	ets:new(?ETS_TOP_CONFIG, [{keypos, #ets_top_config.id}, named_table, public ,set]),%% 排行榜查询配置表
	ets:new(?ETS_TOP_BINARY_DATA, [{keypos, 1}, named_table, public ,set]),%% 排行榜打包数据可以直接拿来发送个客户端
	ets:new(?ETS_TOP_DATA, [{keypos, 1}, named_table, public ,set]),%% 排行榜数据列表
	%% 	动态数据
	ets:new(?ETS_SYS_FIRST, [{keypos, #ets_sys_first.type}, named_table, public ,set]),%% 天下第一
	%%ets:new(?TOP_USER_DISCOUNT_INFO, [{keypos, #top_user_info.user_id}, named_table, public ,set]),%% 排行榜玩家详细性息
	%%ets:new(?ETS_TOP_DISCOUNT, [{keypos, #top_list.top_type}, named_table, public ,set]),%% 排行榜列表
	ets:new(?ETS_DUPLICATE_TOP, [{keypos, #top_duplicate_List.duplicate_id}, named_table, public ,set]),%% 副本排行榜列表
	ets:new(?ETS_USERS_ITEMS, [{keypos, #ets_users_items.id}, named_table, public ,set]), %%用户物品表
	ets:new(?ETS_USERS_FRIENDS, [{keypos, #ets_users_friends.user_id}, named_table, public ,bag]), %%好友信息表
	ets:new(?ETS_USERS_GROUPS, [{keypos, #ets_users_groups.id}, named_table, public ,set]), %%好友分组表
	ets:new(?ETS_PET_BATTLE_LOG, [{keypos, #pet_battle_log_list.user_id}, named_table, public ,set]), %%宠物战斗日志
	ets:new(?ETS_PET_BATTLE_DATA, [{keypos, #ets_pet_battle.pet_id}, named_table, public ,set]), %%宠物战斗数据
	ets:new(?ETS_KING_WAR_INFO, [{keypos, #ets_king_war_info.id}, named_table, public ,set]), %%王城战信息
%% 	ets:new(?ETS_USERS_TASKS, [{keypos, #ets_users_tasks.user_id}, named_table, public, bag]), %% 用户任务
	
%%	ets:new(?ETS_USERS_DUPLICATE, [{keypos, #ets_users_duplicate.user_id}, named_table, public ,set]), %%用户副本
	
%% 	ets:new(?ETS_BASE_SCENE, [{keypos, #ets_map.id}, named_table, public, set]), 					%%基础_场景信息
	ets:new(?ETS_BASE_SCENE_POSES, [named_table, public, bag]),   									%%基本_场景坐标表
	
	ets:new(?ETS_ONLINE, [{keypos,#ets_users.id}, named_table, public, set]), 			%%本节点在线用户列表
%% 	ets:new(?ETS_ONLINE_SCENE, [{keypos,#ets_users.id}, named_table, public, set]),  	%%本节点加载场景在线用户列表
	
%% 	ets:new(?ETS_SCENE_DROP_ITEM, [{keypos,#r_drop_item.id}, named_table, public, set]),	%%本节点掉落信息
%% 	ets:new(?ETS_SCENE_BATTLE_OBJECT,[{keypos,#battle_object_state.id}, named_table, public, set]),	%%本节点战斗信息

%% 	ets:new(?ETS_SCENE_MON, [{keypos, #r_mon_info.unique_key}, named_table, public, set]), %%本节点怪物信息
    ets:new(?ETS_SCENE_NPC, [{keypos, #r_npc_info.unique_key}, named_table, public, set]), %%本节点NPC信息
	
%% 	ets:new(?ETS_MAP_COLLECT, [{keypos, #r_collect_info.unique_key}, named_table, public, set]), %% 本节点采集信息
	
	%%	动态临时数据
%% 	ets:new(?ETS_USERS_PETS,[{keypos, #ets_users_pets.id}, named_table, public, set]), 			%% 用户宠物信息
%% 	ets:new(?ETS_USERS_MOUNTS,[{keypos, #ets_users_mounts.id}, named_table, public, set]), 		%% 用户坐骑信息
	
	
    ok. 

%%---------------------do_call--------------------------------
do_call(Info, _, State) ->
	?WARNING_MSG("mod_mon_boss_active call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast({set_load, Load_value}, Status) ->
	misc:write_monitor_pid(self(),?MODULE, {Load_value}),
	{noreply, Status};

do_cast(Info, State) ->
	?WARNING_MSG("mod_mon_boss_active cast is not match:~w",[Info]),
    {noreply, State}.


%%---------------------do_info--------------------------------
%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
do_info(open_service, Status) ->
	ets:insert(service_open, #service_open{id = 1, is_open = 1}),
	{noreply, Status};

do_info(reload_data, Status) ->
	%% 加载基础数据
	load_base_data(),
	erlang:send_after(?AUTO_LOAD_GOODS, self(), reload_data),  %% 重复加载一次数据
	{noreply, Status};

do_info(Info, State) ->
	?WARNING_MSG("mod_mon_boss_active info is not match:~w",[Info]),
    {noreply, State}.

