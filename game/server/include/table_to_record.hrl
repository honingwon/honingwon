%%%------------------------------------------------	
%%% File    : table_to_record.erl	
%%% Created : 2011-06-15 22:02:19	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------		
-ifndef(TABLE_TO_RECORD).		
-define(TABLE_TO_RECORD, true).		
 	
%%活动开启信息
%%t_active_open_time_template ==> ets_active_open_time_template
-record(ets_active_open_time_template, {
		active_id,						%%活动id
		open_week,						%%活动开启星期
		open_time = [],					%%活动开始时间
		continue_time,					%%活动持续时间
		time = 0,						%%目前被使用到的时间
		other = 0,						%%活动状态
		award = []						%%活动奖励
		}).
%%活动刷新怪物或采集物信息
%%t_active_refresh_monster_template ==> ets_active_refresh_monster_template
-record(ets_active_refresh_monster_template, {
		active_id = 0,		%%活动编号
		monsters = [],		%%刷新怪物列表
		collects = [],		%%刷新采集物列表
		maps = [],			%%刷新地图列表
		refresh_map_num = 1,%%需要刷新的地图数量
		notice				%%活动开始前
		}).

%%试炼副本信息模版
%%t_challenge_duplicate_template ==> ets_challenge_duplicate_template
-record(ets_challenge_duplicate_template, {
		id = 0,					%%关卡编号
		limit_id = 0,			%%前置关卡编号
		storey = 0,				%%所在层数
		duplicate_id = 0,		%%对应副本编号
		star_time =0,			%%评判星级所需的奖励
		gift = 293000			%%试炼霸主礼包
		}).

%% 副本抽奖模版表
%% t_duplicate_lottery_template ==> ets_duplicate_lottery_template 	
-record(ets_duplicate_lottery_template, {
		id,									%%id
		duplicate_id,						%%副本id
		career,								%%职业
		rate,								%%概率
		item_id,							%%物品唯一id
		amount,								%%物品数量
		is_bind								%%是否绑定
	}).


%% 副本模板表	
%% t_duplicate_template ==> ets_duplicate_template 	
-record(ets_duplicate_template, {	
      duplicate_id,                           %% 副本id	
      name,                                   %% 副本名称	
      description,                            %% 描述	
      day_times,                              %% 每天次数	
      npc,                                    %% npc	
      recommend,                              %% 推荐度	
      type,                                   %% 类型1普通副本，2分批出现副本，3守塔副本，4特殊副本,	
      showtype = 0,                           %% 显示类型	
      min_level,                              %% 最小等级	
      max_level,                              %% 最大等级	
      min_player,                             %% 最少玩家数	
      max_player,                             %% 最多玩家数	
      need_yuan_bao,                          %% 需要元宝	
      need_bind_yuan_bao,                     %% 需要绑定元宝	
      need_copper,                            %% 需要铜币	
      need_bind_copper,                       %% 需要绑定铜币	
      need_item_id,                           %% 需要物品	
      mission,                                %% 副本关卡	
      award_id = "",                          %% 副本奖励	
      can_reset = 0,                          %% 隔天刷新	
      map_id = 0,                             %% 地图id	
      pos_x = 0,                              %% 坐标x	
      pos_y = 0,                              %% 坐标y	
      total_time,                             %% 0	
      is_dynamic = 1,                         %% 是否动态副本	
      task_id = 0,                            %% 前置任务	
      is_show_in_activity = 1,                %% 是否显示活动界面	
      other_data                              %% 其他数据	
    }).	
	
%% 副本关卡模板	
%% t_duplicate_mission_template ==> ets_duplicate_mission_template 	
-record(ets_duplicate_mission_template, {	
      mission_id,                             %% 模板id	
      name,                                   %% 	
      description,                            %% 描述	
      need_times,                             %% 需要时间	
      code_id,                                %% 代码模块	目前未使用
      map_id,                                 %% 地图id	
      pos_x,                                  %% x坐标	
      pos_y,                                  %% y坐标	
      monster_list,                           %% 怪物列表:idx,y|id,x,y,	
      script,                                 %% 脚本	
      award_id,                               %% 奖励id	
      dorp_id,								  %%  掉落id
      other_data                              %% 其他数据	
    }).	
	
%% 副本物品掉落模板	
%% t_duplicate_item_template ==> ets_duplicate_item_template 	
-record(ets_duplicate_item_template, {	
      item_template_id,                       %% 物品模板ID	
      duplicate_template_id,                  %% 副本模板Id	
      state,                                  %% 掉落类型：普通1，任务2	
      random,                                 %% 总几率为10000	
      amount,                                 %% 数量	
      is_bind                                 %% 是否绑定	
    }).	
	
%% 过滤字符	
%% t_filter_content ==> ets_filter_template 	
-record(ets_filter_template, {	
      type = 0,                               %% 类型	
      content                                 %% 内容	
    }).	
	
%% 昵称模板	
%% t_nick_template ==> ets_nick_template 	
-record(ets_nick_template, {	
      type = 0,                               %% 昵称	
      content                                 %% 内容	
    }).	
	
%% 玩家基础属性模板表	
%% t_user_attr_template ==> ets_user_attr_template 	
-record(ets_user_attr_template, {	
      career = 0,                             %% 	
      level = 0,                              %% 等级	
      current_hp = 0,                         %% 生命	
      current_mp = 0,                         %% 法力	
      attack = 0,                             %% 攻击	
      mump_attack = 0,                        %% 斗气攻击	
      far_attack = 0,                         %% 远程攻击	
      magic_attack = 0,                       %% 魔法攻击	
      defense = 0,                            %% 防御	
      mump_defense = 0,                       %% 斗气防御	
      far_defense = 0,                        %% 远程防御	
      magic_defense = 0,                      %% 魔法防御	
      hit_target = 0,                         %% 命中	
      duck = 0,                               %% 闪避	
      deligency = 0,                          %% 坚韧	
      power_hit = 0,                          %% 致命一击	
      max_physical = 0,                       %% 体力上限	
      max_experiences = 0,                    %% 历练上限	
      mump_avoid_in_hurt = 0,                 %% 斗气伤害减免	
      far_avoid_in_hurt = 0,                  %% 远程伤害减免	
      magic_avoid_in_hurt = 0,                %% 魔法伤害减免	
      keep_off = 0,                           %% 格挡	
      attack_suppression = 0,                 %% 进攻压制	
      defense_suppression = 0,                %% 防御压制	
      attack_speed = 0                        %% 普通攻击速度	
    }).	
	
%% 经验表	
%% t_exp_template ==> ets_exp_template 	
-record(ets_exp_template, {	
      level,                                  %% 等级	
      exp = 0,                                %% 经验值	
      total_exp = 0                           %% 总经验值	
    }).	
	
%% 地图模板	
%% t_map_template ==> ets_map_template 	
-record(ets_map_template, {	
      map_id = 0,                             %% 地图id	
      path = 0,                               %% 图片路径	
      type = 0,                               %% 类型:1普通，2副本	
      name = <<"0">>,                         %% 名字	
      index = 0,                              %% 地图索引值	
      is_open = 0,                            %% 是否开通	
      requirement = <<"0">>,                  %% 需求	
      area = <<"0">>,                         %% 区域1.摆摊，2.安全	
      return_map = <<"10,500,500">>,          %% 死亡返回地图	
      music = 0,                              %% 背景音乐	
      default_point = <<"0">>,                %% 默认传送点	
      rand_point = <<"0">>,                   %% 随机传送点	
	  attack_path = <<"0">>,
      other_data                              %% 	
    }).	
	
%% 状态模板	
%% t_buff_template ==> ets_buff_template 	
-record(ets_buff_template, {	
      buff_id = 0,                            %% 编号	
      group_id = 0,                           %% 分组ID	
      name = <<"0">>,                         %% 名称	
      type = 0,                               %% 类型 1.血包 2. 魔法包 3.多倍经验 4.普通Buff,5.速度 6.状态 7.持续加减血
      hit_percent = 0,                        %% 命中率	
      active_percent = 0,                     %% 起效机率	
      active_timespan = 0,                    %% 起效时间间隔	
      active_totaltime = 0,                   %% 起效总时间	
      limit_totaltime = -1,                   %% buff累计上限时间	
      skill_effect_list = <<"0">>,            %% 状态列表，同Skill中同名字段设置	
      pic_path = <<"0">>,                     %% 图片路径	
      description = <<"0">>,                  %% 描述	
      merge_type = 0,                         %% 合并类型 1时间叠，2时间重置，3不能叠
%% 	  is_save = 0,						      %% 是否保存
      replace_buffids = <<"0">>,              %% 当本buff起效，替换列表中buff	
      cant_createbuffids = <<"0">>,           %% 此列表中buff起效，则本buff不起效
	  rem_buff_type = 0						  %% 移除BUFF状态 0:不删除 1:副本退出移除BUFF	2:死亡移除BUFF
    }).	
	
%% 跳转门	
%% t_door_template ==> ets_door_template 	
-record(ets_door_template, {	
      door_id = 0,                            %% 编号	
      current_map_id = 0,                     %% 当前地图编号	
      next_map_id = 0,                        %% 目标地图编号	
      next_door_id = 0,                       %% 目标跳转门编号	
      pos_x = 0,                              %% 坐标X	
      pos_y = 0,                              %% 坐标Y
	  next_pos_x = 0,							%% 目标坐标x
	  next_pos_y = 0,							%% 目标坐标y
      other_data                              %% 	
    }).	
	
%% 物品种类模版表	
%% t_item_category_template ==> ets_item_category_template 	
-record(ets_item_category_template, {	
      item_category_id = 0,                   %% 编号	
      name = <<"0">>,                         %% 名称	
      place = 0                               %% 标识	
    }).	
	
%% 物品模板表	
%% t_item_template ==> ets_item_template 	
-record(ets_item_template, {	
      template_id = 0,                        %% 编号	
      name = <<"0">>,                         %% 名称	
      pic = 0,                                %% 图片	
      icon = 0,                               %% 图标	
      description = <<"0">>,                  %% 描述	
      category_id = 0,                        %% 分类编号	
      quality = 0,                            %% 品质	
      need_level = 0,                         %% 需要等级	
      need_sex = 0,                           %% 需要性别	
      need_career = 0,                        %% 需要职业	
      max_count = 0,                          %% 最大数量	
      attack = 0,                             %% 攻击值	
      defense = 0,                            %% 防御值	
      sell_copper = 0,                        %% 卖店价格	
      sell_type = 0,                          %% 卖店货币类型	
      copper = 0,                             %% 铜币	
      bind_copper = 0,                        %% 绑定铜币	
      yuan_bao = 0,                           %% 元宝	
      bind_yuan_bao = 0,                      %% 绑定元宝	
      suit_id = 0,                            %% 套装编号	
      repair_modulus = 0,                     %% 修理系数	
      bind_type = 0,                          %% 绑定类型0装备绑定，0不绑定，2绑定,	
      durable_upper = 0,                      %% 耐久上限	
      cd = 0,                                 %% 冷却时间	
      can_use = 0,                            %% 能否使用	
      can_lock = 0,                           %% 能否加锁	
      can_strengthen = 1,                     %% 能否强化	
      can_enchase = 1,                        %% 能否镶嵌	
      can_rebuild = 1,                        %% 能否重铸(能否洗练)	
      can_recycle = 1,                        %% 能否回收(能否分解)	
      can_improve = 1,                        %% 能否升级	
      can_unbind = 1,                         %% 能否解绑	
      can_repair = 1,                         %% 能否修理	
      can_destroy = 1,                        %% 能否摧毁	
      can_sell = 1,                           %% 能否出售	
      can_trade = 1,                          %% 能否交易	
      can_feed = 1,                           %% 能否喂养	
      free_property = "",                     %% 自由属性	
      regular_property = "",                  %% 固定属性	
      hide_property = "",                     %% 隐藏属性	
      attach_skill = <<"0">>,                 %% 附加技能	
      hide_attack = 0,                        %% 隐藏攻击	
      hide_defense = 0,                       %% 隐藏防御	
      valid_time = 0,                         %% 有效时间
      feed_count = 0,						  %% 喂养产生的经验值	
      script = <<"0">>,                       %% 脚本	
      propert1 = 0,                           %% 属性一	
      propert2 = 0,                           %% 属性二	
      propert3 = 0,                           %% 属性三	
      propert4 = 0,                           %% 属性四	
      propert5 = 0,                           %% 属性五	
      propert6 = 0,                           %% 属性六	
      propert7 = 0,                           %% 属性七	
      propert8 = 0,                           %% 属性八	
      other_data                              %% 其他数据	
    }).	
	
