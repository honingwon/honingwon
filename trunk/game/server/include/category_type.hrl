-define(CATE_NECKLACK, 1).	%% 项链
-define(CATE_ARMET, 2).		%% 头盔
-define(CATE_WEAPONACCES, 3).%% 武饰
-define(CATE_WING, 5).		%% 背饰
%-define(CATE_CLOTH, 6).		%% 衣服
-define(CATE_CAESTUS, 7).	%% 腰带
-define(CATE_FASHION, 8).	%% 时装
-define(CATE_CUFF, 9).		%% 护腕
-define(CATE_MARRY, 10).	%% 婚饰
-define(CATE_RING, 11).		%% 戒指
-define(CATE_SHOE, 12).		%% 鞋子
-define(CATE_MOUNTS, 13).	%% 坐骑
-define(CATE_BANGLE, 14).	%% 佩饰
-define(CATE_KNIFE, 15).	%% 刀
-define(CATE_SWORD, 16).	%% 剑
-define(CATE_ROD, 17).		%% 杖
-define(CATE_FAN, 18).		%% 扇
-define(CATE_BOW, 19).		%% 弓
-define(CATE_CROSSBOW, 20).	%% 弩

-define(CATE_ARMOR_NECKLACK, 21).	%%铠甲项链
-define(CATE_ROBE_NECKLACK, 22).	%%袍衫项链
-define(CATE_CLOTH_NECKLACK, 23).	%%布衣项链
-define(CATE_ARMOR_ARMET, 24).%%轻革头盔
-define(CATE_ROBE_ARMET, 25).%%袍衫头盔
-define(CATE_CLOTH_ARMET, 26).%%布衣头盔
-define(CATE_ARMOR,27).		%% 战甲铠甲
-define(CATE_ROBE,28).		%% 袍衫
-define(CATE_CLOTH,29).		%% 布衣cloth
-define(CATE_ARMOR_CAESTUS, 30).	%% 铠甲腰带
-define(CATE_ROBE_CAESTUS, 31).	%% 袍衫腰带(束带)
-define(CATE_CLOTH_CAESTUS, 32).	%% 布衣腰带
-define(CATE_ARMOR_CUFF, 33).		%% 轻革护腕
-define(CATE_ROBE_CUFF, 34).			%% 袍衫护腕
-define(CATE_CLOTH_CUFF, 35).		%% 布衣护腕
-define(CATE_ARMOR_RING, 36).		%% 铠甲练戒
-define(CATE_ROBE_RING, 37).		%% 袍衫练戒
-define(CATE_CLOTH_RING, 38).		%% 布衣练戒
-define(CATE_ARMOR_SHOE, 39).		%% 轻革之靴
-define(CATE_ROBE_SHOE, 40).		%% 袍衫靴
-define(CATE_CLOTH_SHOE, 41).		%% 布衣靴
-define(CATE_ARMOR_PENDANT, 42).		%% 轻革坠
-define(CATE_ROBE_PENDANT, 43).		%% 袍衫坠
-define(CATE_CLOTH_PENDANT, 44).		%% 布衣坠

%%装备列表
-define(EQUIP_LIST, [{5}, {8}, {10}, {15}, {16}, {17}, {18}, {19}, {20}, {27}, {28}, {29}, {24}, {25}, {26}, {30}, {31}, {32}, {33}, {34}, 
					 {35}, {39}, {40}, {41}, {21}, {22}, {23}, {36}, {37}, {38}, {42}, {43}, {44}]).

-define(CATE_CLOTH_SAHNGWU, 48). %%尚武-时装
-define(CATE_CLOTH_XIAOYAO, 49). %%逍遥-时装
-define(CATE_CLOTH_LIUXING, 50). %%流星-时装(角色装备最大类型)
%%宠物装备
%%-define(PET_EQUIP_LIST,[{71},{72},{73},{74},{75}]).

-define(CATE_PET_EQUIP_ARMET, 71).%%宠物头盔
-define(CATE_PET_EQUIP_ARMOR, 72).%%宠物铠甲
-define(CATE_PET_EQUIP_CLAWS, 73).%%宠物利爪
-define(CATE_PET_EQUIP_AMULET, 74).%%宠物护符
-define(CATE_PET_EQUIP_PENDANT, 75).%%宠物吊坠

-define(CATE_MAX_EQUIP_ID, 100). %%100以为的物品标识为装备

