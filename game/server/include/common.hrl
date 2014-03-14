%%%------------------------------------------------
%%% File    : common.hrl
%%% Author  : 
%%% Created : 2010-09-15
%%% Description: 公共定义
%%%------------------------------------------------
-include("guild_info.hrl").
-include("record.hrl").
-include("proto.hrl").
-include("language.hrl").
-include("element_type.hrl").
-include("category_type.hrl").
-include("task.hrl").
-include("target.hrl").
-include("error_code.hrl").
-include("item_code.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-include("attribute_type.hrl").
-include("consume_type.hrl").

-define(ALL_SERVER_PLAYERS, 10000).

%%数据库模块选择 (db_mysql 或 db_mongo)
-define(DB_MODULE, db_mysql).
-define(MySqlPoolCount, 12). %% 连接数
-define(MySqlAdminPoolCount, 2). %% 后台连接数

%%mongo主数据库链接池
-define(MASTER_POOLID,master_mongo).

%%mongo从数据库链接池
-define(SLAVE_POOLID,slave_mongo).

%%Mysql数据库连接 
-define(DB_POOL, mysql_conn). 

%% 每个场景的工作进程数
-define(SCENE_WORKER_NUMBER, 1).

%% 帮会进程的工作进程数
-define(GUILD_WORKER_NUMBER, 100).

%%安全校验
%-define(TICKET, "SDFSDESF123DFSDF"). 

-define(QQ_TWG, <<"tgw_l7">>).
%%flash843安全沙箱
-define(FL_POLICY_REQ, <<"<polic">>).
-define(FL_POLICY_FILE, <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>).


%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, false}, {exit_on_close, true}]).
-define(RECV_TIMEOUT, 5000).

%% 心跳包时间间隔
-define(HEARTBEAT_TICKET_TIME, 24*1000).	%%seconds
%% 最大心跳包检测失败次数
-define(HEARTBEAT_MAX_FAIL_TIME, 3).

%% 语言包参数转换
-define(GET_TRAN(Tran, Args),
		io_lib:format(Tran, Args)).

%% ---------------------------------
%% Logging mechanism
%% Print in standard output
-define(PRINT(Text),
    io:format(Text)).
-define(PRINT(Format, Args),
    io:format(Format, Args)).
-define(TEST_MSG(Format, Args),
    logger:test_msg(?MODULE,?LINE,Format, Args)).
-define(DEBUG(Format, Args),
    logger:debug_msg(?MODULE,?LINE,Format, Args)).
-define(INFO_MSG(Format, Args),
    logger:info_msg(?MODULE,?LINE,Format, Args)).
-define(WARNING_MSG(Format, Args),
    logger:warning_msg(?MODULE,?LINE,Format, Args)).
-define(ERROR_MSG(Format, Args),
    logger:error_msg(?MODULE,?LINE,Format, Args)).
-define(CRITICAL_MSG(Format, Args),
    logger:critical_msg(?MODULE,?LINE,Format, Args)).

%% ===========一些特殊处理相关参数的定义=======
-define(DIC_MAP_ONLINE, dic_map_online).		%% 地图在线
-define(DIC_ONLINE, dic_online).			%% 节点在线
-define(DIC_MAP_DROP, dic_map_drop).		%% 物品掉落
-define(DIC_MAP_MON, dic_map_mon).			%% 地图怪物
-define(DIC_MAP_COLLECT, dic_map_collect).	%% 地图采集

%% 联运平台类型
-define(OPERATE_TYPE_QQ, "qq").				%% qq平台
-define(OPERATE_TYPE_UNITE, "unite").		%% 普通联运平台
%% 职业

-define(CAREER_YUEWANG, 1).		%% 岳王宗(尚武)
-define(CAREER_HUAJIAN, 2).		%% 花间派(逍遥)
-define(CAREER_TANGMEN, 3).		%% 唐门(流星)


-define(SPEED_COMMON, 60). 		%% 普通速度
-define(SPEED_HORSE, 80).		%% 骑宠速度
-define(SPEED_ESCORT, 30).		%% 拉镖速度

-define(WAR_GOD_RELIVE_POS, [{426,1648},{1180,518},{3186,340}]).	%% 神出生点
-define(WAR_DEVIL_RELIVE_POS, [{4709,2294},{4232,3251},{2140,3445}]).		%% 魔出生点
-define(WAR_DUPLICATE, 518001).		%% 战场副本

%%战斗力系数 0.2，1.5，0.5，5
-define(FIGHT_CALC_RATIO_02, 0.2).
-define(FIGHT_CALC_RATIO_15, 1.5).
-define(FIGHT_CALC_RATIO_05, 0.5).
-define(FIGHT_CALC_RATIO_50, 5).

%% 岳王宗1023 X:5722 Y:444
%% 花间派1022 X:444 Y:600 
%% 唐门1024 X:2100 Y:3900
-define(MAP_YUEWANG_DEFAULT, {1023, 5740 ,460}).
-define(MAP_HUAJIAN_DEFAULT, {1022 ,500 ,740}).
-define(MAP_TANGMEN_DEFAULT, {1024, 1896 ,3954 }).

-define(MAIN_CITY, {1021, 2460, 3500}).%%2460，3500；5180, 3380
%% 帮派地图 {地图，X， Y}
-define(GUILD_MAP, {10000, 4380,2660}).		
-define(GUILD_MAP_ID, 10000).
%% 副本中的传送门开始编号
-define(MIN_DUPLICATE_DOOR, 3000).


%% 乱斗副本地图ID
-define(FIGHT_DUP_MAP_ID, 1100000).

%%打开发送消息客户端进程数量 
-define(SEND_MSG, 1).		%临时改成1

-define(PID_TEAM, 1).
-define(PID_ITEM, 2).

%%----
-define(EQUIP_STRENG_CELL, 10).									%% 强化加成装备第9格个位置开始4除外
-define(BAG_BEGIN_CELL, 30). 									%% 背包开始格子 
-define(TEMP_BAG_MAX_CELL, 7).								    %% 临时背包最大格子数
-define(DEPOT_BEGIN_CELL, 0).                                   %% 仓库开始格子

-define(CATEGORY_CLOTH, [6,27,28,29]).   						%% 衣服
-define(CATEGORY_SUIT, 8).										%% 时装
-define(CATEGORY_WEAPON, [15,16,17,18,19,20]).  				%% 武器
-define(CATEGORY_MOUNT, 13).  									%% 坐骑
-define(CATEGORY_WING, 5).  									%% 翅膀
-define(STYLE_DEFAULT, <<0:32,0:32,0:32,0:32,0:32,0:32,0:8,0:8>>).				%% 默认样式

-define(WEAPONPLACE, 3).                                        %% 武器位置

-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS,        86400).							%%一天的时间（秒）
-define(ONE_DAY_MILLISECONDS, 86400000).				   		%%一天时间（毫秒）

-define(MAX_OFF_LINE_TIME, 99 * 3600).							%% 最大离线时间
-define(MAX_DUPLICATE_NOT_ENTER_NUM, 99).						%% 最大副本未进入次数

-define(TEAM_WORKER_NUMBER, 100).								%% 组队管理进程的工作进程数
-define(TEAM_MEMBER_MAX, 5).									%% 队伍最大人数
-define(TEAM_MEMBER_MIN, 1).									%% 队伍最小人数
%% 活动系统
-define(GLOBAL_ACTIVE_PROCESS_NAME, mod_active_process).		%% 活动动管理进程名称


%% 江湖令系统
-define(ETS_TOKEN_PUBLISH_1, ets_token_publish_1).				%% 江湖令绿色发布列表
-define(ETS_TOKEN_PUBLISH_2, ets_token_publish_2).				%% 江湖令蓝色发布列表
-define(ETS_TOKEN_PUBLISH_3, ets_token_publish_3).				%% 江湖令紫色发布列表
-define(ETS_TOKEN_PUBLISH_4, ets_token_publish_4).				%% 江湖令橙色发布列表
-define(DIC_TOKEN_AUTO_ID, dic_token_auto_id).					%% 江湖令唯一自增编号
-define(GLOBAL_TOKEN_PROCESS_NAME, mod_token_task_process).		%% 江湖令全局进程名称
-define(MIN_TOKEN_TASK_ID, 1100000).							%% 江湖令接收的任务最少为110万开始