%% 怪物掉落物品表	
%% t_monster_item_template ==> ets_monster_item_template 	
-record(ets_monster_item_template, {	
      item_template_id = 0,                   %% 物品编号	
      monster_template_id = 0,                %% 怪物编号	
      state = 0,                              %% 掉落类型：普通1，任务2	
      random = 0,                             %% 机率	
      amount = 0,                             %% 数量	
      isbind = 1,                             %% 是否绑定	
      fight_type = 0,                         %% 预留，未使用	
      total_random = 0                        %% 随机值上限	
    }).	
	
%% 怪物	
%% t_monster_template ==> ets_monster_template 	
-record(ets_monster_template, {	
      monster_id = 0,                         %% 怪物模板编号	
      name = <<"0">>,                         %% 怪物名称	
      level = 1,                              %% 	
      monster_type = 0,                       %% 怪物种类	
      max_hp = 0,                             %% 最大hp	
      hp_recover = 0,                         %% ph恢复速度	
      acthurt_max = 0,                        %% 对目标单次伤害血量上限	
      acthurt_min = 0,                        %% 对目标单次伤害血量上限	
      targethurt_max = 0,                     %% 单次受伤害血量上限	
      targethurt_min = 0,                     %% 单次受伤害血量上限	
      camp = 0,                               %% 阵营	
      act_type = 0,                           %% 攻击模式	
      attack_physics = 0,                     %% 普通攻击力	
      attack_range = 0,                       %% 远程伤害	
      attack_magic = 0,                       %% 魔法伤害	
      attack_vindictive = 0,                  %% 斗气伤害	
      attack_speed = 0,                       %% 攻击速度	
      attack_distince = 0,                    %% 攻击距离	
      defanse_physics = 0,                    %% 普通防御力	
      defanse_range = 0,                      %% 远程防御	
      defanse_magic = 0,                      %% 魔法防御	
      defanse_vindictive = 0,                 %% 斗气防御	
      hit = 0,                                %% 命中	
      dodge = 0,                              %% 闪避	
      critical = 0,                           %% 暴击	
      tough = 0,                              %% 坚韧	
      block = 0,                              %% 格挡	
      reduce_range = 0,                       %% 远程吸收	
      redece_magic = 0,                       %% 魔法吸收	
      reduce_vindictive = 0,                  %% 斗气吸收	
      immune_buff = <<"0">>,                  %% 免疫负面状态	
      skill = <<"0">>,                        %% 可使用技能	
      speech_common = <<"0">>,                %% 非战斗中随机说话	
      speech_action = <<"0">>,                %% 战斗中随机说话	
      exp_fixed = 0,                          %% 杀死后固定获得经验	
      exp = 0,                                %% 杀死后获得经验	
      move_speed = 0,                         %% 移动速度	
      act_distince = 0,                       %% 视野	
      return_distince = 0,                    %% 追击距离	
      guard_distince = 0,                     %% 巡逻距离	
      reborn_time = 0,                        %% 重生时间	
      pic_path = <<"0">>,                     %% 图片路径	
      map_id = 0,                             %% 场景ID	
      local_point = <<"0">>,                  %% 中心点	
      lbornl_points = <<"0">>,                %% 出生点	
	   move_path,							  %% 巡逻路径
      abnormal_rate = 0,                      %% 异常概率	
      anti_abnormal_rate = 0,                 %% 抗异常概率	
	  monster_width = 50,
	  monster_height = 120,
	  type = 0,								  %%
	  frame_rates = "",
	  world_level = 0,						%% (0不使用，1使用)
	  can_reborn = 1,						  %%复活类型(0:不能复活,1:能复活)
	  destruct_time = 0						  %%自毁时间(0,永远不会消失) 	
    }).	
	
%% 动画表	
%% t_movie_template ==> ets_movie_template 	
-record(ets_movie_template, {	
      move_id = 0,                            %% 编号	
      frame = <<"0">>,                        %% 帧	
      offset_x = 0,                           %% 偏移x	
      offset_y = 0,                           %% 偏移y	
      pic_path = 0,                           %% 路径	
      amount = 0,                             %% 数量	
      bound = 0,                              %% 范围（x边长）	
      item = 0,                               %% 时间（毫秒）	
      add_mode = 0,                           %% 叠加模式	
      is_move = 0,                            %% 是否可以移动（1是可以移动）	
      comp_effect = 0                         %% 完成效果	
    }).	
	
%% npc	
%% t_npc_template ==> ets_npc_template 	
-record(ets_npc_template, {	
      npc_id = 0,                             %% 编号	
      name = <<"0">>,                         %% 名称	
      function_name = <<"0">>,                %% 功能名称	
      pic_path = <<"0">>,                     %% 图片路径	
      icon_path = <<"0">>,                    %% 头像路径	
      dialog = <<"0">>,                       %% 对话	
      deploys = <<"0">>,                      %% 部署配置	
      map_id = 0,                             %% 地图ID	
      pos_x = 0,                              %% 坐标X	
      pos_y = 0,                               %% 坐标Y
      npc_width = 50,
	  npc_height = 120,
	  frame_rates = ""
    }).	
	
%% 商店分类	
%% t_shop_category_template ==> ets_shop_category_template 	
-record(ets_shop_category_template, {	
      category_id = 0,                        %% 分类编号	
      name = <<"0">>                          %% 分类名称	
    }).	
	
%% t_formula_name_template	
%% t_formula_name_template ==> ets_formula_name_template 	
-record(ets_formula_name_template, {	
      id = 0,                                 %% 炼炉名称编号	
      name = ""                               %% 名称	
    }).	
	
%% t_formula_table_template	
%% t_formula_table_template ==> ets_formula_table_template 	
-record(ets_formula_table_template, {	
      type = 0,                               %% 类型	
      formulaid = 0,                          %% 配方id	
      create_id = 0,                          %% 产出道具id	
      create_name = ""                        %% 产出道具名称	
    }).	
	
%% 商店	
%% t_shop_template ==> ets_shop_template 	
-record(ets_shop_template, {	
      id = 0,                                 %% id标识	
      shop_id = 0,                            %% 商店编号	
      category_id = 0,                        %% 分类编号	
      template_id = 0,                        %% 出售物品模板编号	
      state = 0,                              %% 商店状态	
      pay_type = 0,                           %% 付款类型	
      price = 0,                              %% 价格	
      old_price = 0,                          %% 原价
      yuanbao = 0,							  %% 抵元宝数量
	  sale_num = 0,								%% 可购买数量（0不限制）	
      is_bind = 0                             %% 是否绑定	
    }).	
	
%% t_sit_award_template	
%% t_sit_award_template ==> ets_sit_award_template 	
-record(ets_sit_award_template, {	
      level = 0,                              %% 等级	
      single_exp = 0,                         %% 单休获得经验	
      normal_double_exp = 0,                  %% 普通双修经验	
      special_double_exp = 0,                 %% 特殊双修经验	
      single_lifeexp = 0,                     %% 单修获得历练	
      normal_double_lifeexp = 0,              %% 普通双修历练	
      special_double_lifeexp = 0,             %% 特殊双修历练	
      hp = 0,                                 %% 打坐回复HP	
      mp = 0,                                 %% 打坐回复MP	
      bonfire_exp = 0,                        %% 篝火奖励经验
	  spa_exp = 0,
	  spa_lifeexp = 0,	
      xw_lifeexp = 0                          %% 修为历练
	
    }).	
%% 系统第一玩家管理
%% t_sys_first ==> ets_sys_first
-record(ets_sys_first, {
						type = 0,			%%第一类型（如pvp天下第一，王城主）
						user_id = 0,		%%夺得玩家id
						expires_time = 0,	%%到期时间
						name = ""}).

%% 优惠商品	
%% t_shop_discount_template ==> ets_shop_discount_template 	
-record(ets_shop_discount_template, {	
      id = 0,                                 %% id标识	
      template_id = 0,                        %% 出售物品模板编号	
      state = 0,                              %% 商店状态	
      pay_type = 0,                           %% 付款类型	
      price = 0,                              %% 价格	
      old_price = 0,                          %% 原价	
      is_bind = 0,                            %% 是否绑定	
      max_count = -1,                         %% 购买的最大数量	
      start_date = <<"0">>,                   %% 优惠活动开始日期	
      finish_date = <<"0">>,                  %% 优惠活动结束日期	
      start_time = 0,                         %% 抢购开始时间	
      finish_time = 0,                        %% 抢购结束时间	
      which_day = 0,                          %% 哪一天的商品(0-6:周日到周六)	
      type = 0,                               %% 类型：0-日常;1-开服	
      dates = 0,                              %% 开服优惠天数	
      limit_count = 0,                        %% 每人限购数量0-无限制,	
      other_data                              %% 	
    }).	

%% 商店NPC对应NPC编号
%% t_shop_npc_template ==> ets_shop_npc_template 	
-record(ets_shop_npc_template, {	
      shop_id = 0,                            %% 商店编号	
      npc_id = 0                        	  %% NPC编号
    }).
	
%% 试练动态怪物系数表	
%% t_dynamic_mon_template ==> ets_dynamic_mon_template 	
-record(ets_dynamic_mon_template, {	
      level = 0,                              %% 等级	
      hp_modulus = 0,                         %% hp成长系数	
      attack_modulus = 0,                     %% 普通攻击成长系数	
      defense_modulus = 0,                    %% 普通防御系数	
      exp_modulus = 0                         %% 经验成长系数	
    }).	
	
%% 活跃度礼包表	
%% t_active_bag_template ==> ets_active_bag_template 	
-record(ets_active_bag_template, {	
      num = 0,                                %% 编号	
      bag_id = 0,                             %% 礼包id	
      need_active = 0                         %% 所需活跃度	
    }).	


	
%% 活跃度表	
%% t_active_template ==> ets_active_template 	
-record(ets_active_template, {	
      id,                                     %% 编号	
      active_name,                            %% 活动名称	
      active_acount,                          %% 次数	
      active_time,                            %% 开放时间	
      npc_id,                                 %% npc编号	
      descrition,                             %% 描述	
      active,                                 %% 活跃度	
      type = 0,                               %% 类型	
      awards_type,                            %% 奖励类型	
      active_id = -1,                         %% 活动编号	
      duplicate_id = -1,                      %% 副本编号	
      task_id = -1,							  %% 任务编号
	  min_level = 0							  %% 等级限制					          
    }).	
	
