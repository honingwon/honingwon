%%-----------------------------------------------
%%此文件用于保存氏族日志的内容信息
%%如果需要添加事件，可根据类型在其后面续加
%%直接定义为宏
%%-----------------------------------------------
-define(GUILD_MEMBER, "一般族员").
-define(DEPUTY_CHIEF, "长老").
-define(CHIEF, "族长").
%%定义加入氏族或创建氏族的最小等级(包括该等级)
-define(CREATE_GUILD_LV, 20).
%%氏族申请最大限制人数
-define(GUILD_APPLY_NUM_LIMIT, 30).
%%定义氏族初始化的时候的技能点
-define(GUILD_SKILL_INIT, 2).
%%退出氏族后重新加入新氏族的时间限制
-define(QUIT_GUILD_TIME_LIMIT, 43200).
%%一般弟子的堂ID
-define(NOMAL_GUILD_MEMBER,5).

%%%%%%%%%%%%事件类型：加入氏族%%%%%%%%%%%%
-define(CREATE_GUILD_ONE, "恭喜，").
-define(CREATE_GUILD_TWO, "创建了名为").
-define(CREATE_GUILD_THREE, "的氏族！").
-define(JOIN_GUILD_ONE, "欢迎").
-define(JOIN_GUILD_TWO, "加入氏族").

%%%%%%%%%%%%事件类型：退出氏族氏族%%%%%%%%%%%%
-define(QUIT_GUILD, "遗憾地退出了氏族！").
-define(KICKOUT_GUILD_ONE, "表现不佳，被").
-define(KICKOUT_GUILD_TWO, "开除出氏族！").

%%%%%%%%%%%%事件类型：捐献铜币%%%%%%%%%%%%
-define(DONATE_MONEY_ONE, "慷慨地捐献了").
-define(DONATE_MONEY_TWO, "铜币").

%%%%%%%%%%%%事件类型：职位变化%%%%%%%%%%%%
-define(PROMOTION_ONE, "贡献卓越，被").
-define(PROMOTION_TWO,"提拔为").
-define(DEMOTION_ONE, "玩疏职守，被").
-define(DEMOTION_TWO, "降为").
-define(DEMISE_CHIEF_ONE, "出于战略考虑，").
-define(DEMISE_CHIEF_TWO, "将族长之位传让给").
-define(POSITION_CHANGE_ONE, "被").
-define(POSITION_CHANGE_TWO, "任命为").

%%%%%%%%%%%%事件类型：氏族活动%%%%%%%%%%%%