-define(CATE_REDINSTANT, 201).	%% 即补类红药
-define(CATE_BLUEINSTANT, 202).	%% 即补类蓝药
-define(CATE_REDPACKAGE, 203).	%% 气血包（红）
-define(CATE_BLUEPACKAGE, 204).	%% 气血包（蓝）
-define(CATE_RED_ABIDANCEUNFIGHT, 205). %% 持续性红（非战斗状态下使用）
-define(CATE_BLUE_BIDANCEUNFIGHT, 206).	%% 持续性蓝（非战斗状态下使用）
-define(CATE_RED_BIDANCE, 207).			%% 持续性红
-define(CATE_BLUE_BIDANCE, 208).		%% 持续性蓝
-define(CATE_BUFF, 209).				%% BUFF
-define(CATE_FOOD, 210).				%% 食物类
-define(CATE_RELIVE_WATER, 211).        %% 复活药
-define(CATE_REBUILD_LOCK, 300).		%% 洗练锁
-define(CATE_STILETTO, 301).			%% 开孔类
-define(CATE_UPGRADE, 302).				%% 升级类
-define(CATE_STRENGTH, 303).			%% 强化类
-define(CATE_REBUILD, 304).				%% 洗练类


-define(CATE_ENCHASE_ATTACK, 305).		%% 镶嵌攻击宝石
-define(CATE_ENCHASE_DEFENSE, 306).		%% 镶嵌防御宝石
-define(CATE_ENCHASE_MUMP_HURT, 307).	%% 镶嵌斗攻宝石
-define(CATE_ENCHASE_MUMP_DEFENSE, 308).	%% 镶嵌斗防宝石
-define(CATE_ENCHASE_MAGIC_HURT, 309).		%% 镶嵌魔攻宝石
-define(CATE_ENCHASE_MAGIC_DEFENSE, 310).	%% 镶嵌魔防宝石
-define(CATE_ENCHASE_FAR_HURT, 311).		%% 镶嵌远攻宝石
-define(CATE_ENCHASE_FAR_DEFENSE, 312).		%% 镶嵌远防宝石
-define(CATE_ENCHASE_HIT_TARGET, 313).		%% 镶嵌命中宝石
-define(CATE_ENCHASE_DUCK, 314).			%% 镶嵌闪避宝石
-define(CATE_ENCHASE_DELIGENCY, 315).		%% 镶嵌坚韧宝石
-define(CATE_ENCHASE_POWERHIT, 316).		%% 镶嵌暴击宝石
-define(CATE_ENCHASE_BLUE, 317).			%% 镶嵌类法力宝石
-define(CATE_ENCHASE_RED, 318).				%% 镶嵌类生命宝石


-define(ENCHASE_COMPOSE_STONE1, 319). 		%%镶嵌组合宝石   (伤害宝石)
-define(ENCHASE_COMPOSE_STONE2, 320). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE3, 321). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE4, 322). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE5, 323). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE6, 324). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE7, 325). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE8, 326). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE9, 327). 		%%镶嵌组合宝石
-define(ENCHASE_COMPOSE_STONE10, 328). 		%%镶嵌组合宝石

-define(CATE_PURPLE_CRYSTAL, 329).			%% 紫水晶

-define(CATE_UPGRADE_UPLEVEL, 331).			%% 升级精炼共用

-define(CATE_COLLECT, 401).		%% 收集类
-define(CATE_RUBBISH, 501).		%% 垃圾类
-define(CATE_STUFF, 502).		%% 材料类 材料、农作物、农场采集等物品
-define(CATE_EXPANSION, 503).   %% 背包扩充类
-define(CATE_STATE, 504).		%% 状态类	双倍经验、扩建卡等持续时间道具
-define(CATE_CARRY_INSTANT, 505).		%% 传送类(即用)	回城卷、随机传送卷
-define(CATE_CARRY_AGENT, 506).			%% 传送类(媒介)	飞天神靴
-define(CATE_SKILL_BOOK_PLAYER, 507). 	%% 秘籍	人物技能书
-define(CATE_SKILL_BOOK_PET, 508).		%% 宠物技能书
-define(CATE_STRENGTH_LUCKY_SYMBOL, 509).	%% 强化幸运符
-define(CATE_REBUILD_LUCKY_SYMBOL, 510).	%% 洗练幸运符
-define(CATE_UPGRADE_LUCKY_SYMBOL, 511).	%% 升级幸运符
-define(CATE_STRENGTH_PROTECT_SYMBOL, 512).	%% 强化保护符
-define(CATE_UPGRADE_PROTECT_SYMBOL, 513).	%% 升级保护符
-define(CATE_ACTIVITY, 514).				%% 集锦类	普通道具、活动道具、喜庆道具等预留物品
-define(CATE_INCOME, 515).					%% 收益类	银票等可直接获得收益的道具
-define(CATE_COMPOSESCROLL, 516).			%% 合成卷轴