%% 活动奖励表	
%% t_active_rewards_template ==> ets_active_rewards_template 	
-record(ets_active_rewards_template, {	
      id,                                     %% 编号	
      need_active,                            %% 所需活跃度	
      rewards_exp,                            %% 奖励经验	
      bind_copper,                            %% 奖励铜币	
      bind_yuanbao,                           %% 绑定元宝	
      items                                   %% 奖励物品	
    }).		



%% 用户活动活跃度	
%% t_users_active ==> ets_users_active 	
-record(ets_users_active, {	
      user_id = 0,                            %% 用户编号
      day_active = 0,                         %% 当日活跃度
	  rewards = [],							  %% 已经奖励
      date = 0,                               %% 最后一次完成时间
      times = [],                              %% 当日次数
	  other_data = ""						  
    }).	

%% boss刷新信息模版
%% t_boss_template ==> ets_boss_template
-record(ets_boss_template, {
		boss_id = 0,
		boss_type = 0,
		map_id = 0,
		relive_time = 0,
		relive_time2,
		relive_position,
		state = 0,			%%boss状态，0死亡，1存活
		dead_time = 0		%%死亡时间，对应表中other
		}).
		
%% 答题库模版
%% t_question_bank_template ==> ets_question_bank_template
-record(ets_question_bank_template,{
		id = 0,					%% 题目编号
		type = 0, 				%% 题目类型
		content = <<>>,			%% 题目内容
		option = <<>>,			%% 题目选项
		key = 0					%% 正确答案
		}).

%% 福利模板表	
%% t_active_welfare_template ==> ets_active_welfare_template 	
-record(ets_active_welfare_template, {	
      welfare_id = 0,                         %% 福利编号	
      welfare_name = "",                      %% 名称	
      bag_id = "",                            %% 礼包id	
      descript = ""                           %% 描述	
    }).	

%% t_open_box_template	
%% t_open_box_template ==> ets_open_box_template 	
-record(ets_open_box_template, {	
      type = 0,                               %% 类型	
      itemlist = ""                           %% 宝物显示	
    }).	
	
%% 套装编号模板表	
%% t_suit_num_template ==> ets_suit_num_template 	
-record(ets_suit_num_template, {	
      suit_num = 0,                           %% 套装编号	
      suit_name = "",                         %% 套装名称	
      cloth_id = 0,                           %% 衣服id	
      armet_id = 0,                           %% 头盔id	
      cuff_id = 0,                            %% 护腕id	
      shoe_id = 0,                            %% 鞋子id	
      caestus_id = 0,                         %% 腰带id	
      necklack_id = 0                         %% 项链id	
    }).	
	
%% 套装属性模板表	
%% t_suit_props_template ==> ets_suit_props_template 	
-record(ets_suit_props_template, {	
      id = 0,                                 %% id	
      suit_num = 0,                           %% 套装编号	
      suit_amount = 0,                        %% 套装数量	
      suit_props = "",                        %% 套装属性	
      suit_hide_props = "",                   %% 套装隐藏属性	
      skill_id = 0,                           %% 技能id	
      description = ""                        %% 描述	
    }).	
	
%% 技能模板	
%% t_skill_template ==> ets_skill_template 	
-record(ets_skill_template, {	
      skill_id = 0,                           %% 技能id	
      group_id = 0,                           %% 组id（同一技能不同级别为1组）	
      name = "",                              %% 名称	
      description,                            %% 描述	
      category_id = 0,                        %% 技能种类归属	
      active_use_mp = 0,                      %% 使用消耗MP	
      active_type = 0,                        %% 起效方式：主动，被动，辅助	
      active_side = 0,                        %% 起效方向：敌人，自身，自身团队	
      active_target_type = 0,                 %% 起效对象：不区分，玩家，指定怪物	
      active_target_monster_list,             %% 指定怪物列表	
      active_item_category_id = 0,            %% 技能指定装备种类类型	
      active_item_template_id = 0,            %% 技能指定装备类型	
      cold_down_time = 0,                     %% 冷却时间	
      range = 0,                              %% 使用距离	
      radius = 0,                             %% 作用半径	
      effect_number = 0,                      %% 影响人数	
      skill_effect_list,                      %% 技能效果列表，排列方式 type，影响值|type，影响值，分母。两位表示加法，三位表示乘法	
      buff_list = "",                         %% 状态类列表，排列方式  ID|ID	
      sound = 0,                              %% 音效	
      wind_effect = 0,                        %% 风位效果	
      attack_effect = 0,                      %% 攻击动画	
      beattack_effect = 0,                    %% 被击动画	
      pic_path = "",                          %% 图片路径	
      next_skill_id = 0,                      %% 下一级技能ID	
      update_life_experiences = 0,            %% 升级需要历练	
      need_career = 0,                        %% 需要职业	
      need_level = 0,                         %% 需要级别	
      need_item_id,                           %% 需要物品	
	  need_skill_id = 0,					  %% 需要技能编号
	  need_skill_level = 0,					  %% 需要技能等级
	  need_feets = 0,					  	  %% 需要贡献
      default_skill = 0,                      %% 是否默认技能	
      straight_time = 0,                      %% 硬直时间	
      prepare_time = 0,                       %% 准备时间	
      current_level = 0,                      %% 当前级别	
      place = 0,                              %% 技能树位置	
      need_copper = 0,                        %% 需要铜币	
      is_big_skill,                           %% 是否大招	
      is_single_attack,                       %% 是否单击（群攻）	
      is_shake = 0,                           %% 是否震动
	  seal_id = 0							  %% 封印后产生的道具编号
    }).	
    
%% 筋脉模版表
%% t_veins_template ==> ets_veins_template
-record(ets_veins_template, {
		acupoint_id = 0,								%%穴位id
		acupoint_name = "",								%%穴位名称
		acupoint_level = 0,								%%穴位等级
		acupoint_type = 0,								%%穴位类别
		need_copper = 0,								%%升级穴位所需铜币
		need_life_exp = 0,								%%升级穴位所需历练
		need_times = 0,									%%升级穴位所需时间
		need_gengu_amulet = 0,							%%提升根骨需要失败n次后才开始计算成功率
		gengu_success_rate = 0,							%%根骨升级成功率
		award_attribute_type = 0,						%%奖励属性类型
		award_acupoint = 0,								%%穴位升级奖励
		award_acupoint_count = 0,						%%穴位总奖励
		award_gengu = 0,								%%根骨升级奖励
		award_gengu_count = 0							%%根骨总奖励
	}).
-record(ets_veins_extra_template,{
		id = 0,											%%编号
		name = "",										%%名称
		need_level = 0,									%%所需等级
		hp = 0,											%%奖励hp值
		defense = 0,									%%奖励防御
		mump_defense = 0,								%%奖励外功防御
		magic_defense = 0,								%%奖励内功防御
		far_defense = 0,								%%奖励远程防御
		attack = 0,										%%奖励攻击
		attribute_attack = 0,							%%奖励属性攻击
		damage	= 0										%%奖励伤害
		}).
	
%% 获得自由属性数量和属性分配比例的几率	
%% t_rebuild_prop_template ==> ets_rebuild_prop_template 	
-record(ets_rebuild_prop_template, {	
      quality = 0,                            %% 装备品质	
      prop_num = 0,                           %% 洗练出现的属性个数	
      rate = 0,                               %% 出现属性个数几率	
      section1 = 0,                           %% 段1的几率	
      section2 = 0,                           %% 段2的几率	
      section3 = 0,                           %% 段3的几率
      section4 = 0,                           %% 段4的几率	
      section5 = 0,                           %% 段5的几率	
      section6 = 0,                           %% 段6的几率	
      section7 = 0,                           %% 段7的几率	
      section8 = 0,                           %% 段8的几率	
      section9 = 0                            %% 段9的几率							  	
    }).	
	
%% 宝石合成铜币消耗	
%% t_stone_compose_template ==> ets_stone_compose_template 	
-record(ets_stone_compose_template, {	
      stone_level = 0,                        %% 材料宝石等级	
      copper = 0                              %% 消耗铜币	
    }).	
	
%% 打孔模板	
%% t_hole_template ==> ets_hole_template 	
-record(ets_hole_template, {	
      holeflag = -1,                          %% 打孔表标识：0为几率，1为金钱	
      enchase1 = 0,                           %% 第一个孔的系数	
      enchase2 = 0,                           %% 第二个孔的系数	
      enchase3 = 0,                           %% 第三个孔的系数	
      enchase4 = 0,                           %% 第四个孔的系数	
      enchase5 = 0                            %% 第五个孔的系数	
    }).	
	
%% 宝石镶嵌表	
%% t_enchase_template ==> ets_enchase_template 	
-record(ets_enchase_template, {	
      stone_level = 0,                        %% 镶嵌宝石的等级	
      copper = 0                              %% 金钱消耗系数	
    }).	
	
%% t_box_template	
%% t_box_template ==> ets_box_template 	
-record(ets_box_template, {	
      id = 0,                                 %% id	
      box_type = 0,                           %% 箱子类型	
      career = 0,                             %% 职业	
      rate = 0,                               %% 出现几率	
      item_id = 0,                            %% 物品id	
      amount = 0,                             %% 数量	
      streng_level = 0,                       %% 强化等级	
      is_bind = 0,                            %% 是否绑定	
      modulus = 0                             %% 珍贵系数	
    }).	
	
%% t_streng_copper_template	
%% t_streng_copper_template ==> ets_streng_copper_template 	
-record(ets_streng_copper_template, {	
      streng_level = 0,                       %% 强化等级	
      needcopper = 0                          %% 消耗金钱	
    }).	
	
%% t_decompose_copper_template	
%% t_decompose_copper_template ==> ets_decompose_copper_template 	
-record(ets_decompose_copper_template, {	
      quality = 0,                            %% 装备品质	
      needcopper = 0                          %% 洗练花费金钱	
    }).	
	
%% 宝石摘取成功率表	
%% t_pick_stone_template ==> ets_pick_stone_template 	
-record(ets_pick_stone_template, {	
      stone_level = 0,                        %% 石头等级	
      copper_modulus = 0,                     %% 金钱系数	
      success_rates = 0                       %% 摘取成功率	
    }).	
	
%% 强化成功几率加成表	
%% t_streng_rate_template ==> ets_streng_rate_template 	
-record(ets_streng_rate_template, {	
      id = 0,                                 %% Id	
      category_id = 0,                        %% 装备类型	
      streng_level = 0,                       %% 强化等级	
      streng_rates = 0,                       %% 强化成功率	
      props = ""                              %% 属性列表	
    }).	

%% 装备镶嵌相关数据配置
%% t_equip_enchase_template ==> ets_equip_enchase_template
-record(ets_equip_enchase_template, {
		level = 0,							%%石头等级
		need_num = 0,						%%所需石头数量
		add_properties = []					%%属性加成
		}).

%% 装备强化加成相关数据配置表
%% t_equip_strength_template ==> ets_equip_strength_template 
-record(ets_equip_strength_template, {
		level = 0,								%% 装备强化等级
		attack = 0,								%% 攻击加成
		attr_attack = 0,						%% 属性攻击加成
		mump_defence = 0,						%% 外攻防御加成
		magic_defence = 0,						%% 内功防御加成
		far_defence = 0,						%% 远攻防御加成 
		hp = 0									%% hp加成
	}).