%% 世界数据信息
-define(ETS_WORLD_DATA, ets_world_data).						%% 世界数据
-define(WORLD_LEVEL, world_level).								%% 当前世界等级
-define(MIN_WORLD_LEVEL, 0).									%% 最低世界等级
%%ETS
-define(ETS_SERVER_NODE, ets_server_node).						%% 服务器节点列表							
-define(ETS_SYSTEM_INFO, ets_system_info).						%% 系统配置信息
-define(ETS_MONITOR_PID, ets_monitor_pid).						%% 记录监控的PID
-define(ETS_STAT_SOCKET, ets_stat_socket).						%% Socket送出数据统计(协议号，次数)
-define(ETS_STAT_DB, ets_stat_db).								%% 数据库访问统计(表名，操作，次数)

-define(ETS_SCENE, ets_scene).									%% 本节点场景
%% -define(ETS_SCENE_MON, ets_mon).								%% 本节点场景中怪物
-define(ETS_SCENE_NPC, ets_npc).								%% 本节点场景中NPC
-define(ETS_ONLINE, ets_online).								%% 本节点在线玩家
%% -define(ETS_ONLINE_SCENE, ets_online_scene).					%% 本节点场景中玩家
%% -define(ETS_SCENE_DROP_ITEM, ets_scene_drop_item).				%% 本节点场景中掉落物品
-define(ETS_SCENE_BATTLE_OBJECT, ets_scene_battle_object).		%% 本节点场景中战斗信息

%% -define(ETS_MAP_COLLECT, ets_map_collect).						%% 本地图上采集信息

-define(ETS_TEAM, ets_team).

%% -define(ETS_BASE_SCENE, ets_base_scene).						%% 基础_场景信息
-define(ETS_BASE_SCENE_POSES, ets_base_scene_poses).			%% 基本_场景坐标表

%%	模板数据
-define(ETS_ITEM_TEMPLATE, ets_item_template).					%% 物品模板表
-define(ETS_ITEM_CATEGORY_TEMPLATE, ets_item_category_tempalte).%% 物品类型表
-define(ETS_SHOP_TEMPLATE, ets_shop_template).					%% 商店模板表
-define(ETS_EQUIP_ENCHASE_TEMPLATE, ets_equip_enchase_template).%% 装备镶嵌加成模版
-define(ETS_EQUIP_STRENGTH_TEMPLATE, ets_equip_strength_template).%% 装备强化套装
-define(ETS_STRENGTHEN_TEMPLATE, ets_strengthen_template).		%% 物品强化模板
-define(ETS_REBUILD_PROP_TEMPLATE, ets_rebuild_prop_template).  %% 洗练属性几率模板
-define(ETS_STONE_COMPOSE_TEMPLATE, ets_stone_compose_template).%% 宝石合成模板
-define(ETS_HOLE_TEMPLATE, ets_hole_template).                  %% 物品打孔模板
-define(ETS_ENCHASE_TEMPLATE, ets_enchase_template).            %% 物品镶嵌模板


-define(ETS_BOX_TEMPLATE,  ets_box_template).         		%% 箱子数据模板
-define(ETS_BOX_DATA, ets_box_data).                            %% 分类后箱子数据

-define(ETS_SHOP_DISCOUNT_TEMPLATE, ets_shop_discount_template).%% 优惠商品模板

-define(ETS_SHOP_NPC_TEMPLATE, ets_shop_npc_template).			%% 商店NPC对应NPC编号模板


%% -define(ETS_ALL_FUNCTION_TEMPLATE, ets_all_function_template).  %% 开工炉功能消耗模板

-define(ETS_STRENG_COPPER_TEMPLATE, ets_streng_copper_template).       %% 强化消耗金钱模板
-define(ETS_DECOMPOSE_COPPER_TEMPLATE, ets_decompose_copper_template). %% 洗练消耗金钱模板

-define(ETS_PICK_STONE_TEMPLATE, ets_pick_stone_template).      %% 宝石摘取系数模板
-define(ETS_STRENG_RATE_TEMPLATE, ets_streng_rate_template).    %% 强化成功率加成表
-define(ETS_STRENG_MODULUS_TEMPLATE, ets_streng_modulus_template). %%强化系数表

-define(ETS_DYNAMIC_MON_TEMPLATE, ets_dynamic_mon_template).  %%试练动态怪物系数表

-define(ETS_STRENG_ADDSUCCRATE_TEMPLATE, ets_streng_addsuccrate_template). %%强化失败增加成功率表
-define(ETS_FORMULA_TEMPLATE, ets_formula_template).            %% 配方模板 
-define(ETS_ITEM_UPGRADE_TEMPLATE, ets_item_upgrade_template).			%% 装备精炼模版
-define(ETS_ITEM_UPLEVEL_TEMPLATE, ets_item_uplevel_template).			%% 装备升级模版
-define(ETS_DECOMPOSE_TEMPLATE, ets_decompose_template).        %% 装备分解模板

%%-define(ETS_REBUILD_TEMPLATE, ets_rebuild_template).            %% 装备洗练成功几率模板

-define(ETS_ITEM_STONE_TEMPLATE, ets_item_stone_template).      %% 物品镶嵌宝石类型匹配
-define(ETS_MONSTER_TEMPLATE, ets_monster_template).			%% 怪物模板表
-define(ETS_NPC_TEMPLATE, ets_npc_template).					%% NPC模板表
-define(ETS_COLLECT_TEMPLATE, ets_collect_template).			%% 采集模板表
-define(ETS_ITEM_FUSION_TEMPLATE, ets_item_fusion_template).	%% 装备熔炼模版表

-define(ETS_TOKEN_TASK_TEMPLATE, ets_token_task_template).		%% 江湖令任务模板

-define(ETS_TASK_TEMPLATE, ets_task_template).					%% 任务模板
-define(ETS_TASK_STATE_TEMPLATE, ets_task_state_template).		%% 任务状态模板
-define(ETS_TASK_AWARD_TEMPLATE, ets_task_award_template).		%% 任务奖励模板

-define(ETS_WELFARE_TEMPLATE, ets_welfare_template).			%% 福利奖励模版
-define(ETS_WELFARE_EXP_TEMPLATE, ets_welfare_exp_template).	%% 经验福利兑换模版

-define(ETS_VEINS_TEMPLATE, ets_veins_template).				%% 筋脉模版
-define(ETS_VEINS_EXTRA_TEMPLATE, ets_veins_extra_template).	%% 经脉奖励模版

-define(ETS_SKILL_TEMPLATE, ets_skill_template).				%% SKILL模板表
-define(ETS_BUFF_TEMPLATE, ets_buff_template).					%% BUFF模板表

-define(ETS_GUILD_TEMPLATE, ets_guild_template).				%% 帮会等级基础信息
-define(ETS_GUILD_SUMMON_TEMPLATE, ets_guild_summon_template).	%% 帮会活动召唤信息
-define(ETS_GUILD_PRAYER_LIST, ets_guild_prayer_list).	%% 帮会祈福信息

-define(ETS_FURNACE_LEVEL_TEMPLATE, ets_guilds_furnace_leve_template).%% 帮会等级基础信息
-define(ETS_SHOP_LEVEL_TEMPLATE, ets_guilds_shop_leve_template).%% 帮会等级基础信息

-define(ETS_DOOR_TEMPLATE, ets_door_template).					%% 门模板表
-define(ETS_MAP_TEMPLATE, ets_map_template).					%% 地图模板
-define(ETS_EXP_TEMPLATE, ets_exp_template).					%% 经验模板
-define(ETS_USER_ATTR_TEMPLATE,ets_user_attr_template).         %% 人物基础属性模板
-define(ETS_PETS_ATTR_TEMPLATE,ets_pets_attr_template).         %% 宠物基础属性模板
-define(ETS_TITLE_TEMPLATE,ets_title_template).                 %% 人物称号模板
-define(ETS_SIT_AWARD_TEMPLATE, ets_sit_award_template).		%%打坐奖励模板表

-define(ETS_CHALLENGE_DUPLICATE_TEMPLATE, ets_challenge_duplicate_template).%%试炼副本模版
-define(ETS_SHENYOU_TEMPLATE, ets_shenyou_template).				%%副本神游模版
-define(ETS_DUPLICATE_TEMPLATE, ets_duplicate_template).		%% 副本模板
-define(ETS_DUPLICATE_LOTTERY_TEMPLATE, ets_duplicate_lottery_template).	%% 副本摇奖模版
-define(ETS_DUPLICATE_MISSION_TEMPLATE, ets_duplicate_mission_template).	%% 副本状态
-define(ETS_DUPLICATE_ITEM_TEMPLATE, ets_duplicate_item_template).		%% 副本掉落物品

