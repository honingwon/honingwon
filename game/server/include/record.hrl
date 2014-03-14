%%%------------------------------------------------
%%% File    : record.erl
%%% Author  : ygzj
%%% Created : 2010-09-15
%%% Description: record
%%%------------------------------------------------
-include("table_to_record.hrl").

-ifndef(RECORD).
-define(RECORD, true).

%%世界数据
-record(ets_world_data,{
		key,
		value = 1
}).
%%是否对外开放服务
-record(service_open, 
		{id = 1, 
		 is_open = 0 
}).
%%排行榜信息
-record(top_info,
		{top_type = 0,
		 user_id = 0,
		 value = 0		 
}).
%%排行榜玩家信息
%% -record(top_user_info,{
%% 		user_id = 0,
%% 		name ="",
%% 		vip = 0,
%% 		vip_time = 0,
%% 		sex = 0,
%% 		career = 0,
%% 		value = 0,
%% 		guild_name = "",
%% 		equip = ""}).
%% -record(top_list,{
%% 		top_type = 0,
%% 		list = []}).

%%个人排行榜信息保存
-record(top_individual_info,{
		top_id = 0,				%% 排行榜编号
		user_id = 0,			%% 玩家编号
		nick_name = "",			%% 玩家昵称
		vip_level = 0,			%% vip等级
		career = 1,				%% 职业
		guild_name = "",		%% 公会名称
		value = 1				%% 排行具体数值
		}).
%% 其它排行榜信息
-record(top_other_info,{
		top_id = 0,				%% 排行榜编号
		user_id = 0,			%% 玩家编号
		nick_name = "",			%% 玩家昵称
		item_id = 0,			%% 对象唯一编号
		item_name = "",			%% 对象名称
		value = 0				%% 排行具体数值
		}).

%% 服务器副本排行榜
-record(top_duplicate_info,{
		duplicate_id = 0,		%%副本编号
		pass_id = 0,			%%关卡编号
		user_name = "",			%%用户信息
		use_time = 0,			%%消耗时间
		user_id_list = []		%%用户唯一编号
		}).
-record(top_duplicate_List,{
		duplicate_id = 0,
		duplicate_type = 0,
		top_count = 0,		%进榜人数
		state = 0,%%更新状态（0，1增加，2删除）
		list = []
		}).

%% 游戏玩家信息
-record(user_other,{
%% 					user_onself = undefined,
%% 					user_onmap = undefined,
%% 					
					infant_state = 0, 			% 防沉迷，0未登记，1成年，2登记但未成年， 3满三个小时， 4满5个小时
					socket = undefined,			% 当前用户的socket
					pid = undefined,          	% 用户进程Pid
					pid_send = undefined,		% 消息发送进程Pid(可多个)
					node = undefined,			% 进程所在节点
					pid_map = undefined, 	  	% 当前场景Pid
					pid_item = undefined,		% 物品pid
					pid_team = undefined,		% 队伍pid
					pid_dungeon = undefined,	% 副本pid(玩家副本进程!)
					pid_task = undefined,		% 任务pid
					pid_target = undefined,		% 目标pid
					%pid_duplicate = undefiend,	% 副本pid(玩家副本次数统计!)
					pid_veins = undefiend,		% 经脉修炼状态机					

					pid_guild_map = undefined,      % 帮派地图Pid
					guild_map_id = 0,				% 帮派地图Id
					
					guild_level = 0,				% 帮派等级
					current_feats = 0,				% 帮派个人功勋
					total_feats = 0,				% 帮派个人功勋
					guild_furnace_level = 0,		% 帮派演武堂等级
					
					map_template_id = 0,		% 地图模板id
					duplicate_id = 0,           % 副本id
					
					walk_path_bin = undefined,	% 走路路径
					heartbeat_time = 0,			% 移动开始时间
					heartbeat_error_num = 0,		% 移动出错时间
					pid_locked_monster = [],			%锁定当前用户的对象的pid
					skill_list = [],				% 当前skill列表
					skill_bar = [],					% 快捷栏列表 [{index,id,groupid,otherdata}]
					buff_list = [],					%%存在的buff
					remove_buff_list = [],			%%删除了的buff
					remove_buff_list1 = [],			%%删除了的buff
					buff_temp_info = [],			%%添加buff后人物的临时改变属性
					veins_list = [],				%%筋脉列表
					veins_cd = 0,					%%筋脉升级cd
					veins_fail_num = 0,				%%升级根骨失败次数
					bank_list = [],					%%玩家银行投资信息
					
					relive_time = 0,                 %原地复活时间
					pet_id = 0,						 %宠物Id
				   	pet_template_id = 0,			 %出战宠物模板Id
				   	style_id = 0,			 		%换形符模板Id	
					weapon_state = 0,				% 武器是否隐藏
					cloth_state = 0 ,				% 时装是否隐藏
					pet_nick = undefined,			 %出战宠物昵称
					last_pk_actor_time = 0,				%最后主动pk时间
					last_pk_target_time = 0,		%最后被动pk时间
					last_pk_auto_update_time = 0,	%pk值最后自动更新时间
					equip_weapon_type = 0,			%装备的武器的类型
					sit_state = 0,					%0 正常 1单修 2普双休 3特殊双休
					double_sit_id = 0,				%双修玩家ID
					sit_date = 0,					%开始打坐时间
					horse_speed = 0,				%骑上宠速度
					speed = 0,						%速度
					total_title = undefined,		%全部称号
					total_achieve = undefined,		%全部成就
					achieve_data = 0,				%成就值
					blood_buff = [],				%人物血包buff
					magic_buff = [],				%人物魔法buff
					exp_rate = 1,					%人物多倍经验值
					exp_buff = [],					%人物多倍经验列表
					sys_exp_rate = 0,				%系统多倍经验
					collect_status = {},			%{collectId,templateId,cd,starttime}
 					marry_status = {0,0,0,0},		%结婚请求状态{对象id,结婚档次,嫁0/娶1/同意2,申请时间}
					marry_list = [],				%结婚列表娶方可以有多条
					%% 直接交易
					trade_status = {0, 0}, % {交易状态, 对方id}  {0, 0}没有交易  {1, id}启动交易 {2, id}锁定交易 {3, id}确定交易
					trade_list = [],      % 交易物品、货币列表 [{{id, 物品or铜币or元宝, 是否给自己}, 数量}...]

					%%要通知坐标点的怪物pid列表
				    pid_locked_target_monster = [],
					login_time = 0,
					club_name = "",
					club_job = 0,
					allot_mode = undefined,
					map_last_time = 0,	%% 地图最后时间 
					escort_state = 0,	%%镖车品质
					
					player_now_state = 1,		%% 玩家当前状态 ELEMENT_STATE_COMMON
					player_standup_date = 0,	%% 玩家起身时间
					welfare_info = undefined,	%% 福利奖励
					token_info = undefined,		%% 江湖令
					exploit_info = undefined,	%% 玩家功勋信息
					challenge_info = undefined,	%% 玩家试炼信息

					vip_exp_rate = 0,			%% vip经验倍数
					vip_strength_rate = 0,		%% vip强化倍数
					vip_drop_rate = 0,			%% vip副本爆率
					vip_hole_rate = 0,			%% vip打洞倍数
					vip_lifeexp_rate = 0,		%% vip历练倍数
					vip_mounts_stair_rate = 0,	%% 
					vip_pet_stair_rate = 0,		%% 
					vip_vein_rate = 0,			%% vip 根骨加成

%% 					vip_refresh_date = 0,		%% vip状态上次有效处理时间

					last_fight_actor_time = 0,	%% 上次攻击时间
					last_fight_target_time = 0,	%% 上次被击时间

					buff_titleId = 0,			%% BUFF称号
					
					%%人物属性移动到这里，每次登陆时计算处理，不再保存在数据库
					total_life_experiences = 0,
					max_physical = 0,
					hp_revert = 0,
					mp_revert = 0,
					mount_skill_yaoxiao = 0,
					
					total_hp = 0,
					total_mp = 0,
					attack = 0,
					defense = 0,
					magic_hurt = 0,
					mump_hurt = 0,
					far_hurt = 0,
					hit_target = 0,
					duck = 0,
					keep_off = 0,
					power_hit = 0,
					deligency = 0,
					magic_defense = 0,
					mump_defense = 0,
					far_defense = 0,
					mump_avoid_in_hurt = 0,
					far_avoid_in_hurt = 0,
					magic_avoid_in_hurt = 0,
					abnormal_rate = 0,
					anti_abnormal_rate = 0,
					attack_suppression = 0,
					defense_suppression = 0,
					
					move_speed = 0,					%移动速度
					attack_speed = 0,				%攻击速度
					
				   %%临时属性，由于buff等影响
					tmp_totalhp = 0,				%临时最大血量
					tmp_totalmp = 0,				%临时最大魔法
					tmp_attack = 0,
					tmp_defense = 0,
					tmp_magic_hurt = 0,
					tmp_far_hurt = 0,
					tmp_mump_hurt = 0,
					tmp_hit_target = 0,
					tmp_duck = 0,
					tmp_keep_off = 0,
					tmp_power_hit = 0,
					tmp_deligency = 0,
					tmp_magic_defense = 0,
					tmp_mump_defense = 0,
				    tmp_far_defense = 0,
					tmp_magic_avoid_in_hurt = 0,
					tmp_mump_avoid_in_hurt = 0,
					tmp_far_avoid_in_hurt = 0,
					
					tmp_move_speed = 0,
					tmp_attack_speed = 0,

					%其他战斗属性
					damage = 0,
					mump_damage = 0,
					magic_damage = 0,
					far_damage = 0,
					damage_to_shangwu = 0,
					damage_to_xiaoyao = 0,
					damage_to_liuxing = 0,
					damage_from_shangwu = 0,
					damage_from_xiaoyao = 0,
					damage_from_liuxing = 0,
					
					%战斗
					battle_info = undefined,
					
					pet_skill_list = [],  						%% 技能列表
					pet_battle_info = undefined,				   
				   
					sum_packet = 0, 	%% 累积包
					sum_packet_error = 0,	%% 包错误次数
				    war_state = 0,			%% 神魔乱斗状态，0没有，1神，2魔
					index = 0,
					auto_buy = 1,		%% 神炉自动购买		
					active_start_time = 0,%% 个人进入活动时间	
					active_award = [],		%% 活动奖励
					active_id = 0,		%% 如过报名参加活动中，该值为活动ID

					%% QQ黄钻属性
					is_yellow_vip = 0,		%%是否为黄钻用户（0：不是； 1：是）
					is_yellow_year_vip = 0, %% 是否为年费黄钻用户（0：不是； 1：是）
					yellow_vip_level = 0,	%% 黄钻等级，目前最高级别为黄钻8级（如果是黄钻用户才返回此参数）。
					is_yellow_high_vip = 0, %% 是否为豪华版黄钻用户（0：不是； 1：是）
					is_rece_new_pack = 0,	%% 是否领取了新手礼包
					rece_day_pack_date = 0,	%% 领取每日礼包的时间
					level_up_pack = 0		%% 已领取哪一等级的升级礼包
					}).	

