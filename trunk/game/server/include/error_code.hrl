%%common sys error
-define(ER_UNKNOWN_ERROR, 0).			%%未知错误
-define(ER_WRONG_VALUE,	1).				%%错误的参数
-define(ER_NOT_EXSIT_DATA, 11).			%%配置数据不存在
-define(ER_NOT_ENOUGH_LEVEL, 21).		%%玩家等级不足
-define(ER_NOT_ENOUGH_YUANBAO, 22).		%%玩家元宝不足
-define(ER_NOT_ENOUGH_BAG,	31).		%%玩家背包空间不足
-define(ER_MAP_LIMIT, 41).				%%地图限制
-define(ER_NOT_ENOUGH_POWER, 51).		%%玩家权限不够
-define(ER_NOT_ENOUGH_GUILD_MONEY, 61).	%%公会货币不足
-define(ER_NOT_ENOUGH_GUILD_LEVEL, 62).	%%公会等级不足
-define(ER_NOT_ENOUGH_GUILD_FEATS, 63).	%%个人公会贡献不足
-define(ER_MAX_GUILD_PRAYER_NUM, 64).	%%公会祈福次数上限
-define(ER_STATE_BATTLE, 71).			%%玩家战斗状态中
-define(ER_PAY_TYPE,	140).			%%购买的物品的支付方式错误
%%--------------------------------------------------------------
%%Single sys error
%%--------------------------------------------------------------
%%副本异常
-define(ER_NOT_ENTER_DUPLICATE, 12049).	%% 玩家没有进入过副本不能重置
-define(ER_LIMIT_RESET_NUM, 12050).		%% 玩家重置次数限制

%%试炼副本124
-define(ER_LIMIT_PASS, 12401).			%%试炼前置关卡限制
-define(ER_LIMIT_MAP,	12402).			%%当前所在地图限制
%%-define().

%%%%神木蚕丝兑换道具14046
-define(ER_NOT_ENOUGH_MATERIAL, 14046).		%%购买的物品的支付方式错误

%% 21095 帮会活动召唤
-define(ER_SUMMON_COLLECT_TIME_LIMIT, 21095).	%%召唤采集物时间限制
-define(ER_NOT_ENOUGH_SUMMON_NUM, 21096).		%%召唤次数不足
%% 23105 阵营战
-define(ER_NOT_IN_CAMP_WAR, 23102).				%%不在阵营战中
-define(ER_IS_SAME_CAMP, 23105).				%%在同一个阵营中