-define(ETS_DAILY_AWARD_TEMPLATE, ets_daily_award_template).		%%每日奖励
-define(ETS_VIP_TEMPLATE, ets_vip_template).						%% vip 模板

-define(ETS_QUESTION_BANK_TEMPLATE, ets_question_bank_template).	%%题库模版
-define(ETS_ACTIVE_REFRESH_MONSTER_TEMPLATE, ets_active_refresh_monster_template).%% 日常
-define(ETS_ACTIVE_BAG_TEMPLATE, ets_active_bag_template).
-define(ETS_ACTIVE_EVERYDAY_TEMPLATE, ets_active_everyday_template).  	%% 每日活动配置表	
-define(ETS_ACTIVE_REWARDS_TEMPLATE, ets_active_rewards_template).		%% 活跃度奖励表
-define(ETS_ACTIVE_TEMPLATE, ets_active_template).						%% 活跃度模板表
-define(ETS_ACTIVE_WELFARE_TEMPLATE, ets_active_welfare_template).
-define(ETS_ACTIVITY_TEMPLATE, ets_activity_template).

-define(ETS_OPEN_BOX_TEMPLATE, ets_open_box_template).  %%开箱子模板
-define(ETS_SUIT_NUM_TEMPLATE, ets_suit_num_template).  %%套装编号模板
-define(ETS_SUIT_PROPS_TEMPLATE, ets_suit_props_template). %%套装属性模板

-define(ETS_FREE_WAR_AWARD_TEMPLATE, ets_free_war_award_template).		%%神魔斗法奖励模板

-define(ETS_MOUNTS_TEMPLATE, ets_mounts_template).						%% 坐骑模板表	
-define(ETS_MOUNTS_STAIRS_TEMPLATE, ets_mounts_stairs_template).		%% 坐骑品阶模板表	
-define(ETS_MOUNTS_EXP_TEMPLATE, ets_mounts_exp_template).				%% 坐骑经验模板表	
-define(ETS_MOUNTS_QUALIFICATION_TEMPLATE, ets_mounts_qualification_template).	%% 坐骑资质模板表	
-define(ETS_MOUNTS_GROW_UP_TEMPLATE, ets_mounts_grow_up_template).		%% 坐骑成长模板表	
-define(ETS_MOUNTS_STAR_TEMPLATE, ets_mounts_star_template).			%% 坐骑星级模板表	
-define(ETS_MOUNTS_DIAMOND_TEMPLATE, ets_mounts_diamond_template).		%% 坐骑钻级模板表	
-define(ETS_MOUNTS_REFINED_TEMPLATE, ets_mounts_refined_template).		%% 坐骑洗练模版表
-define(ETS_MOUNTS_REFINED_TEMPLATE1, ets_mounts_refined_template1).		%% 坐骑洗练模版表1

				
-define(ETS_PET_TEMPLATE, ets_pet_template).							%% 宠物模板表	
-define(ETS_PET_STAIRS_TEMPLATE, ets_pet_stairs_template).				%% 宠物品阶模板表	
-define(ETS_PET_EXP_TEMPLATE, ets_pet_exp_template).					%% 宠物经验模板表	
-define(ETS_PET_QUALIFICATION_EXP_TEMPLATE, ets_pet_qualification_exp_template).	%% 宠物资质经验模板表	
-define(ETS_PET_GROW_UP_EXP_TEMPLATE, ets_pet_grow_up_exp_template).			%% 宠物成长经验模板表	
-define(ETS_PET_QUALIFICATION_TEMPLATE, ets_pet_qualification_template).%% 宠物资质模板表	
-define(ETS_PET_GROW_UP_TEMPLATE, ets_pet_grow_up_template).			%% 宠物成长模板表	
-define(ETS_PET_STAR_TEMPLATE, ets_pet_star_template).					%% 宠物星级模板表	
-define(ETS_PET_DIAMOND_TEMPLATE, ets_pet_diamond_template).			%% 宠物钻级模板表
-define(ETS_TARGET_TEMPLATE, ets_target_template).						%% 目标模板表
-define(ETS_AMITY_TEMPLATE, ets_amity_template).						%% 友好度模板表
-define(ETS_ACTIVITY_OPEN_SERVER_TEMPLATE, ets_activity_open_server_template).	%% 活动充值/消耗模板表
-define(ETS_YELLOW_BOX_TEMPLATE, ets_yellow_box_template).				%% 黄钻模板表
-define(ETS_ACTIVITY_SEVEN_TEMPLATE, ets_activity_seven_template).		%% 7天活动模板表	

-define(ETS_SMSHOP_TEMPLATE, ets_smshop_template).  %%神秘商店

%%	动态数据
-define(ETS_SYS_FIRST, ets_sys_first).							%% 天下第一
-define(ETS_USERS_ITEMS, ets_users_items).						%% 用户物品数据
-define(ETS_USERS_FRIENDS, ets_users_friends).					%% 用户好友数据
-define(ETS_USERS_GROUPS,ets_users_groups).                     %% 用户好友分组数据
%% -define(ETS_USERS_TASKS, ets_users_tasks).					%% 用户任务数据

-define(ETS_PET_BATTLE_DATA,ets_pet_battle_data).						%%宠物斗坛数据
-define(ETS_PET_BATTLE_LOG,ets_pet_battle_log).						%%宠物斗坛日志
-define(ETS_USERS_DUPLICATE, ets_users_duplicate).               %% 用户副本数据

-define(ETS_USERS_SALES, ets_users_sales).						%% 用户寄售数据

%% -define(ETS_GUILDS, ets_guilds).								%% 帮会信息
%% -define(ETS_GUILDS_CORPS, ets_guilds_corps).					%% 帮会军团信息
%% -define(ETS_USERS_GUILDS, ets_users_guilds).					%% 用户帮会信息
%% -define(ETS_USERS_GUILDS_REQUEST, ets_users_guilds_request).	%% 用户申请/邀请记录
%% -define(ETS_GUILDS_LOG, ets_guilds_log).						%% 帮会日志


%%	动态临时数据

-define(PET_FIGHT_STATE,1).                                     %% 用户宠物出战状态为1
-define(PET_CALL_BACK_STATE,0).                                 %% 用户宠物召回状态为0


-define(ETS_USERS_MOUNTS, ets_users_mounts).					%% 用户坐骑
-define(MOUNTS_FIGHT_STATE,1).                                  %% 用户坐骑出战状态为1
-define(MOUNTS_CALL_BACK_STATE,0).                              %% 用户坐骑召回状态为0


%%排行榜
%%-define(ETS_RANK, ets_rank).                                    %% 排行榜

-define(MON_LIMIT_NUM, 1000000000).								%% 怪物数量限制数
-define(ETS_TOP_CONFIG, ets_top_config).						%% 排行榜配置信息
-define(ETS_TOP_BINARY_DATA, ets_top_binary_data). 				%% 排行榜打包数据可以直接拿来发送个客户端
-define(ETS_TOP_DATA, ets_top_data).							%% 排行榜数据列表
%%-define(TOP_USER_DISCOUNT_INFO, top_user_discount_info).		%% 上榜用户信息
%%-define(ETS_TOP_DISCOUNT, ets_top_discount).					%% 排行榜列表
-define(ETS_DUPLICATE_TOP,	ets_duplicate_top).					%% 副本排行榜信息


-define(RELIVE_TIME,9).                                       	%% 复活倒计时（原地及等待救援）
-define(LOGIN_ALREADY_DEATH_RATE,1).                            %% 玩家死亡后重新上线的状态比例
-define(RELIVE_AT_PRESENT_DEATH_RATE,0.05).                     %% 玩家死亡后原地复活的状态比例
-define(RELIVE_YUAN_BAO, 10).                                   %% 健康复活需要的元宝
-define(PETS_LIMIT_NUM,4).                                      %% 玩家宠物数量限制数