%% % 出售价格
-record(item_other,{
					sell_price = 0,		%% 出售价格
					dirty_state = 0,		%%  修改状态，-1表示刚保存过，0没改变，1修改，2新增
					prop_list = [],		%% 洗练属性
					rebuild_list = []	%% 洗练未替换属性
				 }).
%% 附件物品
-record(mail_other,{
					items						
					}).
%%地图其它数据
-record(map_other,{
				   safe_area = [],	%% 安全区域
				   sell_area = [],	%% 摆摊区
				   min_level = 0,   %% 最小等级
				   max_level = 1000 %% 最大等级				   
				   }).
%%地图
-record(ets_map, {	
          mid,                                    %% 场景id
          name = "",                              %% 名称,
          width = 0,							  %% 宽度
		  height = 0,							  %% 高度
		  length_x = 0,                           %% 格子宽度
		  length_y = 0,                           %% 格子高度
		  mon = [],                               %% 怪物信息
		  npc = [],                               %% npc信息
		  id = undefined                          %% 唯一id
    }).	
%%队伍
-record(ets_team, {id = 0,								%% 队伍id
				   pid = undefined,						%% 队伍进程pid
				   leaderid = 0,						%% 队长id
				   leaderpid= undefined,    			%% 队长pid
				   leadername = [],						%% 队长名字
				   leader_level = 1,					%% 队长级别
				   leadermap = 0,						%% 队长所在地图id
				   teamname = [],      					%% 队名
				   member = [],        					%% 队员列表
				   duplicate_pid = undefined,			%% 副本进程id
				   duplicate_map_id = undefined,	    %% 副本场景资源id
				   is_autoin = 1,						%% 自动 , true 自动 0不自动
				   allot_mode = 0,                   	%% 队伍分配方式 ，0自由拾取,  1自动分配
				   drop_owner_id = 1,					%% 自动分配的时候使用顺序循环  
				   allow_invit = 0						%% 允许队员邀请
%% 				   allot_class = 1						%% White = 1,Green = 2,Blue = 3,Purple = 4,
				   }).
%%队员数据
-record(team_member, {id = 0,         		%% 队员id
					  pid = undefined,     	%% 队员pid
					  nickname = [],   		%% 队员名字
					  index = 0,			%% 队员序号
					  state = 1,			%% 队员在线状态,0离线，1在线
					  mapid = 0,			%% 队员所在地图
					  user = undefine		%% 临时使用
					 }).

%% 物品状态表
-record(item_status, {
					  
    				  user_id = 0,                 % 用户ID
					  level = 0,					% 用户等级
					  null_cells = [],             % 背包空格子位置
					  maxbagnull = 0,              % 背包最大格子数
					  temp_bag =[],				   % 临时背包
					  pid = undefined,		       % 用户send_pid
					  user_pid = undefined,			% 用户pid
					  temp_bag_place = 0,		   % 临时背包位置
					  depot_null_cells = [],       % 仓库空格子位置
					  maxdepotnull = 0 ,           % 仓库最大格子
					  maxboxnull = [],             % 箱子仓库最大格子
					  smshop_info = undefined,	   % 神秘商店信息
					  save_date = 0				   % 保存时间
    				  }).
    				  

%% 好友其它数据
-record(other_friend, {
					   nick_name,		%% 昵称
					   sex,				%% 性别
					   career,
					   level,			%% 等级
					   state			%% 状态 1在线0不在线
					   }).
				
-record(other_item_template, {
                          prop_value_list = [],
                          max_rate = 0,
                          
						  attack = 0,          %%攻击力
						  defense = 0,         %%防御
						  mumphurt = 0,        %%斗气攻击力
						  magichurt = 0,       %%魔法攻击力
						  farhurt = 0,         %%远程攻击力
						  mumpdefense = 0,     %%斗气防御
						  magicdefence = 0,    %%魔法防御
						  fardefense = 0,      %%远程防御
						  mump_hurt = 0,       %%斗气伤害
						  magic_hurt = 0,      %%魔法伤害
						  far_hurt = 0,        %%远程伤害
						  hp = 0,              %%生命
						  mp = 0,              %%法力
						  power_hit = 0,       %%致命一击
						  deligency = 0,       %%坚韧
						  hit_target = 0,      %%命中率	
						  duck = 0,            %%回避率	
						  mump_avoid_in_hurt = 0,   %% 斗气免伤
						  far_avoid_in_hurt = 0,    %% 远程免伤
						  magic_avoid_in_hurt = 0,  %% 魔法免伤	
						  attack_suppression = 0,   %% 进攻压制
						  defense_suppression = 0,   %% 防御压制	
						  stone4 = 0,
						  stone5 = 0,
						  stone6 = 0,
						  stone7 = 0,
						  stone8 = 0,
						  stone9 = 0,
						  stone10 = 0
						  }).
						  