%% 强化相关数据配置表
%% t_strengthen_template ==> ets_strengthen_template 	
-record(ets_strengthen_template, {
		level = 0,						%% 强化等级
		min_num = 0,					%% 强化最少次数
		max_num = 0,					%% 强化最大失败次数
		success_rate = 0,				%% 强化成功率
		need_copper = 0,				%% 需要铜币
		need_stone = 0,					%% 所需强化石
		perfect_stone = 0,				%% 可用完美石头
		grow_up = 0,					%% 成长比例
		addition = 0					%% 增加比例
	}).	

%% 强化系数表	
%% t_streng_modulus_template ==> ets_streng_modulus_template 	
-record(ets_streng_modulus_template, {	
      id = 0,                                 %% id	
      quality = 0,                            %% 装备品质	
      min_level = 0,                          %% 最小装备等级	
      max_level = 0,                          %% 最大装备等级	
      mudulus = 0                             %% 系数	
    }).	
	
%% 强化失败附加成功率表	
%% t_streng_addsuccrate_template ==> ets_streng_addsuccrate_template 	
-record(ets_streng_addsuccrate_template, {	
      failacount = 0,                         %% 连续失败次数	
      addsuccrate = 0                         %% 附加成功率	
    }).	
	
%% 物品配方表	
%% t_formula_template ==> ets_formula_template 	
-record(ets_formula_template, {	
      formula_id = 0,                         %% 编号id	
	  type = 0,								   %% 子类型
      name = <<"0">>,                         %% 名称	
      create_id = 0,                          %% 新物品id	
      create_name = <<"0">>,                  %% 新物品名称	
      create_amount = 0,                      %% 数量	
      success_rate = 0,                       %% 成功率	
      cost_copper = 0,                        %% 消耗铜币	
      item1 = 0,                              %% 材料1	
      amount1 = 0,                            %% 数量1	
      item2 = 0,                              %% 材料2	
      amount2 = 0,                            %% 数量2	
      item3 = 0,                              %% 材料3	
      amount3 = 0,                            %% 数量3	
      item4 = 0,                              %% 材料4	
      amount4 = 0,                            %% 数量4	
      item5 = 0,                              %% 材料5	
      amount5 = 0,                            %% 数量5	
      item6 = 0,                              %% 材料6	
      amount6 = 0                             %% 数量6	
    }).	

%% 装备升级表
%% t_item_uplevel_template ==> ets_item_uplevel_template
-record(ets_item_uplevel_template,{
		item_template_id = 0,				%% 装备原型id
		uplevel_copper = 0,					%% 升级所需铜币
		uplevel_material = "",				%% 升级所需材料初始化后为list
		uplevel_target_id = 0				%% 升级后原型id
	}).
%% 装备精炼表
%% t_item_upgrade_template ==> ets_item_upgrade_template
-record(ets_item_upgrade_template,{
		item_template_id = 0,				%% 装备原型id
		upquality_copper = 0,				%% 精炼所需铜币
		upquality_material = "",			%% 精炼所需材料初始化后为list
		upquality_target_id = 0				%% 精炼后原型id
	}).


%% 装备分解表	
%% t_decompose_template ==> ets_decompose_template 	
-record(ets_decompose_template, {	
      quality = -1,                           %% 装备系数	
      needcopper = 0,                         %% 装备分解费用消耗	
      succ_rate = 0                           %% 装备分解成功率	
    }).	
	
%% 装备类型对应镶嵌的石头类型	
%% t_item_stone_template ==> ets_item_stone_template 	
-record(ets_item_stone_template, {	
      category_id = 0,                        %% 装备分类编号	
      stone_list                              %% 	
    }).

%% 装备熔炼表
-record(ets_item_fusion_template, {
		item_template_id1 = 0, 		%% 熔炼装备1
		item_template_id2 = 0, 		%% 熔炼装备2
		fusion_num = 0,				%% 需要的熔炼符数量
		fusion_item_template_id = 0	%% 熔炼产生的新装备		
}).	

%%江湖令任务信息模版
%% t_token_task_template ==> ets_token_task_template
-record(ets_token_task_template,{
		type = 0,					%%令牌品质类型1，2，3，4
		copper = 0,					%%奖励铜币
		copper_bind = 0,			%%奖励绑定铜币
		exp = 0,					%%奖励经验
		other = 0,					%%备用
		item_id = 0					%%发布所需道具（发布一次消耗一个）
		}).

%% 任务奖励模板表	
%% t_task_award_template ==> ets_task_award_template 	
-record(ets_task_award_template, {	
      award_id = 0,                           %% 编号	
      sex = 0,                                %% 性别	
      career = 0,                             %% 职业	
      template_id = 0,                        %% 物品编号	
      amount = 0,                             %% 数量	
      validate = 0,                           %% 有效期	
      is_bind = 1                             %% 是否绑定	
    }).	
	
%% 任务状态模板表	
%% t_task_state_template ==> ets_task_state_template 	
-record(ets_task_state_template, {	
      task_state_id,                          %% id	
      task_id = 0,                            %% 任务编号	
      condition = 0,                          %% 任务条件	
      npc = 0,                                %% npc	
      target = <<"0">>,                       %% 目标	
      can_transfer = 1,                       %% 能否传送	
      content = <<"2000">>,                   %% 内容	
      data = <<"0">>,                         %% 脚本	
      award_yuan_bao = 0,                     %% 奖励元宝	
      award_bind_yuan_bao = 0,                %% 奖励绑定元宝	
      award_copper = 0,                       %% 奖励铜币	
      award_bind_copper = 0,                  %% 绑定铜币	
      award_exp = 0,                          %% 奖励经验	
      award_life_experience = 0,              %% 奖励历练	
      award_contribution = 0,                 %% 奖励贡献	
      award_money = 0,                        %% 奖励资金	
      award_activity = 0,                     %% 奖励活跃度	
      award_feats = 0,                        %% 个人功勋	
      task_award_id = "",                     %% 任务奖励编号	
      unfinish_event = <<"0">>,               %% 状态未完成事件	
      finish_event1 = <<"0">>,                %% 状态完成1事件	
      finish_event2 = <<"0">>,                %% 状态完成2事件	
      other_data                              %% 	
    }).	
	
%% 任务模板表	
%% t_task_template ==> ets_task_template 	
-record(ets_task_template, {	
      task_id = 0,                            %% 编号	
      min_level = 0,                          %% 所需最小等级	
      max_level = 0,                          %% 所需最大等级	
      min_guild_level = 0,                    %% 帮派最小等级	
      max_guild_level = 100,                  %% 帮派最大等级	
      camp = -1,                              %% 阵营：-1无限，0无，1神，2魔	
      career = -1,                            %% 职业：-1无限，1尚武，2逍遥，3流星	
      sex = -1,                               %% 性别：-1无限，1男，2女	
      type = 0,                               %% 类型 1.主线2.支线3.循环	
      need_copper = 0,                        %% 需要任务	
      need_item_id = 0,                       %% 需要物品	
      pre_task_id = <<"0">>,                  %% 前置任务	
      next_task_id = <<"0">>,                 %% 后续任务	
      can_repeat = 1,                         %% 能否重复	
      can_jump = 1,                           %% 自动弹出	
      can_reset = 1,                          %% 隔天刷新	
      can_entrust = 0,                        %% 能否委托	
      entrust_time = 0,                       %% 委托所需时间	
      entrust_copper = 0,                     %% 委托所需铜币	
      entrust_yuan_bao = 0,                   %% 委托所需元宝	
      repeat_count = 0,                       %% 每天完成次数	
      repeat_day = 0,                         %% 间隔天数	
      time_limit = 1,                         %% 时间限制	
      begin_date = <<"0">>,                   %% 时间限制	
      end_date = <<"0">>,                     %% 结束时间	
      title = <<"0">>,                        %% 标题	
      target = <<"0">>,                       %% 目标	
      can_transfer = 1,                       %% 能否传送	
      content = <<"0">>,                      %% 内容	
      npc = 0,                                %% npc	
      condition = 0,                          %% 任务条件	
      award_yuan_bao = 0,                     %% 奖励元宝	
      award_copper = 0,                       %% 奖励铜币	
      award_bind_copper = 0,                  %% 绑定铜币	
      award_exp = 0,                          %% 奖励金币	
      task_award_id = <<"0">>,                %% 任务奖励编号	
      accept_event = <<"100">>,               %% 接受事件	
      finish_event = <<"100">>,               %% 完成事件	
      show_level = 1,                         %% 可视等级	
      auto_accept = 1,                        %% 自动接收	
      auto_finish = 1,                        %% 自动完成	
      other_data                              %% 	
    }).	
%% 福利连续30天登录奖励
%% ets_welfare_template ==> t_welfare_template
-record(ets_welfare_template, {
		login_day = 1,							%% 联系登录天数
		award_item_id = 0,						%% 普通奖励物品模版编号
		award_num = 0,							%% 普通奖励物品数量
		vip_award_item_id = 0,					%% vip奖励物品模版编号
		vip_award_num = 0						%% vip奖励物品数量
		}).

%% 经验兑换福利
%% ets_welfare_exp_template ==> t_welfare_exp_template
-record(ets_welfare_exp_template, {
		type_id = 0,							%%兑换类型
		award_exp = 0,							%%免费兑换经验
		copper = 0,								%%兑换需要铜币
		copper_award_exp = 0,					%%铜币兑换经验
		yuanbao = 0,							%%兑换需要元宝
		yuanbao_award_exp = 0					%%元宝兑换经验		
		}).

%% 人物福利领取信息
%% ets_user_welfare ==> t_user_welfare
-record(ets_user_welfare, {
		user_id = 0,							%%用户id
		reset_time = 0,							%%重置时间
		login_day = 1,							%%连续登录天数
		receive_time = 0,						%%福利领取时间
		vip_receive_time = 0,					%%vip福利领取时间
		duplicate_num = 0,						%%单人副本累计未用次数
		multi_duplicate_num = 0,				%%多人副本累计未用次数
		off_line_times = 0						%%离线累计时长
		}).

%% 服务器节点列表	
%% t_server_node ==> t_server_node 	
-record(t_server_node, {	
      server_node = "",                       %% 开服编号+节点编号	
      server_no = "",                         %% 开服编号	
      node = "",                              %% 节点编号	
      node_type = 0,                          %% 节点类型(0--网关节点；1--游戏节点)	
      ip = "",                                %% ip地址	
      port = 0                                %% 端口号	
    }).	
	
%% 结婚记录
-record(ets_user_marry, {
						user_id = 0,		%% 结婚者ID
						marry_id = 0,		%% 结婚ID
						groom_name = "",	%% 新郎名称
						bride_name = "",	%% 新娘名称
						type = 0,			%% 关系类型1老公，2妻子3小妾
						career = 0,			%% 职业
						sex = 0,			%% 性别
						marry_time = 0,		%% 结婚时间
						state = 0,			%% 状态
						divorce_state =0	%% 
						}).