%% 背包
-define(BAG_TYPE_DELETE, -1). %% 移出类型背包
-define(BAG_TYPE_COMMON, 1).  %%普通背包
-define(BAG_TYPE_PET, 11).	  %%宠物背包
-define(BAG_TYPE_STORE, 21).  %%存储背包
-define(BAG_TYPE_MAIL, 31).   %%邮件背包
-define(BAG_TYPE_SALE, 41).   %%寄售背包
-define(BAG_TYPE_BOX, 51).    %%箱子背包



-define(DIC_TOP_FIGHT_DISCOUNT, dic_top_fight_discount). %%战斗力排行榜
-define(DIC_TOP_LEVEL_DISCOUNT, dic_top_level_discount). %%等级排行榜
-define(DIC_TOP_VEINS_DISCOUNT, dic_top_veins_discount). %%经脉排行榜
-define(DIC_TOP_GENGU_DISCOUNT, dic_top_gengu_discount). %%根骨排行榜
-define(DIC_TOP_COPPER_DISCOUNT, dic_top_copper_discount). %%铜币排行榜
-define(DIC_TOP_ACHIEVE_DISCOUNT, dic_top_achieve_discount). %%成就排行榜

-define(TOP_TYPE_FIGHT,10000). %%战斗力排行
-define(TOP_TYPE_FIGHT_1,10100).%全部女
-define(TOP_TYPE_FIGHT_2,10200).%全部男
-define(TOP_TYPE_FIGHT_3,10300).%岳王宗女
-define(TOP_TYPE_FIGHT_4,10400).%岳王宗男
-define(TOP_TYPE_FIGHT_5,10500).%岳王宗全部
-define(TOP_TYPE_FIGHT_6,10600).%唐门女
-define(TOP_TYPE_FIGHT_7,10700).%唐门男
-define(TOP_TYPE_FIGHT_8,10800).%唐门全部
-define(TOP_TYPE_FIGHT_9,10900).%百花谷女
-define(TOP_TYPE_FIGHT_10,11000).%百花谷男
-define(TOP_TYPE_FIGHT_11,11100).%百花谷全部
-define(TOP_TYPE_LEVEL,20000). %%等级排行
-define(TOP_TYPE_LEVEL_1,20100).
-define(TOP_TYPE_LEVEL_2,20200).
-define(TOP_TYPE_LEVEL_3,20300).
-define(TOP_TYPE_LEVEL_4,20400).
-define(TOP_TYPE_LEVEL_5,20500).
-define(TOP_TYPE_LEVEL_6,20600).
-define(TOP_TYPE_LEVEL_7,20700).
-define(TOP_TYPE_LEVEL_8,20800).
-define(TOP_TYPE_LEVEL_9,20900).
-define(TOP_TYPE_LEVEL_10,21000).
-define(TOP_TYPE_LEVEL_11,21100).
-define(TOP_TYPE_VEINS,30000). %%经脉排行
-define(TOP_TYPE_VEINS_1,30100).
-define(TOP_TYPE_VEINS_2,30200).
-define(TOP_TYPE_VEINS_3,30300).
-define(TOP_TYPE_VEINS_4,30400).
-define(TOP_TYPE_VEINS_5,30500).
-define(TOP_TYPE_VEINS_6,30600).
-define(TOP_TYPE_VEINS_7,30700).
-define(TOP_TYPE_VEINS_8,30800).
-define(TOP_TYPE_VEINS_9,30900).
-define(TOP_TYPE_VEINS_10,31000).
-define(TOP_TYPE_VEINS_11,31100).
-define(TOP_TYPE_GENGU,40000). %%根骨排行
-define(TOP_TYPE_GENGU_1,40100).
-define(TOP_TYPE_GENGU_2,40200).
-define(TOP_TYPE_GENGU_3,40300).
-define(TOP_TYPE_GENGU_4,40400).
-define(TOP_TYPE_GENGU_5,40500).
-define(TOP_TYPE_GENGU_6,40600).
-define(TOP_TYPE_GENGU_7,40700).
-define(TOP_TYPE_GENGU_8,40800).
-define(TOP_TYPE_GENGU_9,40900).
-define(TOP_TYPE_GENGU_10,41000).
-define(TOP_TYPE_GENGU_11,41100).
-define(TOP_TYPE_COPPER,50000).%%铜币排行
-define(TOP_TYPE_COPPER_1,50100).
-define(TOP_TYPE_COPPER_2,50200).
-define(TOP_TYPE_COPPER_3,50300).
-define(TOP_TYPE_COPPER_4,50400).
-define(TOP_TYPE_COPPER_5,50500).
-define(TOP_TYPE_COPPER_6,50600).
-define(TOP_TYPE_COPPER_7,50700).
-define(TOP_TYPE_COPPER_8,50800).
-define(TOP_TYPE_COPPER_9,50900).
-define(TOP_TYPE_COPPER_10,51000).
-define(TOP_TYPE_COPPER_11,51100).
-define(TOP_TYPE_ACHIEVE,60000).%%成就排行
-define(TOP_TYPE_ACHIEVE_1,60100).
-define(TOP_TYPE_ACHIEVE_2,60200).
-define(TOP_TYPE_ACHIEVE_3,60300).
-define(TOP_TYPE_ACHIEVE_4,60400).
-define(TOP_TYPE_ACHIEVE_5,60500).
-define(TOP_TYPE_ACHIEVE_6,60600).
-define(TOP_TYPE_ACHIEVE_7,60700).
-define(TOP_TYPE_ACHIEVE_8,60800).
-define(TOP_TYPE_ACHIEVE_9,60900).
-define(TOP_TYPE_ACHIEVE_10,61000).
-define(TOP_TYPE_ACHIEVE_11,61100).



%% 物品获得途径
-define(ITEM_PICK_NONE,0).		%% 没有效果
-define(ITEM_PICK_SCENE,11).	%% 场景中获得
-define(ITEM_PICK_SYS,12).		%% 系统中获得
-define(ITEM_PICK_CENTER,13).	%% 屏幕中心
-define(ITEM_PICK_LOTTERY,14).	%% 副本抽奖获得
-define(ITEM_PICK_STONE_COMPOSE,15).%% 宝石合成
-define(ITEM_PICK_PET_BOOK_SEAL,16).%% 宠物技能书封印
-define(ITEM_PICK_TASK_AWARD,17).	%% 任务奖励
-define(ITEM_PICK_WELFARE_AWARD,18).%% 福利奖励
-define(ITEM_PICK_PET_BATTLE,19).%% 宠物斗坛
-define(ITEM_PICK_QUENCH, 20). %% 宝石淬炼
-define(ITEM_PICK_DECOMPOSE, 21). %% 宝石分解
-define(PERFECT_QUENCH, 2).	%%完美淬炼
-define(UNPERFECT_QUENCH, 1).		%%精致淬炼

%%邮件类型
-define(Mail_Type_Default,0).   %% 缺省
-define(Mail_Type_Common,1).	%% 普通私人邮件
-define(Mail_Type_AuctionSuccess,2).	%% 拍卖成功邮件
-define(Mail_Type_AuctionFail,	3).		%% 拍卖失败邮件
-define(Mail_Type_BuyItem, 4).			%% 买物品邮件
-define(Mail_Type_GM, 5).				%% 系统邮件
-define(Mail_Type_OpenBox, 6).			%% 箱子物品
-define(Mail_Type_Onsale_delete, 9).	%% 物品寄售撤消

%% -define(MAIL_TYPE_GUILD_ITEM_SUCCESS,7).	%% 帮会物品审核成功邮件
%% -define(MAIL_TYPE_GUILD_ITEM_FAIL,	8).		%% 帮会物品审核失败邮件

-define(MAIL_TYPE_GUILD_BROAD, 11).			%% 公会邮件广播
-define(MAIL_TYPE_COLLECT_ITEM, 21).		%% 背包满了采集物品发送到邮件
-define(MAIL_TYPE_ADD_ITEM, 22).			%% 背包满了增加物品发送到邮件
-define(Mail_Type_Admin, 51).	%% 后台邮件
-define(Mail_Type_NoTice, 52).	%% 公告邮件

-define(GM_ID, 1000).
-define(GM_NICK, "SSZT--GM").

%%信息类型 

-define(EVENT,1).	%事件栏
-define(CHAT,2).	%聊天栏
-define(FLOAT,3).	%浮动栏
-define(ALTER,4).	%警告框
-define(NOTIC,5).	%系统公告
-define(ROLL,6)	.	%滚动栏