-define(CATE_COMPOSE_LUCKY_SYMBOL, 519).    %% 宝石合成符
-define(CATE_CURREXP, 520).                 %% 经验药
-define(CATE_LIFTEXP, 521).                 %% 历练药
-define(CATE_MOON_CAKE, 522).				%% 月饼
-define(CATE_ADD_EXPLOIT, 523).				%%功勋增长
-define(CATE_ADD_PET_EXP, 524).				%%宠物经验增长

-define(CATE_DEPOT_EXPANSION, 525).         %% 仓库扩充类
-define(CATE_ADD_PHYSICAL, 526).            %% 增加体力类
-define(CATE_HORN,527).                     %% 喇叭
-define(CATE_CARRY_SHOE, 528).              %% 随机传送鞋
-define(CATE_CARRY_CITY, 529).              %% 回城卷
-define(CATE_REDUCE_PK_VALUE, 530).         %% 免罪符

-define(CATE_BOX, 531).						%% 礼包
-define(CATE_DMOGORGON, 532).               %% 神魔令
-define(CATE_LENGGONG_STONE, 533).          %% 玲珑石
-define(CATE_WINE, 534).                    %% 杜康酒

-define(CATE_VIPCARD, 535).					%% VIP卡
-define(CATE_CONTRIBUTE_CARD, 536).         %% 贡献令
-define(CATE_DECLARE_CARD, 537).            %% 宣战令
-define(CATE_CANCELWAR_CARD, 538).          %% 免战令
-define(CATE_CREATE_GUILD_CARD, 539).		%% 建帮令

-define(CATE_PET, 540).						%% 宠物蛋

-define(CATE_NOVICE_BOX, 541).				%% 新手礼包

-define(CATE_PET_FOOD, 542).				%% 宠物口粮
-define(CATE_PET_GROW_CHIP, 545).	        %% 宠物成长丹碎片
-define(CATE_PET_GROW, 546).	        	%% 宠物成长丹
-define(CATE_PET_QUALITY, 547).	            %% 宠物资质丹
-define(CATE_PET_STAIRS, 548).	            %% 宠物阶丹丹
-define(CATE_PET_SKILL_SEAL, 552).			%% 宠物技能封印符
-define(CATE_PET_SKILL_BOOK, 553).			%% 宠物技能书


-define(CATE_MOUNTS_SKILL_BOOK,562).		%% 坐骑技能书 
-define(CATE_MOUNTS_SKILL_BOOK_CHIP,563).	%% 坐骑技能书残页
-define(CATE_MOUNTS_QUALITY_SYMBOL,564).	%% 坐骑资质提升符
-define(CATE_MOUNTS_QUALITY_PROTECTED_SYMBOL,565). %%宠物资质保护符 
-define(CATE_MOUNTS_GROW_SYMBOL,566).		%% 坐骑成长提升符
-define(CATE_MOUNTS_GROW_PROTECTED_SYMBOL,567). %% 坐骑成长保护符 
-define(CATE_CATE_MOUNTS_STAIRS_SYMBOL,568).%% 坐骑进阶丹
-define(CATE_MOUNTS_SKILL_SEAL_SYMBOL,569).	%% 坐骑技能封印符

-define(CATE_VEINS_SPEED_UP, 580).	%%穴位升级加速卡
-define(CATE_ADD_USER_TITLE, 585).	%%增加称号

-define(CATE_TREASURE_MAP, 601).			%% 藏宝图

-define(TEMPLATE_SPEAKER, 206049).			%% 喇叭,物品模板Id
-define(TRANSFER_SHOE_TEMPID, 206046).      %% 飞天鞋模板id

-define(CONTRIBUTION_TEMPID, 103033).		%% 贡献令模板id
-define(DECLEAR_WAR_TEMPID, 103034).		%% 强行宣战模板id
-define(STOP_WAR_TEMPID, 103035).			%% 强行停战模板id
-define(CREATE_GUILD_CARD_TEMPID, 206044).	%% 建帮令模板id

-define(ITEM_RELIVE_WATER, 206026).                             %%复活药水

-define(ITEM_MOUNTS_QUALIFICATION_UP,204002).					%%坐骑资质提升符
-define(ITEM_MOUNTS_QUALIFICATION_PROT,204006).					%%坐骑资质保护符
-define(ITEM_MOUNTS_GROW_UP,204001).							%%坐骑成长提升符
-define(ITEM_MOUNTS_GROW_PROT,204005).							%%坐骑成长保护符
-define(ITEM_MOUNTS_STAIRS_UP,204003).							%%坐骑阶级提升符
-define(ITEM_MOUNTS_SKILL_SEAL,204007).							%%坐骑技能封印符


-define(ITEM_PET_SKILL_SEAL,260029).							%%宠物技能封印符