%% 副本模板其它数据
-record(other_duplicate_template, {
						  missions = [], %% 关卡
						  lotterys = [] %% 关卡抽奖信息
						  }).

%% 副本状态模板其它数据
-record(other_duplicate_template_state, {
										 mon_list = []	%% 怪物列表
										 }).
										 
%% 副本其它数据
-record(other_duplicate, {
                          dirty_state = 0		%%  修改状态，0没改变，1修改，2新增
                         }).
                         						  							  						  
%% 任务其它数据
-record(other_task, {
					 is_new_finish = 0,		%% 新完成
					 is_new = 0, 			%% 新任务
					 requires = [],			%% 需要列表
					 dirty_state = 0,		%%  修改状态，0没改变，1修改，2新增
					 condition = 0			%%  任务类型
					 }).
					 
					 
%% 任务模板其它数据
-record(other_task_template,{
							 states,	%%状态
							 awards, 	%%奖励		 
							 pre_task_list = [],	%% 前置任务列表
							 next_task_list = []	%% 后置任务列表 
							 }).
							 
							 
%% 任务模板其它数据
-record(other_task_template_state,{
								   awards,
								   target_objects,		%%目标对象	[{Id,Amount},[Id,Amount]]	
							 	   target_amounts,		%%对象需要数量	[Amount1, Amount2]
								   target_ids			%%对象Id [Id1,Id2]
								   }).
%% 江湖令系统记录数据
-record(mod_token_task_state, {token_publish_list_1 = [],
				token_publish_list_2 = [],
				token_publish_list_3 = [],
				token_publish_lsit_4 = [],
				token_count = {1,0,0,0,0}
				}).

%% 玩家试炼副本挑战记录
-record(r_user_challenge_info,{
		user_id = 0,
		challenge_num = 0,				%%每天最大能挑战次数
		challenge_star = [],			%%历史挂卡星数
		last_challenge_time = 0			%%最后一次挑战付费算时间		
		}).

%% 地图怪物信息
-record(r_mon_info,{id = 0,						%% 怪物id
					template_id = 0,			%% 怪物模板id
					monster_type = 0,			%% 怪物类型
					template = undefined,
					can_reborn = 1,
					destruct_time = 0,
					skill_list = undefined,			%% 结构 
					buff_list = [],					%%buff[{buffid,上次起效时间,结束时间}]
					map_id = 0,					%% 地图id
					born_x = 0,					%% 出生点x
					born_y = 0,					%% 出生点y
					pos_x = 0,					%% 当前坐标x
					pos_y = 0, 					%% 当前坐标y
					hp = 0,			
					mp = 100,					%% 怪物目前无MP，战斗判断不会用到，设100方便逻辑
					last_path = undefined,
					last_path_num = 0,			%% 塔防副本怪物巡逻路径点
					pid = undefined,			%% 怪物进程
					state = undefined,			%% 状态
					last_walk_time = undefined,	%% 上次行走时间
					harted_list = undefined,	%% 仇恨列表
					total_been_hurted = 0, 		%% 总共伤害
					drop_list_common = [], 		%% 通常掉落物 = 固定掉落物，在列表内的物品每项都会随机计算掉落，一次可能掉落多件
				   	drop_list_task = [],		%% 任务掉落物
					drop_list_once = [],		%% 在列表内的物品在每次掉落计算时只会出现1件
					drop_roll_times = 0,		%% 每次死亡时处理drop_list_once的次数
					drop_random_list_index = 1,	%% 掉落随机位置列表的索引，在掉落随机列表中抽对应位置物品掉落
					drop_random_list = [],		%% 取drop_list_once的位置列表
					
					drop_local_random_list_index = 1,	%% 掉落位置索引
					
					move_time = 0,				%% 移动时间，单位毫秒
				   	%%临时属性，由于buff等影响
					tmp_attack_physics = 0,
					tmp_hit = 0,
					tmp_critical = 0,
					tmp_attack_magic = 0,
					tmp_attack_range = 0,
					tmp_attack_vindictive = 0,
					tmp_move_speed = 0,
					tmp_attack_speed = 0,
					tmp_dodge = 0,
					tmp_block = 0,
					tmp_tough = 0,
					tmp_defanse_physics = 0,
					tmp_defanse_magic = 0,
					tmp_reduce_magic = 0,
					tmp_defanse_range = 0,
					tmp_reduce_range = 0,
					tmp_defanse_vindictive = 0,
					tmp_reduce_vindictive = 0,
					move_speed = 0,
				    attack_speed = 0,
				    target_pid = undefined,
					next_work_time = 0,
					total_skill_percent = 0,
					next_skill_nth = 1,
					%战斗
					battle_info = undefined,
					
					monster_now_state = 1		%?ELEMENT_STATE_COMMON
					}).

%% 地图NPC信息
-record(r_npc_info,{id = 0,
					template_id = 0,
					map_id = 0,
					pos_x = 0,
					pos_y = 0,
					unique_key = undefined		%% 
					}).

%% 地图元素信息
-record(r_elem_info,{id = 0,
					unique_key = undefined
				   }).


-record(battle_info, {
					  effect_hp = [], 			%当前回合影响的hp
					  effect_mp = [],			%当前回合影响的mp
					  effect_buff_list = [],	%当前回合的buff list
					  
					  attack = 0,			%% 普通攻击力
					  defense = 0,			%% 普通防御力
					  damage = 0,			%% 普通攻击伤害
					  
					  
					  magic_hurt = 0,		%% 魔法攻击
					  magic_defense = 0,		%% 魔法防御
					  magic_damage = 0,			%% 魔法伤害
					  magic_avoid_in_hurt = 0,		%% 魔法吸收
					  
					  mump_hurt = 0,		%% 斗气攻击
					  mump_defense = 0,			%% 斗气防御
					  mump_damage = 0,			%% 斗气伤害
					  mump_avoid_in_hurt = 0,		%% 斗气吸收
					  
					  far_hurt = 0,			%% 远程攻击
					  far_defense = 0,			%% 远程防御
					  far_damage = 0,			%% 远程伤害
					  far_avoid_in_hurt = 0,		%% 远程吸收
					  
					  pet_attack_type = 0,			%宠物属攻类型

					  keep_off = 0,			%% 格挡
					  
					  hit_target = 0,		%% 命中
					  duck = 0,				%%回避率
					  
					  power_hit = 0,		%%致命一击
					  deligency = 0,		%%坚韧

					  abnormal_rate = 0,			%% 异常机率
					  anti_abnormal_rate = 0,		%% 抗异常机率
					  
					  attack_suppression = 0,		%% 攻击压制
					  defense_suppression = 0,		%% 防御压制
					  
					  battle_physics_x = 0, %%战斗备用变量x 物理
					  battle_range_x = 0, %%战斗备用变量x  范围
					  battle_magic_x = 0, %%战斗备用变量x 内力
					  battle_vindictive_x = 0, %%战斗备用变量x  外功
%% 					  battle_physics_y = 0,  %%战斗备用变量y
%% 					  battle_range_y = 0,  %%战斗备用变量y
%% 					  battle_magic_y = 0,  %%战斗备用变量y
%% 					  battle_vindictive_y = 0,  %%战斗备用变量y
					  
					  skill_prepare = {},			%{SkillID,CheckPrepareTime}
					  
					  count_type = [],
					  
					  damage_to_shangwu = 0,
					  damage_to_xiaoyao = 0,
					  damage_to_liuxing = 0,
					  damage_from_shangwu = 0,
					  damage_from_xiaoyao = 0,
					  damage_from_liuxing = 0,
					  element_standup_date = 0,
					  
					  pid = undefined,
					  pid_send = undefined,
					  id = 0,
					  pet_id = 0,
					  type = [],
					  pk_mode = 0,
					  element_state = 0,
					  
					  level = 0,
					  pk_value = 0,
					  team_id = 0,
					  guild_id = 0,
					  camp = 0,
					  
					  acthurt_min = 0,
					  acthurt_max = 0,
					  targethurt_min = 0,
					  targethurt_max = 0,
					  
					  actor_hp = 0,
					  actor_mp = 0,
					  target_hp = 0,
					  target_mp = 0,
					  
					  new_buff_list = [],
					  remove_buff_list = [],
					  
					  name = [],						%名字					  
					  pet_owner_name = [],		%宠物才有的主人名字
					  % 帮会战，结构[{id},{id}]
					  guild_enemy = [],
					  
					  invincible_date = 0	%%  无敌时间，0表示无无敌，单位秒
					 
					 }).