%% 用户表	
%% t_users ==> ets_users 	
-record(ets_users, {	
      id,                                     %% 用户id	
	  server_id = 0,						   %% serverId 
      user_name = "",                         %% 用户名	
      nick_name = "",                         %% 用户昵称	
      sex = 1,                                %% 性别	
      exp = 0,                                %% 经验	
      level = 0,                              %% 等级	
      current_map_id = 0,                     %% 当前地图	
      pos_x = 0,                              %% 当前坐标X	
      pos_y = 0,                              %% 当前坐标y	
	  old_map_id = 0,						   %% 旧地图template——id(使用在进入副本)
	  old_pos_x = 0,
	  old_pos_y = 0,							%% 旧坐标(使用在进入副本)
      state = 0,                              %% 玩家状态1在线，0不在线,	
      online_time = 0,                        %% 在线时间	
      total_online_time = 0,                  %% 总在线时间	
      last_online_date = 0,                   %% 上次在线时间	
      register_date = 1305216000,             %% 注册时间 （默认 5.13）	
      club_id = 0,                            %% 公会id	
      ban_chat = 1,                           %% 是否禁言	
      ban_chat_date = 0,                      %% 禁言时间	
      forbid = 1,                             %% 禁止登陆	
      forbid_date = 0,                        %% 禁止登陆时间	
      forbid_reason = "",                     %% 禁止原因	
      ip = "",                                %% 登陆IP	
      site = "",                              %% 站点	
      is_exist = 1,                           %% 是否存在	
      camp = 0,                               %% 阵营	
      career = 0,                             %% 职业	
      current_hp = 0,                         %% 当前hp	
      current_mp = 0,                         %% 当前mp	
      current_club_contribute = 0,            %% 当前公会捐献	
      god_repute = 0,                         %% 神界声望	
      ghost_repute = 0,                       %% 魔界声望	
      honor = 0,                              %% 荣誉	
      day_honor = 0,                          %% 日荣誉	
      kill_count = 0,                         %% 杀人数	
      day_kill_count = 0,                     %% 今日杀人数	
      pk_value = 0,                           %% pk值	
      is_hide = 0,                            %% 是否隐藏称号	
      title = 0,                              %% 称号	
      current_exp = 0,                        %% 当前经验	
      total_club_contribute = 0,              %% 总公会捐献	
      fit_equip_type = 0,                     %% 可装备盔甲类型	
      fit_weapon_type = 0,                    %% 可装武器类型	
      current_physical = 0,                   %% 当前体力	
      current_energy = 0,                     %% 当前精力	
      especial_status = 0,                    %% 特殊状态	
      bag_max_count = 0,                      %% 背包最大格子	
	  money = 0,							  %%  充值金额	
      yuan_bao = 0,                           %% 元宝	
      bind_yuan_bao = 0,                      %% 绑定元宝	
      copper = 0,                             %% 铜币	
      bind_copper = 0,                        %% 绑定铜币	
      client_config = 0,                      %% 客户端配置	
      team_id = 0,                            %% 队伍ID	
      life_experiences = 0,                   %% 历练	
      other_career_skill = 0,                 %% 其它职业技能	
      style_bin,                              %% % 保存人物样式  衣服 武器 坐骑 翅膀	
      pk_mode = 0,                            %% PK模式	
      is_horse = 0,                           %% 是否骑宠	
      depot_max_number = 0,                   %% 仓库格子最大数	
      depot_copper = 0,                       %% 仓库铜币	
      pk_mode_change_date = 0,                %% pk模式更新时间	
      hangup_setting = "",                    %% 挂机技能设置
	  escort_id = 0,					      %% 镖头编号	
      darts_left_time = 0,                    %% 拉镖剩余时间	
      today_escort_times = 0,                 %% 当天劫镖数数	
      escort_ref_date = 0,                    %% 劫镖刷新时间
      first_escort_date = 0,                  %% 当天第一次运镖时间	
      daily_award_date = 0,                   %% 最后取得日常奖励的时间	
      daily_award = [],                        %% 最近一次奖励领取状态	
      shenmo_times = 0,                       %% 神魔令每天使用次数	
      vip_id = 0,                             %% vip等级	
      vip_date = 0,                           %% vip到期日期	
      vip_yuanbao_date,                       %% vip上次每日领取时间	
      vip_money_date,                         %% vip上次每日领取时间	
      vip_buff_date,                          %% vip上次每日领取时间	
	  vip_refresh_date,						  %% vip状态上次有效处理时间
      vip_tranfer_shoes = 0,                  %% vip飞鞋数量	
      vip_bugle = 0,                  	      %% vip喇叭数量	
      veins_cd = 0,							  %% 筋脉升级CD时间
	  veins_fail_num = 0,					  %% 根骨失败次数
	  veins_acupoint_uping = 0,				  %% 正在升级中的穴位
      mounts_skill_books = [],				  %% 坐骑技能书列表
	  mounts_skill_books_luck = 0,    		  %% 坐骑技能书幸运值
	  pet_skill_books = [],				  	  %% 宠物技能书列表
	  pet_skill_books_luck = 0,    		  	  %% 宠物技能书幸运值
	  fight = 0,							  %% 战斗力
	  lottery_duplicate_id = 0,				  %% 离开副本后抽奖记录
	  achieve_data = 0,					      %% 角色成就值
	  seven_award_id = 0,					  %% 七天嘉年华全民奖励领取状态
	  seven_award2_id = 0,					  %% 七天嘉年华全民奖励领取状态
	  marry_id = 0,							  %% 结婚标记未结婚0，老公则保存自己的id，老婆则保存老公的id	
	  exchange_bind_yuanbao = 0,			  %% 用元宝兑换绑定元宝	    	
	  pet_battle_count = 10,						%%宠物斗坛剩余次数				
	  pet_battle_time = 0,				  %% 宠物斗坛剩余时间
	  shenyou_id = 0,						%%副本神游ID
	  shenyou_times = 0,					%%副本神游次数
	  shenyou_time = 0,					%%副本神游时间
	  shenyou_exp_pill = 0,				%%副本神游经验丹
      other_data                              %% 	
    }).	
	
%% 用户buff	
%% t_users_buffs ==> ets_users_buffs 	
-record(ets_users_buffs, {	
      user_id = 0,                            %% 用户id	
      template_id = 0,                        %% Buff模板ID	
      begin_date = 0,                         %% 出现时间	
      valid_date = 0,                         %% 上次生效时间	
      end_date = 0,                           %% 结束时间	
      type = 0,                               %% 1普通buff 2血包buff 3经验buff	
      total_value = 0,                        %% 总有效值	
      is_exist = 1,                           %% 是否存在	
      other_data                              %% 	
    }).	

%% 用户江湖令信息
%% t_user_token ==> ets_user_token
-record(ets_user_token, {
		user_id = 0,							%% 用户id	
		receive_log	= [0,0,0,0],				%% 接收历史记录
		publish_log	= [0,0,0,0],				%% 发布历史记录
		last_receive_time = 0,					%% 最后一次发布或接收时间
		receive_task_id = 0,					%% 接收任务品质(等级*10 + 品质)
		receive_num1 = 0,
		receive_num2 = 0,
		receive_num3 = 0,
		receive_num4 = 0						%% 橙色被领取次数
		}).

%% 玩家发布江湖令信息
%% t_token_publish_info ==> ets_token_publish_info
-record(ets_token_publish_info,{
							token_id = 0,			%% 江湖令唯一编号
							publish_user_id = 0,	%% 发布用户唯一编号
							publish_level = 40,		%% 发布用户发布时等级
							type = 0				%% 江湖令品质
							}).

%% 用户好友	
%% t_users_friends ==> ets_users_friends 	
-record(ets_users_friends, {	
      user_id = 0,                            %% 用户id	
      friend_id = 0,                          %% 好友id	
      state = 0,                              %% 友好状态 1=>好友 ,2=>黑名单,	
      date = 0,                               %% 添加日期	
      group_id = 1,                           %% 分组编号 默认为1	
      amity = 0,                           	  %% 友好度
      amity_level = 0,                        %% 友好度等级
      is_exist = 1,                           %% 是否存在	
      other_data                              %% 	
    }).	
	
%% 用户好友分组	
%% t_users_groups ==> ets_users_groups 	
-record(ets_users_groups, {	
      id,                                     %% 分组编号	
      user_id = 0,                            %% 用户编号	
      category_id = 0,                        %% 类别编号(已无效)	
      name = "",                              %% 分组名称	
      is_exist = 1,                           %% 是否存在	
      other_data                              %% 	
    }).	
	
%% 用户物品	
%% t_users_items ==> ets_users_items 	
-record(ets_users_items, {	
      id,                                     %% 物品id	
      user_id = 0,                            %% 用户id	
      template_id = 0,                        %% 物品模板id	
	  category_id = 0,							%% 物品类型
	  pet_id = 0,								%% 宠物id，物品被宠物装备的时候记录宠物的id
      bag_type = 1,                           %% 背包类型，1普通，11宠物，21储存	
      is_bind = 1,                            %% 是否绑定	
      strengthen_level = 0,                   %% 强化等级
	  fail_acount = 0,						  %%  强化失败次数	
      amount = 0,                             %% 数量	
      place = 0,                              %% 位置	
      create_date = 0,                        %% 出现时间	
      state = 0,                              %% 物品状态，怎么出现的	
      durable = 0,                            %% 耐久	
      enchase1 = -1,                          %% 镶嵌一	
      enchase2 = -1,                          %% 镶嵌二	
      enchase3 = -1,                          %% 镶嵌三	
      enchase4 = -1,                          %% 镶嵌四	
      enchase5 = -1,                          %% 镶嵌五	
	  enchase6 = -1,							%% 镶嵌六	
	  fight = 0,							  %% 战斗力
      data = "",                              %% 数据脚本	
      is_exist = 1,                           %% 是否存在	
      other_data                              %% 	
    }).	
	
%% 用户邮件	
%% t_users_mails ==> ets_users_mails 	
-record(ets_users_mails, {	
      id,                                     %% 邮件id	
      sender_id = 0,                          %% 发送ID	
      send_nick = "",                         %% 发送昵称	
      receiver_id = 0,                        %% 接收id	
      receiver_nick = "",                     %% 接收昵称	
      title = "",                             %% 标题	
      context = "",                           %% 内容	
      send_date = 0,                          %% 	
      is_read = 0,                            %% 是否已读	
      read_date = 0,                          %% 读取时间	
      copper = 0,                             %% 铜币	
      bind_copper = 0,                        %% 绑定铜币	
      yuan_bao = 0,                           %% 元宝	
      bind_yuan_bao = 0,                      %% 绑定元宝	
      attach1 = 0,                            %% 附件1	
      attach2 = 0,                            %% 附件2	
      attach3 = 0,                            %% 附件3	
      attach4 = 0,                            %% 附件4	
      attach5 = 0,                            %% 	
      attach_fetch = 0,                       %% 取附件标志	
      remark = "",                            %% 备注	
      type = 0,                               %% 邮件类型	
      valid_date = 0,                         %% 	
      is_exist = 1,                           %% 是否存在	
      other_data                              %% 	
    }).	
	
%% 人物技能快捷栏模板	
%% t_users_skill_bar ==> ets_users_skill_bar 	
-record(ets_users_skill_bar, {	
      user_id = 0,                            %% 人物ID	
      bar_index = 0,                          %% 快捷栏位置	
      type = 0,                               %% 	
      template_id = 0,                        %% 技能模板ID	
      group_id = 0,                           %% 技能组ID	
      other_data                              %% 	
    }).	
	