%%信息颜色类型 
-define(WRITE,-1). 
-define(BLUE,-1).
-define(ORANGE,-1).
-define(GREEN,-1).
-define(RED,-1).
     
-define(None,-1).%%没有

%%战斗 
-define(BattleActorCantFight,301).                              %%攻击者不能战斗
-define(BattleActorSkillCantUse,302).							%%攻击者技能不可用
-define(BattleNoTarget,303).         							%%攻击者未选定目标
-define(BattleTargetCantFight,304).  							%%目标不能被攻击
-define(BattleToFar,305).            							%%距离太远

%%蓄气
-define(SkillPrepare,1).										%%蓄气
-define(SkillCancel,2).											%%打断

%%技能对象
-define(Skill_Target_Enemy,0).									%% 技能在敌人上生效
-define(Skill_Target_Self,1).									%% 技能在自身生效
-define(Skill_Target_Self_Group,2).									%% 技能在自身团队

%%技能使用装备限制
-define(Skill_Use_Item_None,0).									%% 技能不需装备限制
-define(Skill_Use_Item_Knife,15).								%% 技能需要用刀
-define(Skill_Use_Item_Sword,16).								%% 技能需要用剑
-define(Skill_Use_Item_Stick,17).								%% 技能需要用杖
-define(Skill_Use_Item_Flap,18).								%% 技能需要用扇
-define(Skill_Use_Item_Bow,19).									%% 技能需要用弓
-define(Skill_Use_Item_Crossbow,20).							%% 技能需要用弩

%技能类型
-define(ACT_SKILL,0).				%%主动技能
-define(PASV_SKILL,1).				%%被动技能
-define(ASSIST_SKILL,2).			%%辅助技能
-define(OWNER_SKILL,3).				%%辅主技能
-define(PET_PASV_SKILL,4).			%%宠物被动技能

%%拾取物品 
-define(DropItemSuccess,401).   								%%拾取成功
-define(DropItemNoItem,402).   									%%无物品
-define(DropItemToFar,403).   									%%距离太远
-define(DropItemNoOwn,404).   									%%不属于
-define(DropItemNoEnough,405).   								%%无空间

-define(DROP_ITEM_FREE, 0).	    %% 自由拾取
-define(DROP_ITEM_RANDOM, 1).	%% 随机分配

%%打孔
%% -define(ITEMCATEID,47).                                         %%物品的category_id
-define(TAPCATEID,301).                                         %%打孔石的category_id

%%装备分解
%%-define(NODECOMPOSEITEM, [3,5,8,10,13]).                        %%不能分解的装备类型列表(副手 背饰 时装 法宝 坐骑)
-define(SMALLITEMCATE, 1).                                      %%装备类型最小的值
-define(MAXITEMCATE, 80).                                       %%装备类型最大的值
-define(PROTSTRENGLEVEL, 3).                                    %%受保护装备的强化等级

-define(BULEQUALITY, 2).                                        %%装备蓝色品质
-define(PURPLEQUALITY, 3).                                      %%装备紫色品质
-define(ORANGEEQUALITY, 4).										%%装备橙色品质

%%出售 卖店货币类型
-define(NOBINDCOPPER, 0).                                       %%0为不绑定铜币
-define(BINDCOPPER, 1).                                         %%1为绑定铜币

%%仓库操作类型
-define(DEPOSITMONEY, 0).                                       %%存款
-define(DRAWMONEY, 1).                                          %%取款
-define(DEPOTMAXNUM, 36).
-define(MAXCOMMONCOUNT, 216).
-define(MAXDEPOTCOUNT, 108).


%%添加物品时的叠加判断
-define(CANSUMMATION, 1).                                       %%可叠加
-define(NOCANSUMMATION, 0).                                     %%不可叠加
-define(NOBIND, 0).
-define(BIND, 1).                                                 
-define(CANRETRIEVE, 1).                                        %%可以分解
-define(CANREBUILD, 1).                                         %%可以洗练

-define(FISIONNEEDCOPPER, 33600).                               %%融合消耗金钱

-define(BING_TYPE_0, 0).                                        %%装备后绑定
-define(BIND_TYPE_1, 1).                                        %%绑定
-define(BIND_TYPE_2, 2).                                        %%未绑定


%%购买物品的数量
-define(MINAMOUNT, 1).                                         
-define(MAXAMOUNT, 1000).





%%装备修理
-define(ALLITEMFIX, 999).                                       %%装备全部修理
-define(EQUIPSTEREPLACE, 0).                                    %%玩家装备起始位置
-define(EQUIPENDPLACE, 29).                                     %%玩家装备终止位置   

%%装备强化
-define(STRENGLUCKCATE, 509).                                   %%强化幸运石category_id
-define(STRENGMAXLEVEL, 12).                                    %%强化最高等级

-define(PRIMARYLEVEL, 1).                                       %%初级强化石等级
-define(MIDDLELEVEL, 2).                                        %%中级强化石等级
-define(HIGHTLEVEL, 3).                                         %%高级强化石等级  

-define(PRIMAXLEVEL, 3).                                        %%初级强化石强化最大等级
-define(MIDMAXLEVEL, 7).                                        %%中级强化石强化最大等级
-define(HIGMAXLEVEL, 11).                                       %%高级强化石强化最大等级

-define(PRIMARYSTERENGLIST, [0,1,2,3]).
-define(MIDDLESTRENGLIST, [4,5,6,7]).
-define(HIGHTSTRENGLIST, [8,9,10,11]).

-define(STRENGTHEN_LEVEL_UNIT, 100).%%强化等级单位
-define(MAX_STRENGTHEN_LEVEL, 1300). %%最高强化等级
-define(MIN_EQUIP_STRENG_ADD_LEVEL, 700). %%最低装备强化加成所需强化等级
-define(MIN_EQUIP_STRENG_ADD_NUM, 9). %% 最少装备强化加成所需装备数
-define(LUCKSUCCRATE, 5).                                       %%幸运石增加的成功率

%%宝石摘取
-define(PRIMARYPICKLIST, [1,2,3]).                              %%初级摘取符摘取的石头等级
-define(MIDDLEPICKLIST, [4,5,6]).                               %%中级摘取符摘取的石头等级
-define(HIGHTPICKLIST, [7,8,9,10]).                               %%高级摘取符摘取的石头等级

%%宝石合成
-define(PRISTONELEVEL, [1,2,3]).                                %%初级合成符的可以合成的石头等级
-define(MIDSTONELEVEL, [4,5,6]).                              %%中级合成符的可以合成的石头等级
-define(HIGHTSTONELEVEL, [7,8,9]).                             %%高级合成符的可以合成的石头等级

%%宝石淬炼
-define(PRIQUENCHLEVEL, [1,2,3]).                                %%初级淬炼石的可以合成的石头等级
-define(MIDQUENCHLEVEL, [4,5,6]).                              %%中级淬炼石的可以合成的石头等级
-define(HIGHTQUENCHLEVEL, [7,8,9,10]).                             %%高级淬炼石的可以合成的石头等级

-define(COMSTONECATAMIN, 305).                                  %%宝石合成的宝石最小类型
-define(COMSTONECATAMAX, 328).                                  %%宝石合成的宝石最大类型

-define(COMSTONE_STONE_NUM, 4).									%%合成宝石所需数量


%%技能
-define(SkillSuccess,501).   									%%操作成功
-define(SkillIsNull,502).   									%%技能为空
-define(SkillUpdateIsNull,503).   								%%升级技能为空
-define(SkillPlayerExperiencesNoEnough,504).   					%%个人历练值不足
-define(SkillExperiencesNoEnough,505).   						%%技能历练值不足
-define(SkillAlreadyGet,506).   								%%技能已学习
-define(SkillGodReputeNoEnough,507).   							%%神族声望不足
-define(SkillGhostReputeNoEnough,508).   						%%魔族声望不足
-define(SkillPlayerLevelNoEnough,509).   						%%人物等级不足
-define(SkillItemNoEnough,510).   								%%物品不足
-define(SkillOtherCampSkillNoEnough,511).   					%%其他阵营技能格不足
-define(SkillSamePlace,512).   									%%快捷栏是同一位置，不用交换
-define(SkillCooperNoEnough,513).   							%%铜币不足