%% 战斗所需
%% -record(battle_object_state,{
%% 						id = 0,
%% 						name = [],
%% 						type = 0,	%%1人，3怪 
%% 
%% 						hp = 0,
%% 						effect_hp = 0, %影响的hp
%% 
%% 						mp = 0,
%% 						effect_mp = 0,	%影响的mp
%% 						
%% 						acthurt_max = 0,
%% 						acthurt_min = 0,
%% 						targethurt_max = 0,
%% 						targethurt_min = 0,
						
						%以下pk用		可能需要用上？
%% 						camp = 0,
%% 						club_id = 0,
%% 						team_id = 0,
%% 						pk_value = 0,
%% 						level = 0,
%% 						pk_mode = 0,
						%以上pk用
						
%% 						attack_physics = 0,                     %% 普通攻击力	
%%       					attack_range = 0,                       %% 远程伤害	
%%       					attack_magic = 0,                       %% 魔法伤害	
%%       					attack_vindictive = 0,                  %% 斗气伤害	
%%       					defanse_physics = 0,                    %% 普通防御力	
%%       					defanse_range = 0,                      %% 远程防御	
%%       					defanse_magic = 0,                      %% 魔法防御	
%%       					defanse_vindictive = 0,                 %% 斗气防御	
%%       					hit = 0,                                %% 命中	
%%       					dodge = 0,                              %% 闪避	
%%       					block = 0,                              %% 格挡	
%% 						critical = 0,							%% 暴击
%% 						tough = 0,								%% 坚韧
%%       					reduce_range = 0,                       %% 远程吸收	
%%       					reduce_magic = 0,                       %% 魔法吸收	
%%       					reduce_vindictive = 0,                  %% 斗气吸收
						
%% 						buff_list = [],		%%buff[{buffid,上次起效时间,结束时间}]
%% 						new_buff_list = [],	%%当次新加的buff
%% 						
%% 						abnormal_rate = 0,	%%异常机率
%% 						anti_abnormal_rate = 0,	%%抗异常机率
						
%% 						pid = undefined, %%pid
%% 					 	pid_team = undefined, %%队伍pid
%% 						pid_send = undefined,
%% 						pid_map = undefined,
					 
%% 					 	battle_physics_x = 0, %%战斗备用变量x
%% 						battle_range_x = 0, %%战斗备用变量x
%% 						battle_magic_x = 0, %%战斗备用变量x
%% 						battle_vindictive_x = 0, %%战斗备用变量x
%% 						battle_physics_y = 0,  %%战斗备用变量y
%% 						battle_range_y = 0,  %%战斗备用变量y
%% 						battle_magic_y = 0,  %%战斗备用变量y
%% 						battle_vindictive_y = 0,  %%战斗备用变量y
%% 						
%% 						equip_weapon_type = 0,		%装备武器类型
						
%% 						skill_prepare = {},			%{SkillID,CheckPrepareTime}
%% 						skill_time = [],		%技能使用时间 , [{skillid,time}]
%% 						count_type = [],
%% 						actor_hp = 0,
%% 						actor_mp = 0,
%% 						target_hp = 0,
%% 						target_mp = 0,
							
						%其他战斗属性
%% 						damage = 0,
%% 						vindictive_hurt = 0,
%% 						magic_hurt = 0,
%% 						range_hurt = 0,
%% 						damage_to_shangwu = 0,
%% 						damage_to_xiaoyao = 0,
%% 						damage_to_liuxing = 0,
%% 						damage_from_shangwu = 0,
%% 						damage_from_xiaoyao = 0,
%% 						damage_from_liuxing = 0,
%% 						attack_suppression = 0,
%% 						defense_suppression = 0,
						
						%% 状态
%% 						element_now_state = 1,	%?ELEMENT_STATE_COMMON
%% 						element_standup_date = 0	%% 玩家起身时间
%% 					 }).

%% 摆摊求购物品数据
-record(r_stall_buys, {id=0, role_id=0, num=0, price=0, buy_detail=undefned}).
-record(r_stall_sells, {id=0, role_id=0, price=0, place=0,sells_detail=undefined}).

%% 排行榜
-record(ets_rank, {
    type_id,            %% 排行类型ID
    rank_list           %% 排行信息列表
    }).

%% 掉落物品
-record(r_drop_item, {
					  	id = 0,					%%id
						map_id = 0,				%%场景id
						x = 0,					%%掉落x坐标
						y = 0,					%%掉落y坐标
						owner_id = 0,			%%所有者id
						amount = 1,				%%物品数量 给掉落货币时候使用
						item_template_id = 0,	%%物品模板id
						drop_time = 0,			%%掉落时间
						state = undefined,		%%状态 lock,unlock	
						isbind = 0,				%%是否拾取后绑定
						ownteampid = undefined, %%所属队伍进程
					 	work_lock = false		%%是否在拾取的处理过程中，如在，别人拾取无效，不会在地图上出现
					  }).
					  
%% 箱子数据
-record(ets_box_data,{
                     id = {0,0},
                     data = [],
                     rate = 0
                     }).					  
					  

%% 人物称号其他数据
-record(other_title,{
					   attack_physics = 0,      %% 普通攻击
					   defence_physics =0,      %% 普通防御
					   hurt_physics = 0,        %% 普通伤害
					   attack_vindictive = 0,   %% 斗气攻击
					   attack_magic = 0,        %% 魔法攻击
					   attack_range = 0,		%% 远程攻击
					   hit_target = 0,          %% 命中	
				       duck = 0,                %% 闪避	
				       deligency = 0,           %% 坚韧
					   power_hit = 0,           %% 致命一击
					   max_physical = 0        %% 体力上限
					   }).

%% 采集信息
-record(r_collect_info, {
%% 						 unique_key = {0, 0},	%% 唯一主键  {地图Id, 采集id}		
						 id = 0,			%% id
						 template_id = 0,	%% 模板Id
						 can_reborn = 1,
						 destruct_time = 0,
%% 						 template = undefined,	%% 模板
						 x = 0,				%% X位置
						 y = 0,				%% Y位置
						 state = 0,			%% 1正常，2死亡
						 map_id = 0,		%% 地图id
%% 						 map_pid = undefined,	%% 地图进程			
	 					 dead_time = 0		%%  消亡时间	
						 }).

%%人物Buff信息
-record(r_other_buff, {
					   effect_list = [],		% 生效的效果列表
					   is_new = 0,              % 是否新增buff
					   is_alter = 0,			% 是否改变
					   need_notice = 1			% 不再需要广播，在第一次is_exist=:=0后该值改0，在 is_exist =:=1时调整为1
    				  }).

%% 其他帮会信息
-record(other_guilds,{
					  online_honor = 0,			%% 在线荣誉成员个数
					  online_common = 0,		%% 在线普通成员个数
					  online_associate = 0,     %% 在线备用成员个数
%% 					  masterName = [],   %% 帮主名字 成员表的副本
%% 					  masterType = 0,			%% 帮主VIP 成员表的副本
%% 					  viceMasterName = [],   %% 副帮主名字 成员表的副本
%% 					  viceMasterType = 0,		%% 副帮主VIP 成员表的副本
%% 					  guilds_corps = [],		%% 军团信息
					  members = [],				%% 成员
%% 					  requests = [],			%% 请求加入
					  declear_war_guild = [],	%% 被帮会宣战记录
					  enemy_guild = [],			%% 敌对帮会记录
					  summon_collent_time = 0,	%% 帮会召唤采集物时间
					  map_pid = undefined,		%% 地图Pid
					  map_only_id = 0			%% 地图唯一id	
					  }).