%% 人物技能	
%% t_users_skills ==> ets_users_skills 	
-record(ets_users_skills, {	
      user_id = 0,                            %% 人物ID	
      template_id = 0,                        %% 技能模板ID	
      begin_date = 0,                         %% 习得时间	
      valid_date = 0,                         %% 上次使用时间	
      is_exist = 1,                           %% 是否存在	
      lv = 0,                                 %% 级别（可不用）	
      other_data                              %% 	
    }).	
	
%% 用户任务	
%% t_users_tasks ==> ets_users_tasks 	
-record(ets_users_tasks, {	
      user_id = 0,                            %% 用户id	
      task_id = 0,                            %% 任务id	
      state = 0,                              %% 任务状态	
      require_count = <<"''">>,               %% 任务条件	
      repeat_count = 0,                       %% 能重复次数	
      is_finish = 0,                          %% 是否完成	
      finish_date = 0,                        %% 完成时间	
      is_trust = 0,                           %% 是否委托	
      trust_end_time = 0,                     %% 委托结束时间	
      trust_count = 0,                        %% 委托次数	
      is_exist = 1,                           %% 是否放弃	
      other_data                              %% 	
    }).	
	
%% 玩家副本表	
%% t_users_duplicate ==> ets_users_duplicate 	
-record(ets_users_duplicate, {	
      user_id = 0,                            %% 玩家id	
      duplicate_id = 0,                       %% 副本id	
      sum_num = 0,                            %% 总数	
      today_num = 0,                          %% 今天完成次数
	  reset_num = 0,						  %% 重置副本次数	
      last_time = 0,                          %% 最后一次时间	  
      other_data = 0                          %% 	
    }).	

%%副本神游表
%% t_shenyou_template ==> ets_shenyou_template 	
-record(ets_shenyou_template, {	
	id =0,										%%ID = 副本ID + 层数 - 1
	duplicate_id = 0,						%%副本ID
	floor = 0,									%%层数
	level = 0,									%%所需等级
	fight = 0,									%%所需战斗力
	cost_copper = 0,						%%花费铜币
	cost_time = 0,							%%花费时间
	cost_yuanbao = 0,						%%花费元宝
	copper = 0,								%%获得铜币
	exp = 0,									%%获得经验
	life_exp = 0,								%%获得历练
	item_ids = []								%%道具奖励
	}).

%% 宠物基础属性模板表	
%% t_pets_attr_template ==> ets_pets_attr_template 	
-record(ets_pets_attr_template, {	
      template_id = 0,                        %% 宠物模板Id	
      level = 0,                              %% 等级	
      attack = 0,                             %% 攻击	
      defence = 0,                            %% 防御	
      duck = 0,                               %% 闪避	
      hit_target = 0,                         %% 命中	
      attack_q = 0,                           %% 攻击资质	
      defence_q = 0,                          %% 防御资质	
      duck_q = 0,                             %% 闪避资质	
      hit_target_q = 0,                       %% 命中资质	
      update_exp = 0,                         %% 升级所需经验	
      total_exp = 0                           %% 升级总经验	
    }).	
	
%% 帮会表	
%% t_guilds ==> ets_guilds 	
-record(ets_guilds, {	
      id,                                     %% 帮会id	
      guild_name,                             %% 帮会名称	
      guild_level = 0,                        %% 帮会级别	
      master_id,                              %% 管理员编号
      master_name,                            %% 管理员名字	
      master_type,							  %% 管理员VIP等级
      camp = 0,                               %% 阵营	
      maintain_fee = 0,                       %% 维护费用
      activity = 0,                           %% 活跃度	
      money = 0,                              %% 帮会财富
      current_vice_master_member = 0,         %% 当前副会长人员数
      current_honorary_member = 0,            %% 当前长老会员数
      total_member = 0,               		  %% 当前会员总数
      requests_number = 0,                    %% 申请数	
      declaration,                            %% 宣言	
      corps_declaration = "",                 %% 军团宣言	
      qq,                                     %% qq	
      yy,                                     %% yy	
      camps_number = 0,                       %% 军团数	
      enemy_clubs,                            %% 敌对阵营	
      create_date = 0,                        %% 创建时间	
      today_send_mails = 0,                   %% 当天已发邮件	
      last_send_date = 0,                     %% 当天第一次发送邮件时间
	  summon_collect_num = 0,				   %% 当天召唤采集次数
	  summon_monster_num = 0,				   %% 当天召唤boss次数
      last_guild_transport = 0,               %% 上帮派开启运镖时间	
      furnace_level = 0,					  %% 帮会神炉等级
      shop_level = 0,						  %% 帮会商店等级
	  rank = 0,								  %% 排名
      other_data                              %% 	
    }).	
	
%% 帮会升级模板表	
%% t_guilds_template ==> ets_guilds_template 	
-record(ets_guilds_template, {	
      guild_level = 0,                        %% 帮会级别	
      need_contribute = 0,                    %% 升级需要贡献	
      need_activity = 0,                      %% 升级需要活跃度	
      need_money = 0,                         %% 财富
      vice_master_member = 0,                 %% 副会长会员数
      honorary_member = 0,                    %% 长老会员数
      total_member = 0,						  %% 总会员数
      maintain_fee = 0,						  %% 维护费用
      total_requests_number = 0,              %% 申请数
      total_mails = 0                         %% 每天可发邮件数	
    }).	
%% 帮会活动召唤模版表
%% t_guild_summon_template ==> ets_guild_summon_template
-record(ets_guild_summon_template, {		
		id = 0,				%%自增编号
		type = 0,			%%召唤类型0,boss 1,采集物
		summon_list = [],	%%召唤列表 用逗号分隔
		name = "",			%%名字
		level = 0,			%%等级
		guild_level = 0,	%%公会需求等级
		dorp = "",			%%显示掉落内容
		remark = "",		%%介绍
		guild_money = 0		%%召唤条件
	}).
%% 帮会祈福召唤模版表
%% t_guild_prayer_template ==> ets_guild_prayer_template
-record(ets_guild_prayer_template,{
		id = 0,				%%唯一编号
		item_id = 0,		%%奖励物品模版编号
		amount = 0,			%%奖励数量
		rate = 0			%%获得概率
	}).

%% 帮会神炉等级模板表
%% t_guilds_furnace_leve_template ==> ets_guilds_furnace_leve_template 	
-record(ets_guilds_furnace_leve_template, {	
      furnace_level = 0,                      %% 帮会神炉等级
      need_club_level = 0,                    %% 升级需要帮会等级
      need_money = 0,                     	  %% 升级需要帮会财富
	  description = 0                   	  %% 当前效果描述
    }).	
    
%% 帮会商城等级模板表
%% t_guilds_shop_leve_template ==> ets_guilds_shop_leve_template 	
-record(ets_guilds_shop_leve_template, {	
      shop_level = 0,                         %% 帮会商城等级
      need_club_level = 0,                    %% 升级需要帮会等级
      need_money = 0                          %% 升级需要帮会财富
    }).	
	
%% 帮会军团表	
%% t_guilds_corps ==> ets_guilds_corps 	
-record(ets_guilds_corps, {	
      id,                                     %% 军团id	
      corp_name,                              %% 帮会名	
      guild_id = 0,                           %% 帮会id	
      leader_id = 0,                          %% 用户id	
      member_number = 0,                      %% 成员数	
      build_date = 0,                         %% 建立日期	
      avg_level = 0,                          %% 平均等级	
      other_data                              %% 	
    }).	
	
%% t_guilds_logs	
%% t_guilds_logs ==> ets_guilds_logs 	
-record(ets_guilds_logs, {	
      id,                                     %% 编号	
      guild_id = 0,                           %% 帮会id	
      log_type = 0,                           %% 日志类型	
      log_content = "",                       %% 日志内容	
      log_date = 0,                           %% 创建日期	
      other_data                              %% 	
    }).	
	
%% t_guilds_items	
%% t_guilds_items ==> ets_guilds_items 	
-record(ets_guilds_items, {	
      item_id = 0,                            %% 物品ID	
      guild_id = 0,                           %% 帮会id	
      put_date = 0,                           %% 放入日期	
      other_data = ""                         %% 	
    }).	


%% t_guilds_items_request	
%% t_guilds_items_request ==> ets_guilds_items_request
-record(ets_guilds_items_request, {	
	  id = 0,								  %% 申请id
	  user_id = 0,							  %% 玩家编号
      item_id = 0,                            %% 物品ID	
      guild_id = 0,                           %% 帮会id	
      request_date = 0,                       %% 放入日期	
	  is_exist = 1,							  %% 是否存在
      other_data                          %% 	
    }).	
	
%% 用户帮会信息	
%% t_users_guilds ==> ets_users_guilds 	
-record(ets_users_guilds, {	
      user_id = 0,                            %% 用户id		
      guild_id = 0,                           %% 工会id	
      member_type = 0,                        %% 用户类型	
      corp_id = 0,                            %% 军团id	
      corp_job = 0,                           %% 军团工作	
      join_date = 0,                          %% 加入时间	
      current_feats = 0,                      %% 当前贡献
      total_feats = 0,					      %% 总贡献
      today_feats = 0,                        %% 当天贡献 暂时不用
      is_exists = 1,                          %% 是否在帮内，退出为0	
      get_weal_date = 0,                      %% 上次获取福利时间	
      other_data = ""                         %% 	
    }).	
	
%% 帮会用户申请/邀请记录	
%% t_users_guilds_request ==> ets_users_guilds_request 	
-record(ets_users_guilds_request, {	
      user_id = 0,                            %% 用户id	
      guild_id = 0,                           %% 工会id	
      request_date = 0,                       %% 邀请时间	
      other_data                              %% 	
    }).	
	
%% 人物称号模板表	
%% t_title_template ==> ets_title_template 	
-record(ets_title_template, {	
      id,                                     %% 	
      name = "",                              %% 名称	
      type = 0,                               %% 类型	
	  effec_time = 0,						  %% 有效时间
      describe = "",                          %% 描述	
      character = 0,                          %% 品质	
      data = [],                                   %% 附加效果	
      pic,                                    %% 图片
      other_data                              %% 其它数据	
    }).	
	
%% 用户寄售表	
%% t_users_sales ==> ets_users_sales 	
-record(ets_users_sales, {	
      id,                                     %% 编号	
      type = 0,                               %% 上架类型(物品/货币)	
      user_id = 0,                            %% 用户id	
      item_id = 0,                            %% 物品id	
      name = "",                              %% 物品名称	
	  category = 0,                           %% 物品种类
	  career = 0,                             %% 职业		
      level = 0,                              %% 物品等级	
      quality = 0,                            %% 物品品质	
      unit_price = 0,                         %% 物品单价/货币总价	
      price_type = 0,                         %% 价格类型(元宝/铜币)	
      amount = 0,                             %% 物品数量/货币数量	
      start_time = 0,                         %% 开始时间	
      valid_time = 0,                         %% 有效时长(单位：小时)	
      is_exist = 1,                           %% 记录是否存在	
      other_data                              %% 	
    }).	
	