%%组队
-define(TeamSamePlayer,601).   									%%不能自己和自己创建队伍
-define(TeamBothHaveTeam,602).   								%%双方都有队伍
-define(TeamIsFull,603).   										%%队伍已满
-define(TeamKickNoLeader,604).  
-define(TeamKickNoSelf,605).  
-define(TeamNoTeam,606).   
-define(TeamHaveTeam,607).   									%%已有队伍


%%任务类型
-define(TaskDialog,1).											%%对话框
-define(TaskKillMonster,21).									%%打怪
-define(TaskCollectItem,41).									%%收集物品

-define(Buff_Time_Tick, 5000).									%% buff的定时处理时间间隔


%%经验模块
-define(Exp_Max_Level,10).										%% 经验值获得级别，级别相差10级内
-define(Exp_Max_Params,0.02).									%% 相差10级内的经验值参数
-define(Exp_Common_Level,25).									%% 经验值获得级别，级别相差10-25级
-define(Exp_Common_Params,0.04).								%% 相差10-25级内的经验值参数
-define(Exp_Player_Params,0.2).									%% 经验值人物等级参数
-define(Exp_Monster_Params,0.1).								%% 经验值怪物等级参数
-define(ExpX, 0).												%% 经验获得的参数X
-define(Exp_Team_Number_Params,0.2).							%% 经验值团队人数参数
-define(Exp_Team_Player_Params,0.1).							%% 经验值团队人物等级参数
-define(Exp_Team_Monster_Params,0.1).							%% 经验值团队怪物等级参数
-define(Exp_Pet_Params,1.5).									%% 宠物经验值参数
-define(Exp_Pet_Pet_Params,0.2).								%% 宠物经验值的宠物等级参数
-define(Exp_Pet_Monster_Params,0.1).							%% 宠物经验值的怪物等级参数

%%pk
-define(USER_PK_VALUE,10).                                      %% 玩家PK值（红名、白名）

%-define(PK_ONE_POINT,60).										%% 一点前台红名值等于后台60点,10秒减少一点
-define(PK_LEAVE_TIME,10).										%% 脱离战斗时间，单位秒
-define(PK_Actor,1).											%% 更新主动pk时间标志
-define(PK_Target,2).											%% 更新被动pk时间标志
%-define(PK_TMP_Time,1).											%% 战斗中临时附加的pk值
-define(PK_Mode_Change_Time,1800).								%% pk mode转换时间间隔 2*60*60
-define(PK_AUTO_UPDATE_TIME,600).								%% pk 值自动更新时间 10*60 -1 
-define(PK_AUTO_UPDATE_VALUE,1).								%% pk值自动更新时减少的值
-define(PK_KILL_ONE_VALUE,5).									%% 杀死一个玩家加5点
-define(PK_MAX_VALUE,999).										%% PK值上限

-define(PK_LEVEL,29).											%%可转pk状态级别 （大于此值）

-define(PKMode_PEACE,0).		%和平
-define(PKMode_FREEDOM,1).		%自由
-define(PKMode_GOODNESS,2).		%善恶
-define(PKMode_TEAM,3).			%队伍
-define(PKMode_CLUB,4).			%帮派
-define(PKMode_CAMP,5).			%阵营

%%人物属性
-define(ATTACK_PHYSICS,1).	        %普通攻击
-define(DEFENCE_PHYSICS,2).	        %普通防御
-define(HURT_PHYSICS,3).	        %普通伤害
-define(ATTACK_VINDICTIVE,4).	    %斗气攻击
-define(ATTACK_MAGIC,5).	        %魔法攻击

%% buff 相关
-define(HP_BUFF_REDUCE_MAX_EFFECT,1).	%buff对hp的影响，扣到1就不再扣
-define(MP_BUFF_REDUCE_MAX_EFFECT,0).	%buff对mp的影响，扣到0

-define(SPEED_BUFF_REDUCE_MAX_EFFECT,1).	%buff对speed的影响，扣到1就不再扣

-define(BUFFBLOOD,	1).					%%血包Buff
-define(BUFFMAGIC, 	2).					%%魔法Buff
-define(BUFFEXP, 	3).					%%经验Buff
-define(BUFFNORMAL, 4).					%%普通Buff
%% -define(BUFFSPEED,	5).					%%速度Buff
%% -define(BUFFSTATE,	6).					%%状态Buff
%% -define(BUFFCUTBLOOD,	7).				%%掉血Buff


%% 寄售系统
-define(SALES_TYPE_ITEM_SALE, 1).		%寄售类型:物品出售
-define(SALES_TYPE_COPPER_SALE, 2).		%寄售类型:铜币出售
-define(SALES_TYPE_YUAN_BAO_SALE, 3).	%寄售类型:元宝出售

-define(SALES_TYPE_ITEM_NEED, 4).		%寄售类型:物品求购
-define(SALES_TYPE_COPPER_NEED, 5).     %寄售类型:铜币求购
-define(SALES_TYPE_YB_NEED, 6).			%寄售类型:元宝求购

-define(SALES_PRICE_TYPE_COPPER, 2).	%寄售价格类型:铜币价
-define(SALES_PRICE_TYPE_YB, 3).	    %寄售价格类型:元宝价

-define(SALES_PAGE_SIZE, 4).			%寄售分页大小（一页显示记录数）
-define(SALES_QUERY_MIN_LEVEL, 0). 		%寄售查询最小等级
-define(SALES_QUERY_MAX_LEVEL, 99). 	%寄售查询最大等级

-define(SALES_QUALITY_ALL, 99).			%寄售查询所有品质
-define(SALES_LEVEL_ALL, 0).			%寄售查询所有等级
-define(SALES_CAREER_ALL, 0).			%寄售查询所有职业

%% 交易系统
-define(TRADE_OFFLINE, 2).				%% 对方离线
-define(TRADE_BUSY, 3).					%% 对方正在忙
-define(TRADE_TRADING, 4). 				%% 交易中
-define(TRADE_FIGHTING, 5). 			%% 战斗中
-define(TRADE_SITTING, 6). 				%% 打坐中
-define(TRADE_DEAD, 7).					%% 死亡中
%% 帮会相关
-define(GUILD_BUILD_LEVEL,30).			%建帮会级别
-define(GUILD_BUILD_COPPER,250000).			%建帮会铜币
-define(GUILD_BUILD_CORPS_COPPER,30).			%建军团铜币
-define(GUILD_PRAYER_PRICE, 10).		%% 帮会祈福价格10贡献
-define(GUILD_PRAYER_MAX_NUM, 5).		%% 帮会每天最多祈福次数

-define(GUILD_UPDATE_MEMBER_MONEY, 100).	%扩展成员位置需要的帮会资金

-define(GUILD_JOIN_LEVEL,30).			%加入帮会级别
-define(GUILD_LEAVE_JOIN_TIME, 86400).		%退出后重新加入的时间

-define(GUILD_JOB_NONE,0).				%未加入帮会
-define(GUILD_JOB_PRESIDENT,1).				%会长
-define(GUILD_JOB_VICE_PERSIDENT,2).		%副会长
-define(GUILD_MEMBER_HONORARY,3).			%荣誉会员
-define(GUILD_MEMBER_COMMON,4).				%普通会员


-define(GUILD_MAX_CORPS_NUMBER,7).			%最大军团数量
-define(GUILD_CORP_JOB_LEADER,1).			%军团长
-define(GUILD_CORP_JOB_NONE,2).				%普通成员
-define(GUILD_CORP_JOB_NOT_IN,3).			%未加入军团

-define(GUILD_CORP_MEMBER_MAX,10).			%军团成员最大数

-define(GUILD_DECLARATION_MAX,100).			%宣言最大长度
-define(GUILD_QQ_MAX,40).			%宣言最大长度
-define(GUILD_YY_MAX,40).			%宣言最大长度

-define(GUILD_ERROR_NAME_NOT_VALID,1).				%帮会名不合法
-define(GUILD_ERROR_NAME_ALREADY_HAVE,2).			%帮会名重复
-define(GUILD_ERROR_CREATE_TOO_SHORT,3).			%名字太短
-define(GUILD_ERROR_CREATE_TOO_LONG,4).				%名字太长