%%%%%%%%%%%%  氏族技能等级描述   %%%%%%%%%%%%
-define(GUILD_SKILL_DESC, 
		[{{1, 0}, "<font color=\"#FFFF00\">当前拥有0个格子。</font><br /><font color=\"#FF0000\">氏族仓库用于存放氏族成员物品的空间。每升1级，格子数增加25。</font> <br /><font color=\"#FFFF00\">最高等级为5，最多可拥有125格。</font>"},
		 {{1, 1}, "<font color=\"#FFFF00\">当前拥有25个格子。</font><br /><font color=\"#FF0000\">氏族仓库用于存放氏族成员物品的空间。每升1级，格子数增加25。</font> <br /><font color=\"#FFFF00\">最高等级为5，最多可拥有125格。</font>"},
		 {{1, 2}, "<font color=\"#FFFF00\">当前拥有50个格子。</font><br /><font color=\"#FF0000\">氏族仓库用于存放氏族成员物品的空间。每升1级，格子数增加25。</font> <br /><font color=\"#FFFF00\">最高等级为5，最多可拥有125格。</font>"},
		 {{1, 3}, "<font color=\"#FFFF00\">当前拥有75个格子。</font><br /><font color=\"#FF0000\">氏族仓库用于存放氏族成员物品的空间。每升1级，格子数增加25。</font> <br /><font color=\"#FFFF00\">最高等级为5，最多可拥有125格。</font>"},
		 {{1, 4}, "<font color=\"#FFFF00\">当前拥有100个格子。</font><br /><font color=\"#FF0000\">氏族仓库用于存放氏族成员物品的空间。每升1级，格子数增加25。</font> <br /><font color=\"#FFFF00\">最高等级为5，最多可拥有125格。</font>"},
		 {{1, 5}, "<font color=\"#FFFF00\">当前拥有125个格子。</font><br /><font color=\"#FF0000\">氏族仓库用于存放氏族成员物品的空间。每升1级，格子数增加25。</font> <br /><font color=\"#FFFF00\">最高等级为5，最多可拥有125格。</font>"},
		 {{2, 0}, "<font color=\"#FFFF00\">当前氏族成员战斗额外获得0%经验。</font><br /><font color=\"#FF0000\">氏族福利可增加氏族成员战斗所获得的经验，每升1级获得的经验额外增加2%。</font> <br /><font color=\"#FFFF00\">最高等级为5，获得经验增加10%。</font>"},
		 {{2, 1}, "<font color=\"#FFFF00\">当前氏族成员战斗额外获得2%经验。</font><br /><font color=\"#FF0000\">氏族福利可增加氏族成员战斗所获得的经验，每升1级获得的经验额外增加2%。</font> <br /><font color=\"#FFFF00\">最高等级为5，获得经验增加10%。</font>"},
		 {{2, 2}, "<font color=\"#FFFF00\">当前氏族成员战斗额外获得4%经验。</font><br /><font color=\"#FF0000\">氏族福利可增加氏族成员战斗所获得的经验，每升1级获得的经验额外增加2%。</font> <br /><font color=\"#FFFF00\">最高等级为5，获得经验增加10%。</font>"},
		 {{2, 3}, "<font color=\"#FFFF00\">当前氏族成员战斗额外获得6%经验。</font><br /><font color=\"#FF0000\">氏族福利可增加氏族成员战斗所获得的经验，每升1级获得的经验额外增加2%。</font> <br /><font color=\"#FFFF00\">最高等级为5，获得经验增加10%。</font>"},
		 {{2, 4}, "<font color=\"#FFFF00\">当前氏族成员战斗额外获得8%经验。</font><br /><font color=\"#FF0000\">氏族福利可增加氏族成员战斗所获得的经验，每升1级获得的经验额外增加2%。</font> <br /><font color=\"#FFFF00\">最高等级为5，获得经验增加10%。</font>"},
		 {{2, 5}, "<font color=\"#FFFF00\">当前氏族成员战斗额外获得10%经验。</font><br /><font color=\"#FF0000\">氏族福利可增加氏族成员战斗所获得的经验，每升1级获得的经验额外增加2%。</font> <br /><font color=\"#FFFF00\">最高等级为5，获得经验增加10%。</font>"},
		 {{3, 0}, "<font color=\"#FFFF00\">当前氏族人数上限为50人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 1}, "<font color=\"#FFFF00\">当前氏族人数上限为55人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 2}, "<font color=\"#FFFF00\">当前氏族人数上限为60人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 3}, "<font color=\"#FFFF00\">当前氏族人数上限为65人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 4}, "<font color=\"#FFFF00\">当前氏族人数上限为70人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 5}, "<font color=\"#FFFF00\">当前氏族人数上限为75人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 6}, "<font color=\"#FFFF00\">当前氏族人数上限为80人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 7}, "<font color=\"#FFFF00\">当前氏族人数上限为85人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 8}, "<font color=\"#FFFF00\">当前氏族人数上限为90人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 9}, "<font color=\"#FFFF00\">当前氏族人数上限为95人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"},
		 {{3, 10}, "<font color=\"#FFFF00\">当前氏族人数上限为100人。</font><br /><font color=\"#FF0000\">氏族人数的等级决定着氏族成员上限，每升1级成员上限+5。</font> <br /><font color=\"#FFFF00\">最高等级为10，氏族人数上限为100人。</font>"}]).