%% 采集模板	
%% t_collect_template ==> ets_collect_template 	
-record(ets_collect_template, {	
      template_id = 0,                        %% 模板id	
      name = <<"0">>,                         %% 名字	
      descript = <<"0">>,                     %% 描述	
      type,                                   %% 采集类型：0消亡，1普通采集，2任务物品	
      min_level,                              %% 人物最小等级	
      max_level,                              %% 人物最大等级	
      award_hp,                               %% 奖励HP	
      award_mp,                               %% 奖励MP	
      award_life_experiences,                 %% 奖励历练	
      award_exp,                              %% 奖励经验	
      award_yuan_bao,                         %% 奖励元宝	
      award_bind_yuan_bao = 0,                %% 绑定元宝	
      award_bind_copper,                      %% 奖励绑定铜币	
      award_copper,                           %% 奖励铜币	
      award_item = 0,                         %% 奖励物品	
      collect_time,                           %% 采集需要时间	
      reborn_time,                            %% 重生时间	
      pic_patch,                              %% 图片名	
      map_id,                                 %% 所在地图	
      local_point,                            %% 中心点	
      lbornl_points,                          %% 出生点				
      quality = 0,                            %% 品质	
      script = <<"0">>,                       %% 脚本
	  can_reborn = 1,						  %%复活类型(0:不能复活,1:能复活)
	  destruct_time = 0						  %%自毁时间(0,永远不会消失) 		
    }).	
	
%% t_daily_award_template	
%% t_daily_award_template ==> ets_daily_award_template 	
-record(ets_daily_award_template, {	
      award_id = 0,                           %% 奖励id	
      need_seconds = 0,                       %% 需要时间，单位秒	
      copper = 0,                             %% 非绑定铜币	
      bind_copper = 0,                        %% 绑定铜币	
      yuan_bao = 0,                           %% 元宝	
      bind_yuan_bao = 0,                      %% 绑定元宝	
      item_template_ids = []                   %% 物品模板id	
     
    }).	
	
%% t_monster_drop_item_template	
%% t_monster_drop_item_template ==> ets_monster_drop_item_template 	
-record(ets_monster_drop_item_template, {	
      monster_template_id = 0,                %% 怪物模板id	
      drop_times = 0,                         %% 掉落次数	
      item_template_id = 0,                   %% 物品模板id	
      drop_rate = 0,                          %% 掉落几率	
      drop_number = 0,                        %% 掉落数量	
      isbind = 0                              %% 拾取绑定	
    }).	
	
%% t_boss_activity_template	
%% t_boss_activity_template ==> ets_activity_boss_template 	
-record(ets_activity_boss_template, {	
      id,                                     %% 编号	
      flash_time = 0,                         %% 播放时间	
      descript,                               %% 描述	
      equip_level = 1,                        %% 装备等级	
      awards                                  %% 奖励	
    }).	
	
%% t_task_activity_template	
%% t_task_activity_template ==> ets_activity_task_template 	
-record(ets_activity_task_template, {	
      id = 0,                                 %% 编号	
      descript,                               %% 描述	
      exp_level = 0,                          %% 经验等级	
      award                                   %% 奖励	
    }).	
	
%% t_vip_template	
%% t_vip_template ==> ets_vip_template 	
-record(ets_vip_template, {	
      vip_id = 0,                             %% vip id	
      vip_name = "",                          %% vip等级名称	
      effect_date = 0,                        %% 有效时间，以日为单位	
      yuanbao = 0,                            %% 每日元宝	
      money = 0,                              %% 每日铜币
      buffs = "",                             %% 每日BUG
      tranfer_shoe = 0,                       %% 飞鞋	
      bugle = 0,                      		  %% 喇叭
      exp_rate = 0,                           %% vip经验加成，除以100	
      strength_rate = 0,                      %% 强化增加成功率，除以100	
	  drop_rate = 0,						  %% 副本爆率，除以100	
      hole_rate = 0,                          %% 开孔加成	
      lifeexp_rate = 0,                       %% 历练加成	
      mounts_stair_rate = 0,                  %% 坐骑进阶成功率提高
      pet_stair_rate = 0,                     %% 宠物资质提升成功率提高
      title_id = 0,                           %% 称号
	  vein_rate = 0,						  %% 根骨增加成功率
	  items = ""							  %% 使用时奖励物品
	  
    }).	
	
	
%% t_shop_discount	
%% t_shop_discount ==> ets_shop_discount 	
-record(ets_shop_discount, {	
      shop_id = 0,                            %% 优惠商品ID	
      surplus_count = 0,                      %% 剩余数量	
      finish_time = 0,                        %% 优惠结束时间	
      other_data = ""                         %% 	
    }).	
	
%% t_free_war_award_template	
%% t_free_war_award_template ==> ets_free_war_award_template 	
-record(ets_free_war_award_template, {	
      level = 0,                              %% 等级	
      index = 0,                              %% 排名	
      template_id = 0,                        %% 物品模板id	
      amount = 0,                             %% 数量	
      is_bind = 0                             %% 是否绑定 1是 0 否	
    }).	
 	
 	
%% 坐骑模板表	
%% t_mount_template ==> ets_mount_template 	
-record(ets_mounts_template, {	
      template_id = 0,                            %% 	
      level = 0,                              %% 等级
      speed = 0,                              %% 速度	
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
      up_quality = 0,                         %% 资质上限
      up_grow_up = 0,                         %% 成长上限
	  quality = 0							  %% 品质
    }).	

%% 坐骑品阶模板表	
-record(ets_mounts_stairs_template, {	
      template_id = 0,                            %% 	
      stairs = 0,
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
	  up_quality = 0,                         %% 资质上限
      up_grow_up = 0                          %% 成长上限
    }).	

%% 坐骑洗练模版表
-record(ets_mounts_refined_template, {	
      template_id = 0,                        %% 坐骑templateId	
      level = 0,							  %% 坐骑等级
      total_hp = 0,                           %% 生命	
      total_mp = 0,                           %% 法力	
      attack = 0,                             %% 攻击	
      defence = 0,                            %% 防御	
      property_attack = 0,					  %% 属攻
      magic_defence = 0,                      %% 魔法防御	
      far_defence = 0,                        %% 远程防御	
      mump_defence = 0                       %% 斗气防御	
    }).	 
	
	
%% 坐骑经验模板表	
%% t_mount_exp_template ==> ets_mount_exp_template 	
-record(ets_mounts_exp_template, {	
      level = 0,                                  %% 	
      exp = 0,                                %% 升级需要经验	
      total_exp                               %% 总升级经验	
    }).	
	
%% 坐骑品质模板表	
%% t_mounts_quality_template ==> ets_mounts_quality_template 	
-record(ets_mounts_quality_template, {	
      quality = 0,                            %% 品质	
      modulus = 0                                 %% 系数	
    }).	
	
%% 坐骑资质模板表	
%% t_mount_qualification_template ==> ets_mount_qualification_template 	
-record(ets_mounts_qualification_template, {	
      template_id = 0,                            %% 	
      qualification = 0,
      magic_attack = 0,                       %% 魔法攻击	
      far_attack = 0,                         %% 远程攻击	
      mump_attack = 0,                        %% 斗气攻击	
      magic_defense = 0,                      %% 魔法防御	
      far_defense = 0,                        %% 远程防御	
      mump_defense = 0                        %% 斗气防御	
    }).	
	
%% 坐骑成长模板表	
%% t_mount_grow_up_template ==> ets_mount_grow_up_template 	
-record(ets_mounts_grow_up_template, {	
      template_id  = 0,                            %% 模板ID	
      grow_up = 0,
      total_hp = 0,                           %% 生命	
      total_mp = 0,                           %% 法力	
      attack = 0,                             %% 攻击	
      defence = 0                             %% 防御	
    }).	

%% 技能书概率表	
%% t_mount_skill_rate_template ==> ets_mount_skill_rate_template 	
-record(ets_mounts_skill_rate_template, {	
      id = 0,                                     %% 	
      rate = 0,                                   %% 出现几率	
      template_id = 0                         %% 模板ID	
    }).	

%% 坐骑星级模板表	
%% t_mounts_star_template ==> ets_mounts_star_template 	
-record(ets_mounts_star_template, {	
      template_id,                            %% 	
      star = 0,                               %% 星级	
      magic_attack = 0,                       %% 魔法攻击	
      far_attack = 0,                         %% 远程攻击	
      mump_attack = 0,                        %% 斗气攻击	
      magic_defense = 0,                      %% 魔法防御	
      far_defense = 0,                        %% 远程防御	
      mump_defense = 0                        %% 斗气防御	
    }).	
	
%% 坐骑钻级模板表	
%% t_mounts_diamond_template ==> ets_mounts_diamond_template 	
-record(ets_mounts_diamond_template, {	
      template_id,                            %% 模板ID	
      diamond = 0,                            %% 钻级	
      total_hp = 0,                           %% 生命	
      total_mp = 0,                           %% 法力	
      attack = 0,                             %% 攻击	
      defence = 0                             %% 防御	
    }).	

	
%% 坐骑表	
%% t_users_mounts ==> ets_users_mounts 	
-record(ets_users_mounts, {	
      id,                                     %% 坐骑Id	
      user_id = 0,                            %% 用户Id	
      template_id = 0,                        %% 模板ID	
      name = "",                              %% 昵称	
      stairs = 0,                             %% 品阶	
      level = 0,                              %% 宠物等级	
      exp = 0,                                %% 经验	
      current_quality = 0,                    %% 当前资质	
      current_grow_up = 0,                    %% 当前成长	
	  fight = 0,                    		  %% 战斗力
      state = 0,                              %% 出战状态（1，出战；0未出战）	
      is_exit = 1,                            %% is_exit
	  current_refined = 0,					  %% 当前洗练等阶	
	  random_refined = "0,0,0,0,0,0,0,0",	%% 洗练当前等阶增加的随机属性
      other_data = ""                         %% 其他数据	
    }).
	
%% 坐骑技能表	
%% t_users_mounts_skill ==> ets_users_mounts_skill 	
-record(ets_users_mounts_skill, {	
      id = 0,                                 %% 坐骑Id	
      template_id = 0,                        %% 技能模板Id	
	  lv = 0,
	  study_time = 0,
      is_exist = 1,                           %% 是否存在	
      other_data = ""                         %% other_data	
    }).	


%% 宠物星级模板表
%% t_pet_star_template ==> ets_pet_star_template 	
-record(ets_pet_star_template, {	
      template_id,                            %% 模板ID	
      star = 0,                            	  %% 星级	
      attack = 0,                             %% 攻击
      hit = 0                         		  %% 命中
    }).

%% 宠物钻级模板表	
%% t_pet_diamond_template ==> ets_pet_diamond_template 	
-record(ets_pet_diamond_template, {	
      template_id,                            %% 模板ID	
      diamond = 0,                            %% 钻级	
      magic_attack = 0,                       %% 魔法攻击	
      far_attack = 0,                         %% 远程攻击	
      mump_attack = 0,                        %% 斗气攻击	
      power_hit = 0                           %% 防御	
    }).	
	
%% 宠物经验模板表	
%% t_pet_exp_template ==> ets_pet_exp_template 	
-record(ets_pet_exp_template, {	
      level,                                  %% 	
      exp = 0,                                %% 升级需要经验	
      total_exp                               %% 总升级经验	
    }).	

%% 宠物资质经验模板表
%% t_pet_qualification_exp_template ==> ets_pet_qualification_exp_template 	
-record(ets_pet_qualification_exp_template, {	
      level,                                  %% 	
      exp = 0,                                %% 升级需要经验	
      total_exp                               %% 总升级经验	
    }).	


%% 宠物成长经验模板表
%% t_pet_grow_up_exp_template ==> ets_pet_grow_up_exp_template 	
-record(ets_pet_grow_up_exp_template, {	
      level,                                  %% 	
      exp = 0,                                %% 升级需要经验	
      total_exp                               %% 总升级经验	
    }).	
	