-record(r_users_guilds,{
						user_id = 0,
						guild_id = 0
						}).

%% 帮会成员的其他信息
-record(other_users_guilds,{
							nick_name = undefined, %%nick_name
							vipid = 0,		%% vip 等级
							career = 0,		%%职业
							sex = 0,        %% 性别
							level = 0,		%%等级
							fight = 0,		%% 战斗力
							last_online_time = 0, 	%% 最后一次下线时间
							online = 0,		%%是否在线
							prayer_num = 0,					%% 祈福次数
							pid = undefined,		%%
							pid_send = undefined,	%%
							warehouse_pageindex = 0, 	%>0是打开了仓库后的页码，否则未打开
							feats_list = [],
							use_feats_list = []  %% 
							}).

%% 申请加入帮会的玩家的其他信息
-record(other_users_guilds_request,{
									nick_name = undefined, 			%%姓名
									career = 0,						%%职业
									level = 0,						%%等级
									vipid = 0,						%% vip等级
									sex = 0,						%% 性别
									online = 0,						%% 是否在线									
									invert_user_name = undefined	%%邀请者姓名
									}).
%% 寄售记录的其他信息
-record(other_sale, {
					  is_expire = 0, %% 是否过期
					  keep_time = 0, %% 暂存剩余时间（秒）
					  item			 %% 寄售的物品信息
					  }).	

-record(r_team_enroll, {
                        id = 0,				      %% 队伍id
                        team_pid = undefined,	  %% 队伍进程pid
                        leaderid = 0,			  %% 队长id
                        leaderpid= undefined,     %% 队长pid
                        duplicate_id = 0,         %% 副本id
                        
				        team_enroll_member = []   %% 队员列表
				 
                     }).
                     					
-record(r_single_enroll, {
                         id = 0,         		  %% id
					     pid = undefined,     	  %% pid
					     team_pid = underfined,   %% team pid
					     nick_name = "",          %% 用户昵称
					     current_map_id = 0,      %% 当前地图
					     								      
					     career = 0,              %% 职业
					     level = 0,               %% 等级
					     enroll_state = 0,        %% 确定报名状况 (0未确定 1确定)
					     
					     userinfo,                %% 人物信息
					     duplicate_id = 0         %% 副本id
                       }).					
							
%% 掉落物record
-record(r_drop_item_template, {
					  index = 0,					%%索引
					  item_template_id = 0,		%%物品模板
					  item_drop_range_low = 0,		%%落点下限
					  item_drop_range_high = 0,	%%落点上限
					  drop_number = 0,				%%掉落数量
					  is_bind = 0					%%是否绑定
					}).

%% 技能使用记录
-record(r_use_skill, {
					  skill_id = 0,				%% 技能id
					  skill_percent = 0,		%% 技能机率
					  skill_lv = 0,				%% 技能等级
					  skill_group = 0,			%% 技能组
					  skill_lastusetime = 0,	%% 技能上次使用时间
					  skill_colddown = 0		%% 技能冷却时间
					  }).
%% 筋脉学习记录
-record(r_user_veins, {
						acupoint_type = 0,		%% 穴位类型
						award_attribute = 0,	%% 奖励属性
						acupoint_level = 0,		%% 穴位等级
						award_acupoint_count = 0,%% 穴位奖励总点数
						gengu_level = 0,		%% 根骨等级
						award_gengu_count = 0,	%% 根骨奖励总点数
						luck = 0				%% 根骨幸运值
						}).

-record(r_resource_war,{
						map_only_id = 0,		%% 地图唯一Id
						map_id = 0,				%% 地图Id
						map_pid = undefined, 	%% 地图pid
						player_count = 0,		%% 当前人数
						camp1 = {0,0},			%% 阵营1 人数,战斗力
						camp2 = {0,0},			%% 阵营2 人数
						camp3 = {0,0},			%% 阵营3 人数
						camp1Point = {0,0},		%% 阵营1 采集积分，击杀积分
						camp2Point = {0,0},		%% 阵营2 采集积分，击杀积分
						camp3Point = {0,0},		%% 阵营3 采集积分，击杀积分
						top_list = [],			%% 排行榜前十玩家列表
						player_list = [],		%% 玩家列表
						off_line_list = [],		%% 离线玩家列表
						war_state = 1			%% 战场状态，1开启，0结束
						}).

-record(r_resource_war_user,{
						user_id = 0,
						camp = 0,				%% 阵营
						nickname = "",			%% 昵称
						fight = 0,				%% 战斗力
						user_pid = undefine,
						send_pid = undefine,
						kill_point = 0,			%% 击杀积分
						collect_point = 0,		%% 采集积分
						kill_num = 0,			%% 击杀次数
						killing_num = 0,		%% 连杀数
						state = 1,%% 0离线，1正常，2死亡, 11离开
						dead_num = 0,			%% 死亡次数
						off_line_time = 0		%% 离线时间/离开时间
						}).							

-record(r_pvp_first,{
						map_only_id = 0,		%% 地图唯一Id
						map_id = 0,				%% 地图Id
						map_pid = undefined, 	%% 地图pid
						the_first = 0,			%% 天下第一玩家
						the_first_pid = undefined,
						the_first_nickname ="", %% 天下第一玩家昵称
						player_count = 0,		%% 当前人数
						player_list = [],		%% 玩家列表
						%off_line_list = [],		%% 离线玩家列表
						war_state = 1,			%% 战场状态，1开启，0结束
						start_time = 0,			%%开始时间
						continue_time = 0		%%持续时间
						}).

-record(r_pvp_first_user,{
						user_id = 0,
						nickname = "",			%% 昵称
						fight = 0,				%% 战斗力
						user_pid = undefine,
						send_pid = undefine,
						state = 1,	%% 0离线，1正常，2死亡, 11离开
						off_line_time = 0		%% 离线时间/离开时间
						}).		

-record(r_free_war_map,{
						map_only_id = 0,		%% 地图唯一Id
						map_id = 0,				%% 地图Id
						map_pid = undefined, 	%% 地图pid
						player_count = 0,		%% 当前人数
						min_level = 0,			%% 最小等级
						max_level = 0,			%%  最大等级
						god_count = 0,			%% 神人数
						devil_count = 0,		%% 魔人数
						god_point = 0,			%% 神点数
						devil_point = 0			%%  魔点数
						}).

-record(r_free_war_user,{
						 user_id = 0,			%% 玩家id
						 nick_name = "",		%% 昵称
						 level = 0,				%% 等级
						 club_name = "",		%% 公会名称
						 career = 0,			%% 职业
						 war_map_id = 0,		%% 战场地图
						 is_online = 0,			%% 是否在战场    0不在，1在
						 war_state = 0,			%% 战场状态
						 kill_count = 0,		%% 杀死玩家数
						 leave_time = 0, 		%% 离开时间
						 kill_list = [],		%% 杀死列表
						 by_kill_list = [],		%% 被杀死列表
						 player_pid = undefined, %% 玩家进程
						 award_state = 0,		%% 奖励状态，0已领取，1 胜利未领取，2失败未领取,3和未领取
						 repute = 0				%% 排名 
						 }).

%% 世界boss活动
-record(r_active_monster, {
							map_only_id = 0,		%% 地图唯一Id
							map_id = 0,				%% 地图Id
							map_pid = undefined, 	%% 地图pid
							monster_state = 0,   	%% 怪物状态 1为活 0为死
							monster_lost_hp = 0,	%% 怪物损失的生命值
							top_list = [],			%% 伤害输出前10名玩家列表
						  	player_list = [],			%% 所有玩家列表
							war_state = 1,			%% 1为开始, 0为结束		
							start_time = 0,			%% 开始时间
							continue_time = 0		%%  持续时间
							}).