-define(GUILD_ERROR_NOT_ENOUGH_LEVEL,11).			%级别不足
-define(GUILD_ERROR_NOT_ENOUGH_CASH,12).				%资金不足
-define(GUILD_ERROR_NOT_ENOUGH_GUILD_MONEY,13).		%帮会资金不足
-define(GUILD_ERROR_NOT_ENOUGH_GUILD_NEED,14).		%帮会贡献或活跃不足

-define(GUILD_ERROR_ALREADY_HAVE_GUILD,21).			%已有帮会
-define(GUILD_ERROR_NOT_ENOUGH_RIGHT,22).				%权限不足
-define(GUILD_ERROR_NOT_GUILD,23).					%没有该帮会
-define(GUILD_ERROR_NOT_SAME_GUILD,24).				%非同一帮会
-define(GUILD_ERROR_NOT_CORP,25).					%没有该军团
-define(GUILD_ERROR_NOT_SAME_CORP,26).				%非同一军团
-define(GUILD_ERROR_LEADER_NOT_ALLOW,27).			%会长或队长不被允许执行
-define(GUILD_ERROR_NOT_EXISTS_PLAYER,28).			%此人不存在

-define(GUILD_ERROR_DB_CAUSE,31).					%DB引起的

-define(GUILD_ERROR_FULL_MEMBER,41).					%人员已满
-define(GUILD_ERROR_CORP_FULL_MEMBER,42).			%军团人员已满

-define(GUILD_ERROR_SETTING_MAX_NUMBER,51).			%会员数最大值已到
-define(GUILD_ERROR_SETTING_MAX_LEVEL,52).			%已升到最高级

-define(GUILD_ERROR_ALREADY_TRYIN,61).				%已经申请过
-define(GUILD_ERROR_NEVER_TRYIN,62).				%没有申请过

-define(GUILD_ERROR_NOT_ONLINE,71).					%目标不在线
-define(GUILD_ERROR_WAREHOUSE_MAX,81).				%仓库满
-define(GUILD_ERROR_WAREHOUSE_USER_NO_ITEM,82).
-define(GUILD_ERROR_WAREHOUSE_ITEM_BIND,83).
-define(GUILD_ERROR_WAREHOUSE_NULL,84).
-define(GUILD_ERROR_WAREHOUSE_NOT_ITEM,85).
-define(GUILD_ERROR_BAG_MAX,86).

-define(GUILD_ERROR,90).

-define(GUILD_WAREHOUSE_PAGE_SIZE,50).				%仓库每页的量
-define(GUILD_WAREHOUSE_MAX,150).					%仓库最大值

-define(GUILD_LOG_SYSTEM,0).			%系统记事
-define(GUILD_LOG_MASTER,1).			%会长发布的记事
-define(GUILD_LOG_ITEM_GET,3).
-define(GUILD_LOG_ITEM_PUT,4).

-define(GUILD_TRANSPORT_TIME,	7230).		%帮会运镖时间，时间为2小时+30秒，单位是秒	

-define(GUILD_CREATE_TYPE_CARD, 1).		%% 建帮令
-define(GUILD_CREATE_MONEY,2).			%% 铜币建帮


-define(MONSTER_COMMON_MOVE,60).			   %%怪物移动速度，暂时写在这 
-define(MONSTER_RETURN_MOVE,120).			

%%副本类型
-define(DUPLICATE_TYPE_WORLD,0).	%%世界地图
-define(DUPLICATE_TYPE_NORMAL,1).	%%普通副本
-define(DUPLICATE_TYPE_BATCH,2).	%%分批副本
-define(DUPLICATE_TYPE_GUARD,3).	%%守护副本
-define(DUPLICATE_TYPE_PASS,4).		%%通关副本
-define(DUPLICATE_TYPE_GUILD,5).	%%公会副本
-define(DUPLICATE_TYPE_TREASURE,6).	%%藏宝副本
-define(DUPLICATE_TYPE_MONEY,7).	%%打钱副本
-define(DUPLICATE_TYPE_CHALLENGE,8).%%试炼挑战副本
-define(DUPLICATE_TYPE_OTHER,9).	%%其它副本目前还未使用
-define(DUPLICATE_TYPE_FIGHT,11).	%%乱斗副本

-define(DUPLICATE_TYPE_GUILD1,10).	%%公会营地

-define(DUPLICATE_TYPE_TEAM_PASS,14).%%组队爬塔

-define(DUPLICATE_TYPE_PVP1,21).	%%PVP1副本（单挑副本）
-define(DUPLICATE_TYPE_PVP2,22).	%%PVP2副本 (资源战场或天下第一)

-define(DUPLICATE_RESET_ZTG_PRICE, 98).		%%重置遮天阁副本价格
-define(DUPLICATE_ZTG_ID, 4200601).			%%遮天阁副本编号
-define(DUPLICATE_RESET_YMH_PRICE, 128).	%%重置狱魔会副本价格
-define(DUPLICATE_YMH_ID, 4200901).			%%狱魔会副本编号

-define(DUPLICATE_PVP1_MAP_ID, 1000000).		%%PVP1单挑王副本地图ID
-define(RESOURCE_WAR_MAP_ID, 9000001).		%%资源战副本地图ID
-define(PVP_FIRST_MAP_ID, 9000002).		%%天下第一副本地图ID
-define(DUPLICATE_MONEY_MAP_ID, 7200201). %%打钱副本地图ID
-define(CHALLENGE_DUPLICATE_ID, 8200801).	%%试炼副本编号
-define(ACTIVE_MONSTER_MAP_ID, 9000003).	%% 活动boss副本ID
-define(ACTIVE_GUILD_FIGHT_MAP_ID, 9000005).	%% 公会乱斗副本地图ID
-define(ACTIVE_KING_FIGHT_MAP_ID, 9000004).	%% 王城战副本地图ID
-define(ACTIVE_KING_NORMAL_MAP_ID, 1033).	%% 王城地图ID

-define(MAX_CHALLENGE_NUM_WTHE_AWARD, 10). %%最大有奖励的挑战次数

%%战场相关
-define(MAX_RESOURCE_WAR_JOIN_NUM, 500).				%%战场最高参与人数
-define(CHANGE_RESOURCE_WAR_CAMP_PRICE, 100).			%%切换阵营价格
-define(ENTER_RESOURCE_WAR_NPC_POS,{1021,6981,941}).	%%进入战场的npc坐标

%%天下第一
-define(MAX_PVP_FIRST_JOIN_NUM, 500).				%%天下第一最高参与人数
-define(ENTER_PVP_FIRST_NPC_POS,{1021,6981,941}).	%%进入天下第一的npc坐标

%%活动boss相关
-define(ACTIVE_BOSS_ID, 900000301).				%%活动boss的怪物ID

%%王城战相关
-define(KING_FIGHT_ITEM_ID, 900000406).				%%王城战的守护圣物ID
-define(KING_FIGHT_MONSTER_ID, [{900000404,1}, {900000414,2},{900000424,3},{900000402,5}, {900000401,5}, {900000405,10}]).				%%守卫，箭塔，拒马，将军ID

%%人物关系

