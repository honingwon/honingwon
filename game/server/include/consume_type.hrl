%% Author: Administrator
%% Created: 2011-5-31
%% Description: TODO: Add description to consume_type

%%消费类型

-define(CONSUME_DEFAULT, 0).			%%无类型

-define(CONSUME_YUANBAO_ITEM_BUY, 1).				%%元宝商店购买
-define(CONSUME_YUANBAO_RELIVE, 2).					%%原地复活（复活地图模版id）
-define(CONSUME_YUANBAO_SALE_SELL, 3).				%%元宝寄售（寄售编号）
-define(CONSUME_YUANBAO_SALE_BUY, 4).				%%元宝购买寄售物品（寄售编号）
-define(CONSUME_MONEY_GUILD_DONATE, 5).				%%公会捐献（）？？？？
-define(CONSUME_YUANBAO_ROSE, 6).					%%使用玫瑰花(物品模版id，数量)
-define(CONSUME_MONEY_MAIL_SEND, 7).				%%发送邮件（接收人ID）
-define(CONSUME_YUANBAO_REFRESH_MOUNTS, 8).			%%刷新坐骑技能（刷新次数）
-define(CONSUME_YUANBAO_XISUI_PET, 9).				%%宠物洗髓（宠物模版编号）
-define(CONSUME_YUANBAO_REFRESH_PET, 10).			%%刷新宠物技能（刷新次数）
-define(CONSUME_YUANBAO_FINISH_TOKEN, 11).			%%立即完成江湖令任务（任务类型）
-define(CONSUME_YUANBAO_VEINS_CD, 12).				%%清除穴位cd
-define(CONSUME_YUANBAO_WELFARE_EXCHANGE, 13).		%%离线经验兑换
-define(CONSUME_YUANBAO_DUPLICATE_SHOP_BUY, 14).	%%副本商店购买
-define(CONSUME_YUANBAO_TASK_TRUST, 15).			%%委托任务元宝完成
-define(CONSUME_MONEY_ITEM_BUY, 16).				%%物品购买
-define(CONSUME_YUANBAO_BAG_EXTEND, 17).			%%背包扩展
-define(CONSUME_MONEY_ITEM_DISCOUNT_BUY, 18).		%%优惠商品出售
-define(CONSUME_YUANBAO_OPEN_BOX, 19).				%%淘宝消耗元宝
-define(CONSUME_YUANBAO_RESET_DUPLICATE, 20).		%%重置副本消耗（副本id）

%%-define(CONSUME_MAGIC_BOX, 12).					%%魔法箱子消耗元宝
-define(CONSUME_EXPLOIT_ITEM_BUY, 21).				%%功勋商店购买

-define(CONSUME_YUANBAO_CHANGE_WAR_CAMP, 22).		%%切换资源战场阵营消耗(阵营)

-define(CONSUME_SMSHOP_REF, 23).				   %% 神秘商店刷新
-define(CONSUME_SMSHOP_BUY, 24).				   %% 神秘商店购买
-define(CONSUME_TASK_SUBMIT, 26).				   %% 任务直接完成
-define(CONSUME_EXCHANGE_YUAN_BAO, 27).			   %% 兑换银两
-define(CONSUME_YUANBAO_MARRY,	28).				%% 结婚消耗
-define(CONSUME_MONEY_MARRY_GIVE_GIFT, 29).			%% 结婚送礼	
-define(CONSUME_YUANBAO_SEND_CANDY, 30).			%% 结婚发送喜糖
-define(CONSUME_YUANBAO_DIVORCE, 31).				%% 强制离婚
-define(CONSUME_YUANBAO_CHANGE_MARRY, 32).			%% 将小妾提升为妻子，如果有妻子着妻子转换成小妾
-define(CONSUME_YUANBAO_PET_BATTLE_CD, 33).		%%宠物斗坛减cd（操作时间）
-define(CONSUME_YUANBAO_PET_BATTLE_TIMES, 34).		%%宠物斗坛增加次数（总次数）
-define(CONSUME_YUANBAO_BANK_BUY, 35).				%% 银行投资消耗
%%铜币消耗

%%元宝/铜币产出
-define(GAIN_MONEY_ACTIVE, 100).					%%活力点奖励
-define(GAIN_MONEY_GM, 101).						%%GM 命令增加
-define(GAIN_MONEY_DAILY_AWARD, 102).				%%每日领取奖励
-define(GAIN_MONEY_RECEIVE_MAIL, 103).				%%邮件收取
-define(GAIN_MONEY_DUPLICATE_AWARD, 104).			%%副本奖励
-define(GAIN_MONEY_COLLECT, 105).					%%采集获得
-define(GAIN_MONEY_TASK_AWARD, 106).				%%任务奖励
-define(GAIN_MONEY_PAY, 107).						%%充值获得
-define(GAIN_MONEY_SALE_SELL, 108).					%%拍卖行销售
-define(GAIN_MONEY_SALE_CANCEL, 109).				%%拍卖行撤销
-define(GAIN_MONEY_TARGET_AWARD, 120).				%%目标奖励
-define(GAIN_MONEY_VIP_AWARD, 121).					%%vip奖励
-define(GAIN_MONEY_ITEM_SELL, 122).					%%道具出售
-define(GAIN_MONEY_ITEM_USE, 123).					%%道具使用
-define(GAIN_MONEY_OPEN_BOX, 124).					%%开箱子

-define(CONSUME_ACTIVITY, 125).				   		%% 活动获取

-define(GAIN_MONEY_EXCHANGE_YUAN_BAO, 127).			%% 兑换银两
-define(GAIN_MONEY_BANK_GET, 128).					%% 银行投资回报
%%道具消耗/产出

-define(ITEM_DROP, 1).								%%物品掉落获得
-define(ITEM_USER, 2).								%%使用物品获得
-define(ITEM_TASK_AWARD, 3).						%%任务物品获得
-define(ITEM_DECOMPSE,	4).							%%物品分解消失
-define(ITEM_SELL, 5).								%%物品销售消失
-define(ITEM_THROW, 6).								%%物品丢弃消失
-define(ITEM_FEED, 7).								%%物品喂养消失

-define(CONSUME_ITEM_SELL, 5).						%%物品出售
-define(CONSUME_ITEM_THROW, 6).						%%物品丢弃
-define(CONSUME_ITEM_FEED, 7).						%%物品喂养
-define(CONSUME_ITEM_USE, 8).						%%物品使用
-define(CONSUME_ITEM_STRENG, 9).					%%强化
-define(CONSUME_ITEM_ENCHASE, 10).					%%镶嵌
-define(CONSUME_ITEM_COMPOSE, 11).					%%合成
-define(CONSUME_ITEM_DECOMPSE, 12).					%%分解（未用）
-define(CONSUME_ITEM_FISION, 13).					%%融合（未用）
-define(CONSUME_ITEM_REBUILD, 14).					%%洗炼
-define(CONSUME_ITEM_PK_DROP, 15).					%%PK掉落
-define(CONSUME_ITEM_UPGRADE, 16).					%%升级品阶
-define(CONSUME_ITEM_TASK, 17).						%%任务扣除
-define(CONSUME_ITEM_MOVE, 18).						%%移动覆盖
-define(CONSUME_ITEM_ARRANGE, 19).					%%整理消失
-define(CONSUME_ITEM_RETRIEVE, 20).					%%回收
-define(CONSUME_ITEM_MAIL, 21).						%%邮件
-define(CONSUME_ITEM_FUSION, 22).					%%熔炼