-record(r_active_monster_user, {
								user_id = 0,		%% 玩家id
								nick_name = "",		%% 昵称
								state = 0,			%% 1表示在线， 0表示离线
								offline_time = 0, 	%% 离开时间
								user_pid = undefined,
								send_pid = undefined, 
								damage = 0			%% 对boss造成的伤害
								}).	

%% 公会乱斗活动
-record(r_guild_fight, {
							map_only_id = 0,		%% 地图唯一Id
							map_id = 0,				%% 地图Id
							map_pid = undefined, 	%% 地图pid
							player_list = [],			%% 玩家列表
						  	guild_list = [],			%% 公会列表
							war_state = 1,			%% 1为开始, 0为结束
							buff_user_id = 0,		%% 拿着旗帜的玩家ID
							buff_guild_id = 0,		%% 拿着旗帜的公会ID
							buff_guild_name = "",  	%% 拿着旗帜的公会名		
							start_time = 0,			%% 开始时间
							continue_time = 0		%%  持续时间
							}).	

%% 公会乱斗公会
-record(r_guild_fight_guild, {
								guild_id = 0,		%% 帮会id
								nick_name = "",		%% 帮会昵称
								old_time = 0,		%% 获取旗帜的时刻
								total_time = 0,		%% 旗帜拿在身上的总时间
								state = 0,			%% 公会状态, 0表示未获得旗帜,1表示获得旗帜
								kill_num = 0			%% 公会成员击杀总和
								}).
%% 公会乱斗参与玩家
-record(r_guild_fight_user, {
								user_id = 0,		%% 玩家id
								guild_id = 0,		%% 帮会id
								nick_name = "",		%% 昵称
								state = 0,			%% 1表示在线， 0表示离线
								offline_time = 0, 	%% 离开时间
								item_recv_list = [], %% 玩家已经领取的礼包列表
								user_pid = undefined,
								send_pid = undefined
								}).

%% 王城战报名公会
-record(r_king_fight, {
						guild_id = 0, 		%% 公会id
						guild_name = "",	%%公会名字
						guild_money = 0,		%% 公会报名财富
						state = 0					%%报名状态（1胜利）
						}).	

%% 王城战报名
-record(r_king_fight_signup, {
				state = 0,					%% 报名状态，1表示能进行报名
				guild_nick_name = "", 		%% 竞价最高帮会昵称
				guild_money = 0,				%% 竞价最高帮会财富
				guild_id = 0,				%% 竞价最高帮会Id
				king_guild_id = 0,			%% 王城占领帮会Id
				king_stand_days = 0,		%% 王城占领天数
				king_guild_name = "",		%% 王城占领帮会名字
				guild_list = []				%% 竞价帮会列表
				}).

%% 王城战
-record(r_king_war,{
						attack_guild_id = 0, 	%% 攻方公会Id
						defence_guild_id = 0,	%% 守方公会Id
						map_only_id = 0,		%% 地图唯一Id
						map_id = 0,				%% 地图Id
						map_pid = undefined, 	%% 地图pid
						lost_hp = 0,			%% 圣物损失HP			
						top_list = [],			%% 排行榜前三玩家列表
						player_list = [],		%% 玩家列表
						war_state = 0,			%% 战场状态，1开启，0结束
						war_result = 1, 		%% 1表示守方胜， 0表示攻方胜 
						start_time = 0,			%% 开始时间
						continue_time = 0		%% 持续时间
						}).

%% 王城战玩家
-record(r_king_war_user,{
						user_id = 0,
						camp = 0,				%% 阵营
						nickname = "",			%% 昵称
						user_pid = undefine,
						send_pid = undefine,
						killing_num = 0,		%%连杀
						point = 0,				%% 积分
						state = 1,				%% 0离线，1正常
						off_line_time = 0		%% 离线时间/离开时间
						}).	


%%优惠商品记录
-record(other_discount,{
							dirty_state = 0,	%%  修改状态，0没改变，1修改，2新增
							cheap_type = 0,		%%优惠抢购类型1,限制数量并且限制时间;2,限制数量不限制时间;3,限制时间不限制数量;0,未开启
							left_time = 0,		%%剩余时间
							left_count = 0		%%剩余数量
							}).


%%神魔斗法奖励
-record(free_war_award,{
									 level_index = {},			%%等级和排名标识 {level, index}
									 award = []				    %%奖励 [{template_id, amount, is_bind}]
									}).
%% pvp1活动人物信息
-record(pvp1_user_info,{
		user_id = 0,		%报名用户唯一编号
		user_pid,			%用户pid		
		career = 0,			%职业
		level = 0,			%等级
		fight = 0,			%战斗力
		join_time = 0}).	%报名时间

%% pvp副本人物数据结构
-record(pvp_dup_user_info, {
				user_id = 0,
				name = " ",
				career = 0,
				level = 0,
				camp_type = 0,		%% 阵营0红方，1蓝方
				pid_user,
				pid_send,	
				status = 0,		%% 0活着，1死亡，2离线
				award_list = []
				}).	

%% pvp功勋奖励记录信息
-record(user_exploit_info,{
				user_id = 0,
				exploit = 0,			%%人物功勋值
				pvp1_day_award = 0,		%%pvp1当天获得奖励数
				achieve_time = 0}).		%%最后一次获得奖励时间
%% 公会祈福随机列表
-record(ets_guild_prayer_list,{
			id = 0,						%%随机列表目前只有一个所以id = 1
			max_rate = 0,				%%随机最大值
			list = []					%%随机列表内容
		}).

%%------------------后台日志 record---------------------
%%任务日志
-record(task_log,{
				  task_id = 0,				%%任务编号
				  task_type = 0,			%%任务类型
				  task_state = 0,			%%任务状态
				  count,					%%任务数量
				  log_flag = {}				%%记录标识
				  }).	

%%宝石合成
-record(compose_log,{
				  compose_level = 0,		%%合成等级
				  count = 0,				%%合成数量
				  success_count = 0,		%%成功次数
				  stone_count = 0,			%%消耗低级宝石总数
				  compose_count = 0			%%幸运符消耗总数
				  }).	

%%武器强化
-record(strength_log,{
				  user_id = 0,				%%用户id
				  level = 0,				%%用户等级
				  luck_num = 0,				%%幸运符数量
				  is_protect = 0,			%%是否使用保护符
				  is_success = 0,			%%是否成功
				  strength_level = 0		%%强化等级
				  }).	

%%武器镶嵌
-record(enchase_log,{
				  user_id = 0,				%%用户id
				  level = 0,				%%用户等级
				  type = 0,					%%1镶嵌 2摘取
				  hole_num = 0,				%%镶嵌孔数
				  category_id = 0,			%%武器种类
				  stone_id = 0				%%宝石id
				  }).	

%%武器洗练
-record(rebuild_log,{
				  quality = 0,				%%物品品质（绿，蓝，紫）
				  attribute_num = 0,		%%洗练属性条数
				  count = 0,				%%出现次数
				  one_star = 0,				%%1星次数
				  two_star = 0,				%%2星次数
				  three_star = 0,			%%3星次数
				  four_star = 0,			%%4星次数
				  five_star = 0,			%%5星次数
				  log_flag = {}				%%记录标识
				  }).	

%%玩家PK记录
-record(pk_log,{
				  killer_id = 0,				%%杀手ID
				  killer_level = 0,				%%杀手等级
				  killer_pk = 0,				%%杀手PK值
				  dead_id = 0,					%%死者ID
				  dead_level = 0,				%%死者等级
				  dead_is_red = 0,				%%死者红名状态
				  utime = 0,					%%发生时间
				  drops = []					%%掉落物品
				  }).	