-define(RELATION_FRIEND_QUERY, 2#1000000000000000). % (1 bsl 15)).  %% 好友申请
-define(RELATION_FRIEND, 2#100000000000000). % (1 bsl 14)). 	%% 好友
-define(RELATION_FRIEND_CANCEL, 2#1011111111111111).			%%取消好友时对应的二进
-define(RELATION_BLACK, 2#10000000000000). % (1 bsl 13)). 	%% 黑名单
-define(RELATION_BLACK_CANCEL, 2#1101111111111111).			%%取消黑名单时对应的二进
-define(RELATION_ENEMY, 2#1000000000000). % 1 bsl 12).		%% 仇人
-define(RELATION_ENEMY_CANCEL, 2#1110111111111111).			%%取消仇人时对应的二进

-define(RELATION_FRIEND_OR_ENEMY, 2#101000000000000).		%% 仇人或者好友


-define(RELATION_FRIENDS_MAX,99).                                  %% 好友数量限制数 
-define(RELATION_BLACKS_MAX,99).                                  %% 黑名单数量限制数 
-define(RELATION_ENEMYS_MAX,50).                                  %% 仇人数量限制数 
-define(GROUPS_LIMIT_NUM,10).                                   %% 好友分组数量限制数



-define(DIC_USERS_RELATION,dic_users_relation).
-define(DIC_USERS_RELATION_GROUP,dic_users_relation_group).
-define(DIC_USERS_PK,dic_users_pk).

-define(DUPLICATE_PID_DIC, duplicate_pid_dic). %% 副本pid进程字典

-define(DIC_BATTLE_CONTENT_PLAYER,dic_battle_content_player).			%%战斗所需 结构 {ID,[{skill_prepare,{PS,PST}},{skill_time,[{S1,ST1},{S2,ST2}]},
-define(DIC_BATTLE_CONTENT_MON,dic_battle_content_mon).

%% -define(DIC_MAP_MONSTER,dic_map_monster).
-define(DIC_MAP_BATTLE_OBJECT_PLAYER,dic_map_battle_object_player).	%%战斗对象信息
-define(DIC_MAP_BATTLE_OBJECT_MON,dic_map_battle_object_mon).	%%战斗对象信息
-define(DIC_MAP_LOOPTIME, dic_map_looptime).				%怪物等循环时间信息，保存下一次的时间
-define(DIC_MAP_OBJECT_AUTO_ID, dic_map_object_auto_id).		%地图上物品的自动id
-define(DIC_MAP_MON_AUTO_ID, dic_map_mon_auto_id).

-define(DIC_MAP_ID, dic_map_id).					%地图id
-define(DIC_MAP_RANDOM_LOCAL, dic_map_random_local).	%%地图随机掉落位置

-define(DIC_GUILDS, dic_guilds).
-define(DIC_LEAVE_GUILDS_USERS, dic_leave_guilds_users).
-define(DIC_USERS_GUILDS, dic_users_guilds).		%%仅记录用户id和帮会id
-define(DIC_GUILDS_LOGS, dic_guilds_logs).
-define(DIC_GUILDS_BATTLE, dic_guilds_battle).
-define(DIC_USERS_GUILDS_REQUEST, dic_users_guilds_request).

-define(DIC_MAP_TOWER_MON, dic_map_tower_mon).		%%守塔怪

-define(DIC_MAP_USER_INFO, dic_map_user_info).

-define(LOOPTIME, 125).		%怪物循环时间
-define(BATTLE_LOOPTIME,1000).	%怪物战斗时的循环时间
-define(NOT_NEED_GUARD_LOOPTIME,120000).	%当属于被动怪而且不需要巡逻时的怪的下次循环时间
-define(ACT_TYPE_ACT, 2). 			%%主动怪
-define(ACT_TYPE_PASV, 1).			%%被动怪
-define(ACT_TYPE_ACT_TOWER, 3).		%%主动塔

-define(MONSTER_TYPE_PATH_GUARD, 4).%%守塔副本怪物
-define(MONSTER_TYPE_STONE, 5).%%石头类怪物
-define(MONSTER_TYPE_SEAL,6).%%封印类怪物

-define(ACT_TYPE_ACT_OUR_BOSS, 10). %%我方塔防boss
-define(ACT_TYPE_ACT_OUR_TOWER, 13).%%我方塔

-define(DROP_ITEM_LIST_ROUND,100).		%% 掉落随机列表长度
-define(DROP_LOCAL_LIST_ROUND,30).		%% 掉落位置随机列表长度

%%============对象状态==============

-define(ELEMENT_STATE_COMMON,1).			%%通常状态
-define(ELEMENT_STATE_FIGHT,2).				%%战斗状态
-define(ELEMENT_STATE_DEAD,4).				%%死亡状态
-define(ELEMENT_STATE_READYFORPOWER,8).		%%吟唱状态
-define(ELEMENT_STATE_HITDOWN,16).			%%击倒
-define(ELEMENT_STATE_INVINCIBLE, 32).		%% 无敌

-define(INVICIBLE_TIME, 1500).				%% 无敌时间


%%============VIP=========================
-define(VIP_BSL_ONEHOUR, 2#1000000).			%% 体验VIP
-define(VIP_BSL_DAY, 2#100000).					%% 一天VIP
-define(VIP_BSL_HALFYEAR, 2#10000).				%% 半年卡
-define(VIP_BSL_MONTH, 2#1000).					%% 月卡
-define(VIP_BSL_WEEK, 2#100).					%% 周卡
-define(VIP_BSL_GM, 2#10).						%% GM
-define(VIP_BSL_NEWPLAYERLEADER, 2#1).			%% 新手指导员
%%模板id
-define(VIP_ONE_HOUR_ID, 5).
-define(VIP_ONE_DAY_ID, 4).
-define(VIP_HALF_YEAR_ID, 3).
-define(VIP_MONTH_ID, 2).
-define(VIP_WEEK_ID,1).
-define(VIP_NONE,0).

%%============脱离战斗定时================
-define(LEAVE_BATTLE_SECONDS,7). %7秒

-define(GUILD_BATTLE_GUILD_LEVEL,2).	%帮会战帮会等级
-define(GUILD_BATTLE_USER_LEVEL,40).	%帮会战人物等级
-define(GUILD_BATTLE_START_SECONDS, 36000). 	%10*60*60 帮会战开始时间秒数
-define(GUILD_BATTLE_END_SECONDS, 64800). 	%18*60*60 帮会战开始时间秒数
-define(GUILD_BATTLE_END_DAY,86400).

-define(GUILD_BATTLE_DECLEAR_FREE,0).		%%普通宣战
-define(GUILD_BATTLE_DECLEAR_FORCE,1).		%%强行宣战

-define(GUILD_BATTLE_DEAL_ACCEPT,0).		%%同意宣战
-define(GUILD_BATTLE_DEAL_DIS,1).		%%拒绝宣战

-define(GUILD_FEATS_LIMIT,25).			%% 每日贡献上限

-define(GUILD_WEAL_NEED_FEATS,10).		%% 福利需要的功勋


-define(Target_for_tower, 13).	%% 塔攻击目标
-define(Tower_Target_Mon, 10).	%% 守塔目标怪物标志

-define(ACCEPT_DISTANT, 300).	%% npc对话距离最大范围



-define(TASKACTIVE,1). 			%%任务活动
-define(DUPLICATEACTIVE,2). 	%%进副本活动
-define(ACTIVE,3). 				%%活动
-define(ACTIVE_PVP,4).			%% PVP
-define(ACTIVE_TOKEN,5).		%%江湖令接/发
-define(ONLINE_TIME,6).		    %%在线时长
-define(STRENG_EQUIP,7).		%%强化
-define(TAO_BAO,8).				%%淘宝
-define(BUY_SHOP,9).			%%神秘商店购买
-define(REBUILD_EQUIP,10).		%%洗炼
%%====================================================
%%活动相关
-define(PVP1_ACTIVE_ID, 1001). %%pvp活动编号
-define(QUESTION_ACTIVE_ID, 1004).%%答题活动编号
-define(PATROL_ACTIVE_ID, 1005).%%巡逻活动编号
-define(GUILD_POUNCE_ACTIVE_ID, 1006).%%公会突袭编号
-define(ESCORT_ACTIVE_ID, 1007).%%拉镖活动
-define(RESOURCE_WAR_ACTIVE_ID, 1008).%%资源战活动
-define(PVP_FIRST_ACTIVE_ID,1009).%%天下第一活动
-define(MONSTER_ACTIVE_ID, 1011). %%世界boss活动
-define(GUILD_FIGHT_ACTIVE_ID, 1012). %%公会乱斗活动
-define(KING_FIGHT_ACTIVE_ID, 1013). %%王城战

-define(MAX_ACTIVE_QUESTION_NUMBER, 30). %%答题活动问题数
-define(QUESTION_ACTIVE_MAP_ID, 2070).		%%答题活动所在地图
-define(QUESTION_ACTIVE_ANSWER_LIMIT_COORDINATE, 1300). %%答题站位坐标分割点
%% 天下第一
-define(PVP_FIRST_TYPE, 1).			%%PVP天下第一
-define(PVP_FIRST_OTHER_CAMP, 4).		%其它阵营
-define(PVP_FIRST_FIRST_CAMP, 5).		%天下第一阵营

%% 王城战
-define(ETS_KING_WAR_INFO,ets_king_war_info).		%%王城战信息
-define(KING_FINGHT_ATT_CAMP, 6).	%% 王城战攻击阵营
-define(KING_FINGHT_DEF_CAMP, 7).	%% 王城战防御阵营

-define(MAX_SMSHOP_REF_TIMES,3).    %% 至尊VIP神秘商店刷新次数(普通一次vip奖励2次)