%% 宠物成长模板表	
%% t_pet_grow_up_template ==> ets_pet_grow_up_template 	
-record(ets_pet_grow_up_template, {	
      template_id,                            %% 模板ID	
      grow_up,                                %% 	
      attack = 0,                             %% 攻击	
      hit = 0,                                %% 法力	
      power_hit = 0                           %% 防御	
    }).	
	
%% 宠物资质模板表	
%% t_pet_qualification_template ==> ets_pet_qualification_template 	
-record(ets_pet_qualification_template, {	
      template_id,                            %% 	
      qualification = 0,                      %% 资质	
      magic_attack = 0,                       %% 魔法攻击	
      far_attack = 0,                         %% 远程攻击	
      mump_attack = 0,                        %% 斗气攻击	
      hit = 0,                                %% 命中
      power_hit = 0                           %% 暴击
    }).	
	
%% 宠物品阶模板表	
%% t_pet_stairs_template ==> ets_pet_stairs_template 	
-record(ets_pet_stairs_template, {	
      template_id,                            %% 	
      stairs = 0,                             %% 	
      attack = 0,                             %% 攻击	
      magic_attack = 0,                       %% 魔法攻击	
      far_attack = 0,                         %% 远程攻击	
      mump_attack = 0,                        %% 斗气攻击	
      hit = 0,                                %% 命中
      power_hit = 0,                          %% 暴击
      up_quality = 0,                         %% 资质上限	
      up_grow_up = 0                          %% 成长上限	
    }).	
	
%% 宠物模板表	
%% t_pet_template ==> ets_pet_template 	
-record(ets_pet_template, {	
      template_id,                            %% 	
      name,                                   %% 名称	
      level,                                  %% 等级	
      attack = 0,                             %% 攻击	
      magic_attack = 0,                       %% 魔法攻击	
      far_attack = 0,                         %% 远程攻击	
      mump_attack = 0,                        %% 斗气攻击	
      power_hit = 0,                          %% 暴击
      hit = 0,                                %% 命中
      up_quality = 0,                         %% 资质上限	
      up_grow_up = 0                          %% 成长上限	
    }).	

%% 宠物斗坛记录	
%% t_pet_battle ==> ets_pet_battle 	
-record(ets_pet_battle, {	
      pet_id= 0,                                     %% 宠物Id	
      user_id = 0,                            %% 用户Id	
      template_id = 0,                        %% 模板ID	
      replace_template_id = 0,                %% 换形符模板Id	
      name = "",                              %% 昵称	
      fight = 0,                    		  %% 战斗力
	  quality = 0,                            %% 品质
      level = 0,                              %% 宠物等级	
      stairs = 0,                             %% 品阶	
	  top=0,											%%排行榜
      win = 0,									%%胜场
      total = 0,								%%总场次
      winning =0,								%%连胜
      skill_list = [],                         %% 技能列表	
	  yesterday_top = 0				%%前一天排行
    }).	

%% 宠物表	
%% t_users_pets ==> ets_users_pets 	
-record(ets_users_pets, {	
      id,                                     %% 宠物Id	
      user_id = 0,                            %% 用户Id	
      template_id = 0,                        %% 模板ID	
	  quality = 0,                            %% 品质
      type = 0,                               %% 类型(属攻类型)	
      replace_template_id = 0,                %% 换形符模板Id	
      name = "",                              %% 昵称	
      fight_time = 0,                         %% 出战时间（用于升级）	
      energy = 0,                             %% 饱食度	
      energy_time = 0,                        %% 饱食度更新时间
      stairs = 0,                             %% 品阶	
      level = 0,                              %% 宠物等级	
      exp = 0,                                %% 经验	
      quality_exp = 0,                        %% 资质经验
      grow_exp = 0,                           %% 成长经验
      current_quality = 0,                    %% 当前资质	
      current_grow_up = 0,                    %% 当前成长	
      fight = 0,                    		  %% 战斗力
      state = 0,                              %% 出战状态（1，出战；0未出战）	
      is_exit = 1,                            %% is_exit	
      other_data = ""                         %% 其他数据	
    }).	
	
%% 宠物技能表	
%% t_users_pets_skills ==> ets_users_pets_skills 	
-record(ets_users_pets_skills, {	
      id = 0,                                 %% 坐骑Id	
      template_id = 0,                        %% 技能模板Id	
	  lv = 0,
	  study_time = 0,
      is_exist = 1,                           %% 是否存在	
      other_data = ""                         %% other_data	
    }).	

%% 系统公告表	
%% t_sys_msg ==> ets_sys_msg 	
-record(ets_sys_msg, {	
      id = 0,                                 %% Id	
      msg_type = 1,                        	  %% 系统公告的类型：现默认为1
	  send_type = 1,						  %% 发送类型:1.立即消息,2.时间间隔
	  start_time = 0,						  %% 公告开始时间
      end_time = 0,                           %% 公告结束时间
      interval = 0,							  %% 间隔时间
      content = "",							  %% 公告内容
	  edit_time = 0,						  %% 公告最后编辑时间
      other_data = ""                         %% other_data	
    }).	
%% 银行投资
%% t_user_bank ==> ets_user_bank
-record(ets_user_bank, {
		user_id = 0,						%% 用户id
		type = 0,							%% 投资类型
		money = 0,							%% 投资总金额
		state = 0,							%% 领取收益状态
		add_time = 0						%% 开始投资时间
	}).

%% 目标模板表	
%% t_target_template ==> ets_target_template 	
-record(ets_target_template, {	
      target_id = 1,                          %% 编号	
	  pic = 0,								  %% 图标
      type = 0,                               %% 类型0:目标  1: 成就	
      class,                                  %% 	
      is_cumulation = 0,                      %% 是否累记	
      title_id = 0,                      	  %% 称号编号
      title = "",                             %% 标题	
      content = "",                           %% 内容	
      tip = "",                               %% 	
      condition = 0,                          %% 目标条件	
      data = "",                              %% 脚本	
      client_count = 0,						  %% 客户端数量
      awards = "",                            %% 目标奖励	
      award_yuan_bao = 0,                     %% 奖励铜币	
      award_achievement = 0,                  %% 奖励成就值	
      award_data = 0,                        %% 奖励属性	
      finish_event = "",                      %% 状态完成事件	
      other_data = ""                         %% 	
    }).	


	
%% 用户目标数据	
%% t_users_targets ==> ets_users_targets 	
-record(ets_users_targets, {	
      user_id = 1,                            %% 用户id	
      target_id = 1,                          %% 目标id	
      data = 0,								  %% 完成数
	  type = 0,								  %% 类型
      is_finish = 1,                          %% 是否完成	
	  is_receive = 0,					      %% 是否领取
      finish_date = 0,                        %% 完成时间	
      other_data = ""                         %% 	
    }).	

%% 友好度模板表	
%% t_amity_template ==> ets_amity_template 	
-record(ets_amity_template, {	
      level =1 ,                              %% 友好度等级	
      amity,                                  %% 友好度值	
      total_amity,                            %% 总友好度值	
      name,                                   %% 友好度等级名称	
      data,                                   %% 属性	
      other_data = ""                         %% 	
    }).



%% 开服活动模板表	
%% t_activity_open_server_template ==> ets_activity_open_server_template 	
-record(ets_activity_open_server_template, {	
      id,                                     %% 编号	
      group_id,                               %% 活动组编号1:首充2:开服充值3:开服消费4,冲级,	
      is_open = 0,                            %% 是否开放	
      type = 0,                               %% 活动类型0:充值1:消耗,2:升级,	
      time_type = 0,                          %% 活动时间类型0:具体时间1:开服之后几天,,	
      open_time = "",                         %% 开放时间	
      start_time = 0,                         %% 活动开始时间	
      end_time = 0,                           %% 活动结束时间	
      is_cumulation = 0,                      %% 是否累记	
      need_num = 0,                           %% 活动累计数量	
      item = 0,                               %% 活动奖励	
      other_data = ""                         %% 	
    }).	

%% 开服活动
%% t_users_open_server ==> ets_users_open_server 	
-record(ets_users_open_server, {	
      user_id,                                %% 用户编号	
      group_id,                               %% 活动组编号	
      type = 0,                               %% 活动类型0:充值1:消耗,	
      num = 0,                                %% 数量	
      rewards_ids,                            %% 是否已经领奖	
      last_date=0,                            %% 是否已经领奖	
      other_data = ""                         %% 	
    }).	

%% 黄钻礼包	
%% t_yellow_box_template ==> ets_yellow_box_template 	
-record(ets_yellow_box_template, {	
      id,                                     %% 	
      type = 0,                               %% 类型0.每日礼包,1,每日年费礼包,2,豪华礼包,3升级礼包,4升级黄钻礼包,5,新手礼包,	
      level = 0,                              %% 等级每日礼包对应的黄钻等级,升级礼包对应人物等级,	
      awards_type = 0,                        %% 奖励类型:0物品1:属性,	
      awards = "",                            %% 黄钻奖励	
      other_data = ""                         %% other_data
    }).	

%% 排行榜查询配置表
%% t_top_config ==> ets_top_config
-record(ets_top_config,{
		id = 0,
    	type = 0,
		sql_update = "",				%% 统计脚步
		sql_selecet = "",				%% 查询脚步
		exc_time = 0,
		top_mame = ""
	}).

	
%% 7天活动模板表		
%% t_activity_seven_template ==> ets_activity_seven_template 	
-record(ets_activity_seven_template, {	
      id,                                     %% 编号	
      title,                                  %% 标题	
      content,                                %% 内容	
      awards,                                 %% 奖励	
      item,                                   %% 全民奖励
	  count,
      end_time,                               %% 结束时间	
      other_data = ""                         %% 	
    }).	

%% 7天活动数据	
%% t_activity_seven_data ==> ets_activity_seven_data 	
-record(ets_activity_seven_data, {	
      id = 0,                                 %% 编号	
      top_three = "",                         %% 当前前三名	
      is_end = 0                              %% 是否已结束	
    }).	

	
%% 神秘商店模板表	
%% t_smshop_template ==> ets_smshop_template 	
-record(ets_smshop_template, {	
      id,                                     %% 	
      rate,                                   %% 出现几率	
      template_id,                             %% 物品id	
      amount,                                 %% 数量	
      pay_type,                               %% 支付类型	
      price,                                  %% 价格	
      is_bind,                                %% 是否绑定	
      modulus                                 %% 珍贵系数	
    }).	

%% 神秘商店	
%% t_users_smshop ==> ets_users_smshop 	
-record(ets_users_smshop, {	
      user_id = 0,                            %% 用户编号	
      items_list = "",                        %% 物品信息
      vip_ref_times = 0,                      %% VIP刷新次数	
      vip_ref_date = 0,                      %% VIP刷新时间	
      last_ref_date = 0                      %% 最后刷新时间	
    }).	
 	
%%王城战信息
-record(ets_king_war_info,{
				id = 0,
				attack_guild_id = 0, 	%% 攻方公会Id
				attack_guild_name = "", 	%% 攻方公会名字
				defence_guild_id = 0,	%% 守方公会Id
				defence_guild_name = "",	%% 守方公会名字
				city_master = "",			%%城主名字
				days = 0,		%% 王城占领天数
				guard_list = []		%%守卫列表
				}).

-endif. % TABLE_TO_RECORD		