%%玩家元宝操作记录
-record(consume_yuanbao_log,{
				  user_id = 0,						%%用户id
				  yuanbao = 0,						%%元宝
				  bind_yuanbao = 0,					%%绑定元宝
				  is_consume = 0,					%%是否消费
				  type = 0,							%%类型
				  utime = 0,						%%操作时间
				  template_id = 0,					%%模板id
				  amount = 0,						%%数量
				  level = 0							%%等级
				  }).	
%%玩家铜币操作记录
-record(consume_copper_log,{
					user_id = 0,
					copper = 0,
					bind_copper = 0,
					type = 0,
					utime = 0,
					template_id = 0,
					amount = 0,
					level = 0
					}).
%%玩家交易记录
-record(trade_log,{
				  first_trade_id = 0,						%%交易者1ID
				  first_trade_copper = 0,					%%交易1铜币
				  first_trade_items = [],					%%交易1物品
				  second_trade_id = 0,						%%交易者2ID
				  second_trade_copper = 0,					%%交易2铜币
				  second_trade_items = 0,					%%交易2物品
				  trade_date = 0							%%交易时间
				  }).	

%%道具产出和消耗
-record(item_log,{
				  user_id = 0,							%%玩家id
				  item_id = 0,							%%物品唯一id
				  template_id = 0,						%%物品模版id
				  type = 0,								%%操作类型
				  amount = 0,							%%剩余数量
				  usenum = 0,							%%使用数量
				  time = 0,								%%日志产生时间
				  level = 0								%%玩家等级				  
				  }).

%%魔法箱子记录
-record(magic_log,{
				  user_id = 0,							%%	用户编号
				  count = 0,							%%	开箱子次数
				  type = 0,								%%	类型 1 等级 2中级 3高级
				  amount = 0, 							%%	数量
				  utime = 0,							%%	开箱子时间
				  template_id = 0,						%%	物品编号	
				  log_flag = []							%%记录标识
				  }).


%% -record(user_onmap_update, {
%% 								 key = undefined,
%% 								 value = 0
%% 								 }).

%% -record(user_onself,{
%% 					 user_id = 0,
%% 					 infant_state = 0, 			% 防沉迷，0未登记，1成年，2登记但未成年， 3满三个小时， 4满5个小时
%% 					 socket = undefined,			% 当前用户的socket
%% 					 pid = undefined,          	% 用户进程Pid
%% 					 pid_send = undefined,		% 消息发送进程Pid
%% 					 node = undefined,			% 进程所在节点
%% 					 pid_map = undefined, 	  	% 当前场景Pid
%% 					 pid_item = undefined,		% 物品pid
%% 					 pid_team = undefined,		% 队伍pid
%% 					 pid_dungeon = undefined,	% 副本pid(玩家副本进程!)
%% 					 pid_task = undefined,		% 任务pid
%% 					 pid_duplicate = undefiend,	% 副本pid(玩家副本次数统计!)
%% 					 pid_guild_map = undefined,      % 帮派地图Pid
%% 					 guild_map_id = 0,				% 帮派地图Id
%% 					 map_template_id = 0,		% 地图模板id
%% 					 duplicate_id = 0,           % 副本id
%% 					 pid_locked_monster = [],			%锁定当前用户的对象的pid
%% 					 skill_bar = [],					% 快捷栏列表 [{index,id,groupid,otherdata}]
%% 					 relive_time = 0,                 %原地复活时间
%% 					 
%% 					 pet_id = 0,						 %宠物Id
%% 					 pet_template_id = 0,			 %出战宠物模板Id
%% 					 pet_nick = undefined,			 %出战宠物昵称
%% 					 
%% 					 last_pk_actor_time = 0,				%最后主动pk时间
%% 					 last_pk_target_time = 0,		%最后被动pk时间
%% 					 last_pk_auto_update_time = 0,	%pk值最后自动更新时间
%% 					 last_fight_actor_time = 0,	%% 上次攻击时间
%% 					last_fight_target_time = 0,	%% 上次被击时间
%% 					 
%% 					 sit_date = 0,					%开始打坐时间
%% 					 total_title = undefined,		%全部称号
%% 					 
%% 					 exp_rate = 1,					%人物多倍经验值
%% 					 
%% 					 %% 直接交易
%% 					trade_status = {0, 0}, % {交易状态, 对方id}  {0, 0}没有交易  {1, id}启动交易 {2, id}锁定交易 {3, id}确定交易
%% 					trade_list = [],      % 交易物品、货币列表 [{{id, 物品or铜币or元宝, 是否给自己}, 数量}...]
%% 					 
%% 					 %%要通知坐标点的怪物pid列表
%% 				    pid_locked_target_monster = [],
%% 					login_time = 0,
%% 					 
%% 					 allot_mode = undefined,
%% 					map_last_time = 0,	%% 地图最后时间 
%% 					 
%% 					 vip_exp_rate = 0,			%% vip经验倍数
%% 					vip_strength_rate = 0,		%% vip强化倍数
%% 					vip_hole_rate = 0,			%% vip打洞倍数
%% 					vip_lifeexp_rate = 0,		%% vip历练倍数
%% 					vip_refresh_date = 0,		%% vip状态上次有效处理时间
%% 					 
%% 					 sum_packet = 0, 	%% 累积包
%% 					 sum_packet_error = 0	%% 包错误次数
%% 					 }).
%% 
%% -record(user_onmap,{
%% 					user_id = 0,
%% 					%%=================ets_users 相关
%% 					pid = undefined,
%% 					pid_send = undefined,
%% 					
%% 					current_hp = 0,
%% 					current_mp = 0,
%% 					level = 0,
%% 
%% 					club_id = 0,
%% 					team_id = 0,
%% 					camp = 0,
%% 					
%% 					pos_x = 0,
%% 					pos_y = 0,
%% 					
%% 					pk_mode = 0,
%% 					pk_value = 0,
%% 					war_state = 0,
%% 					%%============================
%% 					guild_level = 0,				% 帮派等级
%% 					total_feats = 0,				% 帮派个人功勋
%% 					walk_path_bin = undefined,	% 走路路径
%% 					skill_list = [],				% 当前skill列表
%% 					buff_list = [],					%%存在的buff
%% 					remove_buff_list = [],			%%删除了的buff
%% 					buff_temp_info = [],			%%添加buff后人物的临时改变属性
%% 					equip_weapon_type = 0,			%装备的武器的类型
%% 					sit_state = 0,					%0 正常 1单修 2普双休 3特殊双休
%% 					double_sit_id = 0,				%双修玩家ID
%% 					horse_speed = 0,				%骑上宠速度
%% 					speed = 0,						% 速度
%% 					
%% 					blood_buff = [],				%人物血包buff
%% 					magic_buff = [],				%人物魔法buff
%% 					exp_buff = [],					%人物多倍经验列表
%% 					
%% 					club_name = "",
%% 					club_job = 0,
%% 					
%% 					escort_state = 0,	%%镖车品质
%% 					
%% 					player_now_state = 1,		%% 玩家当前状态 ELEMENT_STATE_COMMON
%% 					player_standup_date = 0,	%% 玩家起身时间
%% 					
%% 					%%人物属性移动到这里，每次登陆时计算处理，不再保存在数据库
%% 					total_life_experiences = 0,
%% 					max_physical = 0,
%% 					hp_revert = 0,
%% 					mp_revert = 0,
%% 					
%% 					total_hp = 0,
%% 					total_mp = 0,
%% 					attack = 0,
%% 					defense = 0,
%% 					magic_hurt = 0,
%% 					mump_hurt = 0,
%% 					far_hurt = 0,
%% 					hit_target = 0,
%% 					duck = 0,
%% 					keep_off = 0,
%% 					power_hit = 0,
%% 					deligency = 0,
%% 					magic_defense = 0,
%% 					mump_defense = 0,
%% 					far_defense = 0,
%% 					mump_avoid_in_hurt = 0,
%% 					far_avoid_in_hurt = 0,
%% 					magic_avoid_in_hurt = 0,
%% 					abnormal_rate = 0,
%% 					anti_abnormal_rate = 0,
%% 					attack_suppression = 0,
%% 					defense_suppression = 0,
%% 					
%% 					move_speed = 0,					%移动速度
%% 					attack_speed = 0,				%攻击速度
%% 					
%% 				   %%临时属性，由于buff等影响
%% 					tmp_totalhp = 0,				%临时最大血量
%% 					tmp_totalmp = 0,				%临时最大魔法
%% 					tmp_attack = 0,
%% 					tmp_defense = 0,
%% 					tmp_magic_hurt = 0,
%% 					tmp_far_hurt = 0,
%% 					tmp_mump_hurt = 0,
%% 					tmp_hit_target = 0,
%% 					tmp_duck = 0,
%% 					tmp_keep_off = 0,
%% 					tmp_power_hit = 0,
%% 					tmp_deligency = 0,
%% 					tmp_magic_defense = 0,
%% 					tmp_mump_defense = 0,
%% 				    tmp_far_defense = 0,
%% 					tmp_magic_avoid_in_hurt = 0,
%% 					tmp_mump_avoid_in_hurt = 0,
%% 					tmp_far_avoid_in_hurt = 0,
%% 					
%% 					tmp_move_speed = 0,
%% 					tmp_attack_speed = 0,
%% 
%% 					%其他战斗属性
%% 					damage = 0,
%% 					mump_damage = 0,
%% 					magic_damage = 0,
%% 					far_damage = 0,
%% 					damage_to_shangwu = 0,
%% 					damage_to_xiaoyao = 0,
%% 					damage_to_liuxing = 0,
%% 					damage_from_shangwu = 0,
%% 					damage_from_xiaoyao = 0,
%% 					damage_from_liuxing = 0,
%% 					
%% 					%战斗
%% 					battle_info = undefined
%% 					}).


%%个人购买优惠商品信息
-record(discount_items,{
							item_id = 0,		%%优惠商品ID
							item_count = 0,		%%购买优惠商品数量
							finish_time = 0		%%优惠活动结束时间
						}).


-record(mounts_other,{
					  	speed = 0,                              %% 速度	
						diamond = 0,                            %% 钻级	
     					star = 0,                               %% 星级
					   	fight = 0,                              %% 战斗力	
					    up_grow_up = 0,                         %% 成长上限	
					    up_quality = 0,                         %% 资质上限	
						total_hp = 0,                           %% 生命	
						total_mp = 0,                           %% 法力	
					    attack = 0,                             %% 攻击	
					    defence = 0,                            %% 防御	
					    magic_attack = 0,                       %% 魔法攻击	
					    far_attack = 0,                         %% 远程攻击	
					    mump_attack = 0,                        %% 斗气攻击	
					    magic_defense = 0,                      %% 魔法防御	
					    far_defense = 0,                        %% 远程防御	
					    mump_defense = 0,                       %% 斗气防御
					    up_quality2 = 0,                        %% 资质上限2	
					    up_grow_up2 = 0,                        %% 成长上限2
					    total_hp2 = 0,                          %% 生命2	
					    total_mp2 = 0,                          %% 法力2	
					    attack2 = 0,                            %% 攻击2	
					    defence2 = 0,                           %% 防御2	
					    magic_attack2 = 0,                      %% 魔法攻击2	
					    far_attack2 = 0,                        %% 远程攻击2	
					    mump_attack2 = 0,                       %% 斗气攻击2	
					    magic_defense2 = 0,                     %% 魔法防御2	
					    far_defense2 = 0,                       %% 远程防御2	
					    mump_defense2 = 0,                      %% 斗气防御2
						total_hp3 = 0,							%% 当前等阶洗练属性
						total_mp3 = 0,                          %% 当前等阶洗练属性
					    attack3 = 0,                            %% 当前等阶洗练属性	
					    defence3 = 0,                           %% 当前等阶洗练属性
					    property_attack3 = 0,                   %% 当前等阶洗练属性	
					    magic_defence3 = 0,                     %% 当前等阶洗练属性	
					    far_defence3 = 0,                       %% 当前等阶洗练属性	
					    mump_defence3 = 0,                      %% 当前等阶洗练属性
						skill_cell_num = 4,                     %% 技能格数
						skill_list = []  %% 坐骑技能列表
					}).
	
-record(pet_battle_log_list, {
	user_id = 0 ,  	 %% 用户Id	
	top_award = 0,	%%排行奖励
	total_times = 10 , %%总挑战次数
	log_list = []
	}).
	
%% 宠物斗坛日志	
-record(pet_battle_log, {	
      pet_id= 0,                                  %% 宠物Id	
	  pet_name="",                             %% 昵称	
	  nick = "",										%%玩家名字
	  challenge_pet_id =0,                    %% 被挑战宠物id	
	  challenge_pet_name ="",              %% 被挑战宠物昵称	
	  challenge_nick ="",						%% 挑战玩家名字
	  top=0,											%%排行榜
	  state = 0,                             %% 2挑战 1反击 0战胜 3终结 4挑战失败被终结	 
	  winning =0,                             %% 连胜
	  time =0									%%时间
    }).	


-record(pet_other,{
						item_pid = undefine,					%% 物品pid
						diamond = 0,                            %% 钻级	
     					star = 0,                               %% 星级
					    up_grow_up = 0,                         %% 成长上限	
					    up_quality = 0,                         %% 资质上限	
					    attack = 0,                             %% 攻击	
						power_hit = 0,							%% 暴击
						hit = 0,								%% 命中
					    magic_attack = 0,                       %% 魔法攻击	
					    far_attack = 0,                         %% 远程攻击	
					    mump_attack = 0,                        %% 斗气攻击	
					    up_quality2 = 0,                        %% 资质上限2	
					    up_grow_up2 = 0,                        %% 成长上限2
					    attack2 = 0,                            %% 攻击2	
					    magic_attack2 = 0,                      %% 魔法攻击2	
					    far_attack2 = 0,                        %% 远程攻击2	
					    mump_attack2 = 0,                       %% 斗气攻击2
						power_hit2 = 0,							%% 暴击
						hit2 = 0,								%% 命中	
						skill_cell_num = 4,                     %% 技能格数
						
						skill_list = []  						%% 技能列表
					}).
	
-record(sys_msg_other,{
					   last_send_time = 0,					  	%% 最后发送时间
					   a = 1
					   }).

%% 目录模板其它数据
-record(other_target_template,{
								target_objects,		%%目标对象	[{Id,Amount},[Id,Amount]]	
								target_amounts,		%%对象需要数量	[Amount1, Amount2]
								target_ids			%%对象Id [Id1,Id2]
								}).


%% 友好度其他数据
-record(other_amity,{
					   attack_physics = 0,      %% 普通攻击
					   defence_physics =0,      %% 普通防御
					   hurt_physics = 0,        %% 普通伤害
					   attack_vindictive = 0,   %% 斗气攻击
					   attack_magic = 0,        %% 魔法攻击
					   attack_range = 0,		%% 远程攻击
					   hit_target = 0,          %% 命中	
				       duck = 0,                %% 闪避	
				       deligency = 0,           %% 坚韧
					   power_hit = 0,           %% 致命一击
					   max_physical = 0        %% 体力上限
					   }).


-record(other_activity_open_server_template,{
										start_time,		%% 开始时间
										end_time        %%　结束时间
										}).

-record(other_open_server,{is_new = 1,end_time = 0}).


%% 黄钻其他数据
-record(other_yellow_template,{
					   attack_physics = 0,      %% 普通攻击
					   defence_physics =0,      %% 普通防御
					   hp = 0        			%% HP
					   }).

%% 七天活动用户数据
-record(activity_seven_data,{
							 user_id = 0,    %%用户编号
							 nick_name = "", %%用户名称
							 num = 0,		 %%数量
							 is_get = 0
							 }).

-endif. % RECORD




