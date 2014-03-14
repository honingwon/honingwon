%%%------------------------------------------------
%%% File    : proto.hrl
%%% Author  : 
%%% Created : 
%%% Description: 协议定义
%%%------------------------------------------------


%%-------------- 账户信息--------------------------
-define(PP_ACCOUNT_LOGIN, 10001).             %% 登陆
-define(PP_ACCOUNT_USERSLIST_RETURN, 10002).  %% 返回角色列表
-define(PP_ACCOUNT_SELECT, 10003).            %% 选择角色进入游戏, 返回人物信息
-define(PP_ACCOUNT_CREATE, 10004).            %% 创建角色
%% -define(PP_ACCOUNT_DELETE, 10005).            %% 删除角色
-define(PP_ACCOUNT_HEARTBEAT, 10006).         %% 心跳包

-define(PP_ACCOUNT_GUEST, 10010).			%% 游客
-define(PP_ACCOUNT_GUEST_LOGIN, 10011).		%% 游客选择角色进入游戏
-define(PP_ACCOUNT_LOST_CONNECT, 10012).	  %%帐号断开连接
%%-------------------------------------------------


%%------------- 地图信息---------------------------
-define(PP_MAP_ENTER, 12001).                 %% 进入地图
-define(PP_MAP_EXIT, 12002).                  %% 退出地图
-define(PP_MAP_USER_ADD, 12003).              %% 地图用户添加
-define(PP_MAP_USER_REMOVE, 12004).			   %% 地图用户删除
-define(PP_MAP_MONSTER_INFO_UPDATE, 12005).   %% 怪物信息更新
-define(PP_MAP_MONSTER_REMOVE, 12006).        %% 删除怪物
-define(PP_MAP_ROUND_INFO, 12007).            %% 获取地图人物信息
-define(PP_MAP_MONSTER_INFO_UPDATE_REBORN, 12008). %%仅用于标识怪物重生，打包时仍使用pp_map_monster_info_update

-define(PP_PLAYER_MOVE, 12010).               %% 玩家移动
-define(PP_PLAYER_MOVE_STEP, 12011).          %% 玩家移动同步
-define(PP_PLAYER_FOLLOW, 12012).			  %% 玩家跟随
-define(PP_PLAYER_RELIVE, 12013).				  %% 玩家复活

-define(PP_SIT_START_OR_CANCLE, 12014).			%%开始打坐,取消打坐
-define(PP_SIT_INVITE, 12015).				 	%%邀请打坐
-define(PP_SIT_INVITE_REPLY, 12016).		 	%%邀请打坐答复

-define(PP_PLAYER_STYLE_UPDATE, 12017).			%% 玩家形象更新

-define(PP_PLAYER_HANGUPDATA, 12018).			%%玩家挂机数据更新

-define(PP_DEFENCE_LIST, 12019).				%%正当防卫列表

-define(PP_PLAYER_PLACE_UPDATE, 12020).         %%随机传送符位置更新


-define(PP_MAP_PET_INFO_UPDATE, 12021).       %% 宠物信息更新
-define(PP_MAP_PET_REMOVE, 12022).            %% 宠物删除
-define(PP_SKILL_RELIVE, 12023).				%% 技能复活
-define(PP_NEW_SKILL_ADD, 12024).				%% 新增技能添加到挂机技能中

-define(PP_REMOVE_MONSTER, 12030).					%%移除怪物
-define(PP_MAP_COLLECT_UPDATE, 12031).   	  %% 采集信息更新


-define(PP_ENTER_DUPLICATE, 12041).			  %% 进入副本
-define(PP_COPY_ENTER_COUNT, 12042).          %% 获取副本进入次数列表
-define(PP_QUIT_DUPLICATE, 12043).            %% 退出副本
-define(PP_NEXT_MON_TIME, 12044).	           %% 下一波怪出现时间
-define(PP_LEFT_TIME, 12045).					%% 剩余时间
-define(PP_COPY_INFO, 12046).					%% 副本信息%% 用户掉线后重新连接返回副本信息
-define(PP_COPY_LOTTERY, 12048).				%% 副本离开副本后抽奖
-define(PP_COPY_LIMIT_NUM_RESET, 12049).		%% 清除副本次数限制

%%打钱副本
-define(PP_CLEAR_DROPITEM_ALL, 12360).			%% 清除全部物品
-define(PP_CLEAR_MOUNSTER_ALL, 12361).			%% 清除全部怪物
-define(PP_UPDATE_BATTER_NUM, 12362).			%% 更新连击数
-define(PP_PICKUP_MONEY_AMOUNT, 12363).			%% 更新拾取货币数量
-define(PP_KILL_BOSS, 12364).					%% 杀死BOSS通知
-define(PP_RAND_MONEY, 12365).					%% 随机掉落铜币数量
%%防守副本
-define(PP_CAN_OPEN_NEXT_MONSTER, 12370).		%% 可以开放下一波怪物
-define(PP_OPEN_NEXT_MONSTER, 12371).			%% 释放下波怪物
-define(PP_GUARD_KILL_AWARD, 12372).			%% 防守怪物击杀奖励
%%爬塔副本
-define(PP_UPDATE_DEAD_MONSTER, 12380).			%% 通知客户端怪物死亡
-define(PP_UPDATE_MISSION_INFO, 12381).			%% 本层数据信息

-define(PP_COPY_PASS, 12382).					%% 副本通关（0通关，1通本）
%-define(PP_PASS_MISSION, 12382).				%% 通过关卡

%%副本商店
-define(PP_DUPLICATE_SHOP_SALE_NUM, 12390). 	%% 返回商品可购买数量
-define(PP_DUPLICATE_SHOP_BUY, 12391).			%% 请求购买

%%试炼副本
-define(PP_ENTER_CHALLENGE_BOSS,12401).				%% 请求进入试炼副本
-define(PP_CHALLENGE_BOSS_INFO, 12402).				%% 请求试炼副本记录信息
-define(PP_CHALLENGE_BOSS_PASS, 12403).				%% 试炼副本挑战通过
-define(PP_CHALLENGE_NEXT_BOSS, 12404).				%% 挑战下一个试炼boss
-define(PP_CHALLENGE_AWARD_NUM, 12405).				%% 请求试炼副本当天挑战奖励次数

%% 乱斗副本
-define(PP_FIGHT_DUP_TIME, 12406).				%% 乱斗副本玩家剩余时间

-define(PP_ENTER_VIPMAP, 12050).              %% 进入vip地图
-define(PP_QUIT_VIPMAP, 12051).               %% 退出vip地图


-define(PP_ENTER_FREE_WAR, 12061).			  %% 进入战场
-define(PP_QUIT_FREE_WAR, 12062).			  %% 退入战场
-define(PP_FREE_WAR_LIST, 12063).			  %% 战场列表
-define(PP_FREE_WAR_USER_LIST, 12064).		  %% 战场用户列表
-define(PP_FREE_WAR_USER_INFO, 12065).		  %% 战场用户信息，杀和被杀
-define(PP_FREE_WAR_STATE, 12066).			  %% 战场状态，剩余时间
-define(PP_FREE_WAR_RESULT, 12067).			  %% 战场结果累计
-define(PP_FREE_WAR_AWARD, 12068).			  %% 战场奖励
-define(PP_FREE_WAR_RELIVE, 12069).			  %% 复活


-define(PP_XW_START_OR_CANCLE, 12070).		  %%开始修为,取消打坐

%%---------------活动相关----------------------------
%%答题活动
%%-define(PP_ACTIVE_QUESTION).


%%------------ 物品信息------------------------------
-define(PP_ITEM_STALL, 14001).                %% 道具摆摊
-define(PP_ITEM_SPLIT, 14002).                %% 道具拆分
-define(PP_ITEM_ARRANGE, 14003).              %% 道具整理
-define(PP_ITEM_RETRIEVE, 14004).             %% 道具回收
-define(PP_BAG_EXTEND, 14005).                %% 背包扩充
-define(PP_ITEM_PLACE_UPDATE,14006).          %% 物品更新
-define(PP_ITEM_MOVE,14007).                  %% 移动物品
-define(PP_ITEM_PET_PLACE_UPDATE,14008).      %% 宠物装备更新

-define(PP_ITEM_STRENG, 14011).               %% 道具强化
-define(PP_ITEM_USE, 14012).                  %% 道具使用
-define(PP_ITEM_BUY, 14014).                  %% 道具购买
-define(PP_ITEM_BUY_BACK, 14017).             %% 道具回购
-define(PP_ITEM_BUY_BACK_UPDATE, 14018).      %% 道具回购更新
-define(PP_ITEM_ENCHASE, 14019).              %% 道具镶嵌
-define(PP_ITEM_REBUILD, 14020).              %% 道具洗练
-define(PP_ITEM_STONE_PICK, 14021).           %% 道具宝石摘取
-define(PP_ITEM_DECOMPOSE, 14022).            %% 道具分解
-define(PP_ITEM_TRANSFORM, 14023).			  %% 装备强化与洗炼转移
-define(PP_ITEM_REPLACE_REBUILD, 14024).		%% 替换洗炼属性

-define(PP_ITEM_TAP, 14025).                  %% 装备开孔
-define(PP_ITEM_FIX, 14027).                  %% 道具修理
-define(PP_ITEM_COMPOSE, 14028).              %% 道具合成
-define(PP_ITEM_SELL, 14029).                 %% 道具出售

-define(PP_ITME_UPGRADE, 14030).				%% 装备品质提升
-define(PP_ITEM_UPLEVEL, 14032).				%% 装备等级提升


-define(PP_ITEM_DISCOUNT, 14037).               %% 优惠商品
-define(PP_ITEM_REAL_TIME, 14038).			  %% 优惠商品实时信息
-define(PP_ITEM_DISCOUNT_BUY, 14039).			%% 优惠商品购买
-define(PP_ITEM_EXPLOIT_BUY, 14040).			%% 功勋购买物品

-define(PP_ITEM_REPAIR, 14041).                 %% 道具修理
-define(PP_STONE_COMPOSE, 14042).               %% 宝石合成
-define(PP_ITEM_FUSION, 14043).                 %% 装备融合

-define(PP_SKILLBAR_ITEM_USE, 14044).		   %%快捷栏道具使用
-define(PP_ITEM_REFER, 14045).				   %% 查询道具
-define(PP_ITEM_EXCHANG_BUY, 14046).			%% 物品兑换 （神木203019蚕丝203016）

-define(PP_DEPOT_ITEM_UPDATE, 14050).          %%仓库物品更新
-define(PP_DEPOT_MONEY_OPERATE, 14051).        %%仓库的存款 取款操作
-define(PP_STONE_QUENCH, 14052).			   %%宝石淬炼
-define(PP_STONE_DECOMPOSE, 14053).			   %%精致宝石分解
-define(PP_EQUIP_FUSION, 14054).				%% 装备熔炼


-define(PP_USE_TRANSFER_SHOE, 14060).          %%飞天鞋使用

-define(PP_ITEM_USER_GUILD_SHOP, 14061).       %% 玩家购买帮会商品记录
-define(PP_ITEM_GUILD_SHOP_BUY, 14062).		   %% 帮会商品购买

-define(PP_SHENMO_SAVE_TASK, 14070).	       %%保存神魔令任务
-define(PP_SHENMO_REFRESH_STATE, 14071).       %%神魔令刷新品质






%%-----------开箱子------------------------------------
-define(PP_OPEN_BOX,  14080).                  %%开箱子
-define(PP_MOVE_BOX_DATA,  14081).             %%移动箱子物品到背包
-define(PP_BOX_ALL_DATA, 14082).               %%获取箱子仓库数据
-define(PP_BOX_CLIENT_DATA, 14083).            %%开箱子临时数据
-define(PP_BOX_DATA_TO_WORLD, 14084).          %%开箱子开出极品并广播
-define(PP_ALL_WORLD_BOXDATA, 14085).          %%最近开箱记录
-define(PP_OPEN_BOX_SINGLE, 14086).			   %%开箱子后仓库物品增加

  
%%-----------神秘商店------------------------------------		
-define(PP_MYSTERY_SHOP_LAST_UPDATE_TIMER, 14090). %% 神秘商店更新时间
-define(PP_MYSTERY_SHOP_INFO, 14091). 	  	   %% 神秘商店商品实时信息
-define(PP_MYSTERY_SHOP_REFRESH, 14092). 	   %% 神秘商店商品主动刷新

-define(PP_MYSTERY_SHOP_DATA_TO_WORLD, 14093). %% 神秘商店出极品并广播
-define(PP_MYSTERY_SHOP_ALL_WORLD_DATA, 14094).%% 最近神秘商店记录
-define(PP_MYSTERY_SHOP_BUY, 14095).		   %% 神秘商店商品购买




-define(PP_ROSE_PLAY,14101).					%% 玫瑰播放

-define(PP_ITEM_BATCH_USE,14201).				%% 批量使用物品

%%---------------------------------------------------

	

	

%%-----------摆摊------------------------------------
-define(PP_STALL_CREATE, 15000).				 %%开始摆摊
-define(PP_STALL_CANCEL, 15010).				 %%取消摆摊
-define(PP_STALL_QUERY, 15020).					 %%查询摊位信息
-define(PP_STALL_SALE , 15030).					 %%出售道具给摊位
-define(PP_STALL_BUY , 15040).					 %%摊位道具购买
-define(PP_STALL_STATE_UPDATE, 15050).			 %%地图摆摊状态更新	
-define(PP_STALL_UPDATE , 15060).				 %%摊位更新
-define(PP_STALL_CHAT , 15070).					 %%摆摊留言
-define(PP_STALL_LOG, 15080).					 %%交易信息
%%---------------------------------------------------
%%----------- 聊天信息-------------------------------
-define(PP_CHAT, 16001).                      %% 用户聊天
-define(PP_CHAT_SYSTEM_INFO, 16002).          %% 系统消息

-define(PP_BANK_BUY, 16101).					%% 银行投资购买
-define(PP_BANK_GET, 16102).					%% 银行投资红利领取
-define(PP_BANK_LIST, 16103).					%% 获取银行投资信息
%%---------------------------------------------------


%%----------- 组队信息-------------------------------
-define(PP_TEAM_INVITE, 17001).               %% 组队邀请
-define(PP_TEAM_INVITE_MSG, 17002).           %% 邀请信息
-define(PP_TEAM_UPDATE_MSG, 17003).           %% 组队信息更新
-define(PP_TEAM_NOFULL_MSG, 17004).           %% 未满队伍及未组队队员
-define(PP_TEAM_KICK, 17005).                 %% 逐出队伍
-define(PP_TEAM_LEAVE, 17006).                %% 离开队伍
-define(PP_TEAM_DISBAND, 17007).              %% 解散队伍
-define(PP_TEAM_LEADER_CHANGE, 17008).        %% 更改队长
-define(PP_TEAM_CHANGE_SETTING, 17009).       %% 队伍设置
-define(PP_TEAM_BATTLEINFO, 17012).           %% 血蓝更新

-define(PP_TEAM_CREATE, 17013).				%% 创建队伍
-define(PP_TEAM_LEVEL_UPDATE, 17014).       %% 队伍成员等级更新
-define(PP_TEAM_POSITION_UPDATE, 17015).       %% 队伍地图位置更新


-define(PP_TEAM_DUPLICATE_ENTER, 17021).	%% 队长进入副本 
%%---------------------------------------------------


%% ---------- 好友信息--------------------------------
%% -define(PP_FRIEND_ONLINE_STATE, 18000).    %% 好友上下线状态提醒
%% -define(PP_FRIEND_SEND_ADD, 18001).        %% 发送添加好友请求
-define(PP_FRIEND_UPDATE, 18002).             %% 更新好友信息
-define(PP_FRIEND_GROUP_UPDATE, 18003).       %% 更新好友分组
-define(PP_FRIEND_LIST,18004).                %% 返回好友列表

-define(PP_FRIEND_DELETE, 18012).             %% 好友删除
-define(PP_FRIEND_AUTO_REPLY, 18013).         %% 自动回复设置
-define(PP_FRIEND_RESPONSE, 18014).           %% 好友添加响应
-define(PP_FRIEND_ONLINE_STATE, 18015).       %% 好友在线状态
-define(PP_FRIEND_ACCEPT, 18016).             %% 好友同意拒绝

%% -define(PP_FRIEND_GROUP_CHANGE,18017).     %% 好友分组添加、改名
-define(PP_FRIEND_GROUP_DELETE,18018).        %% 分组删除
-define(PP_FRIEND_GROUP_MOVE, 18019).         %% 分组移动
-define(PP_QUERY_USER_INFO, 18020).        %% 查询用户信息
-define(PP_QUERY_FRIEND_INFO, 18021).         %% 好友搜索
-define(PP_QUERY_USER_VEINS, 18022).			%% 查询用户经脉信息

-define(PP_FRIEND_AMITY_UPDATE,18023).			%% 好友度更新

-define(PP_FRIEND_SYS_MSG,18050).			%%好友模块提示信息



%%---------------------------------------------------


%%---------- 邮件信息--------------------------------
-define(PP_MAIL_QUERY_ALL, 19000).			  %% 查询所有邮件
-define(PP_MAIL_SEND, 19001).                 %% 邮件发送
-define(PP_MAIL_RECEIVE, 19002).              %% 邮件收取
-define(PP_MAIL_READ, 19003).                 %% 邮件读取
-define(PP_MAIL_RESPONSE, 19004).             %% 邮件响应
-define(PP_MAIL_DELETE, 19005).               %% 邮件删除
%% -define(PP_MAIL_RECEIVE_LIST, 19006).         %% 邮件列表
-define(PP_MAIL_DELETE_EMPTY, 19007).		  %% 清除空邮件
-define(PP_MAIL_UPDATE, 19008).				  %% 更新邮件

-define(PP_MAIL_GUILD, 19020).				  %% 帮派邮件

-define(PP_GET_MAIL_GUILD_NUM, 19021).		  %% 帮派邮件数量

%%--------------------------------------------------


%%---------- 人物信息--------------------------------
-define(PP_LOGIN, 20001).                     %% 用户登陆
-define(PP_QUERY_SELF_OTHER, 20002).          %% 获取用户自身其他信息,背包，是否有邮件，好友，任务，组队，
-define(PP_UPDATE_SELF_INFO, 20003).          %% 个人货币信息
-define(PP_UPDATE_USER_INFO, 20004).          %% 更新玩家信息
%% -define(PP_UPDATE_USER_INFO_REPLAY, 20005).   %% 重新更新玩家信息

-define(PP_UPDATE_SELF_EXP, 20006).			  %% 个人经验更新
-define(PP_UPDATE_PLAYER_LEVEL, 20007).		  %% 玩家升级广播
-define(PP_UPDATE_SELF_PHYSICAL,20008).       %% 个人体力更新
-define(PP_UPDATE_SELF_HONOR, 20009).		  %% 个人荣誉更新


-define(PP_CONFIG, 20010).                    %% 游戏设置

-define(PP_SERVER_OPEN_DATE,20011).	  		  %% 开服时间

-define(PP_BUFF_UPDATE, 20012).               %% buff更新
-define(PP_SKILL_LEARNORUPDATE, 20013).       %% 技能学习/升级
-define(PP_SKILL_INIT, 20014).                %% 用户技能加载
-define(PP_SKILL_BAR_INIT, 20015).            %% 技能位置加载
-define(PP_PLAYER_DRAG_SKILL, 20016).         %% 玩家拖放调整快捷栏技能
-define(PP_PLAYER_SET_HORSE, 20017).		  %% 玩家上下马
-define(PP_PLAYER_CHOOSE_TITLE, 20018).		  %% 玩家选择称号
%% -define(PP_BUFF_CONTROL, 20019).		  	  %% 多倍经验开关

-define(PP_PLAYER_TITLE_INFO, 20021).         %% 称号信息
-define(PP_PLAYER_FIRST_TITLE, 20022).        %% 首个称号

-define(PP_PLAYER_ATTACK, 20031).             %% 玩家攻击
-define(PP_PLAYER_GET_DROPITEM, 20032).       %% 玩家拾取

-define(PP_PLAYER_SELF_LIFEEXP,20040).			%% 玩家历练值更新

-define(PP_PLAYER_PK_MODE_CHANGE,20050).		%% PK Mode 
-define(PP_PLAYER_PK_VALUE_CHANGE,20051).		%% PK值变化

-define(PP_PLAYER_COLLECT_STOP, 20060).			%% 玩家停止采集
-define(PP_PLAYER_COLLECT_START, 20061).		%% 玩家开始采集
-define(PP_PLAYER_COLLECT, 20062).				%% 玩家采集

-define(PP_PLAYER_ROLE_NAME_REMOVE, 20063).		%% 玩家称号移除

-define(PP_PLAYER_DAILY_AWARD, 20071).			%% 每日奖励
-define(PP_PLAYER_DAILY_AWARD_LIST, 20072).	%% 每日奖励列表
-define(PP_PLAYER_ACTIVY_COLLECT, 20073).		%% 激活码领取奖励
-define(PP_PLAYER_ACTIVY_SEARCH, 20074).		%% 活动领取查询

-define(PP_PLAYER_ACTIVE_AWARD, 20075).			%% 活跃度礼包领取
-define(PP_PLAYER_ACTIVE_INFO, 20076).			%% 活跃度活动数量信息
-define(PP_PLAYER_ACTIVE_STATE, 20077).			%% 活跃度,可领取状态
-define(PP_PLAYER_ACTIVE_NUM, 20078).			%% 活跃度活动值

-define(PP_PLAYER_VIP_USE, 20080).				%% 使用VIP
-define(PP_PLAYER_VIP_DETAIL, 20081).			%% VIP细明
-define(PP_PLAYER_VIP_AWARD, 20082).			%% VIP奖励
-define(PP_PLAYER_VIP_ONE_HOUR, 20083).			%% 成功使用VIP体验卡


-define(PP_PLAYER_WELFARE_UPDATE, 20090).			%% 更新福利信息
-define(PP_PLAYER_WELFARE_RECEIVE, 20091).			%% 领取福利
-define(PP_PLAYER_WELFARE_EXP_EXCHANGE, 20092).		%% 兑换经验
-define(PP_PLAYER_WELFARE_RESET_LOGIN_DAY, 20093).	%% 重置连续登录天数

-define(PP_PLAYER_BREAK_AWAY,20110).					    %% 回到京城防卡死

-define(PP_UPDATE_CLUB_EXPLOIT, 20112).					%% 个人贡献更新

-define(PP_HIDE_FASHION, 20130).						%% 隐藏时装
-define(PP_HIDE_WEAPONACCES, 20131).					%% 隐藏武饰

-define(PP_VEINS_ACUPOINT_UPDATE, 20201).				%% 升级筋脉
-define(PP_VEINS_GENGU_UPDATE, 20202).					%% 升级根骨
-define(PP_VEINS_CLEAR_CD, 20203).						%% 清除CD
-define(PP_VEINS_INIT, 20204).							%% 请求筋脉信息



-define(PP_PLAYER_ACTIVE_OPEN_SERVER,20310).			%% 开服相关活动
-define(PP_PLAYER_ACTIVE_OPEN_SERVER_AWARD,20311).		%% 领取开服相关活动的奖励
-define(PP_PLAYER_ACTIVE_FIRST_PAY,20312).				%% 开服首充活动

-define(PP_PLAYER_YELLOW_INFO,20400).					%% 玩家黄钻信息
-define(PP_PLAYER_YELLOW_GET_REWARD,20401).				%% 玩家黄钻奖励获取

-define(PP_ACTIVE_SEVEN,20500).							%% 7天活动列表
-define(PP_ACTIVE_SEVEN_GETREWARD,20501).				%% 7天活动奖励

-define(PP_ACTIVE_SEVEN_GET_ALL_REWARD,20502).			%% 7天活动全民奖励

-define(PP_QQ_BUY_GOODS,20600).							%% 获取交易token 

-define(PP_GET_BIND_YUANBAO,20601).					    %% 兑换绑定银两
-define(PP_DUPLICATE_SHENYOU,20610).					%% 副本神游请求
-define(PP_DUPLICATE_SHENYOU_COMPLATE,20611).					%% 副本神游立即完成
-define(PP_DUPLICATE_SHENYOU_INTERRUPT,20612).					%% 副本神游中断

%%---------------------------------------------------

%%--------- 帮派信息---------------------------------

-define(PP_CLUB_CREATE, 		21001).         %% 帮会创建
-define(PP_CLUB_QUERYLIST, 		21002).         %% 帮会查询
-define(PP_CLUB_DETAIL, 		21003).         %% 帮会细节
-define(PP_CLUB_SET_NOTICE, 	21004).         %% 修改信息
-define(PP_CLUB_CONTRIBUTION, 	21005).        	%% 帮会贡献

-define(PP_CLUB_GETWEAL, 		21006).         %% 领取福利
-define(PP_CLUB_MEMBER_DUTY, 	21007).         %% 获取职位
-define(PP_CLUB_QUERYMEMBER, 	21008).         %% 查询帮会成员
-define(PP_CLUB_QUERYTRYIN, 	21009).        	%% 查询申请列表
-define(PP_CLUB_CLEARTRYIN, 	21010).         %% 清除申请列表


-define(PP_CLUB_STORE_PAGEUPDATE,21011).     	%% 获取仓库数据(分页获取)
-define(PP_CLUB_STORE_REQUEST_LIST,21012). 		%% 帮会仓库物品待审核列表
-define(PP_CLUB_STORE_MY_REQUEST_LIST,21013).	%% 个人物品待审核列表
-define(PP_CLUB_STORE_GET, 		21014).         %% 帮会仓库物品申请
-define(PP_CLUB_STORE_PUT, 		21015).         %% 帮会仓库物品存入
-define(PP_CLUB_STORE_CHECK,	21016).			%% 物品审核操作
-define(PP_CLUB_STORE_EVENT, 	21017).         %% 帮会仓库日志
-define(PP_CLUB_STORE_ITEM_CANCEL, 21018).      %% 个人物品取消申请

-define(PP_CLUB_DISMISS, 		21019).         %% 解散帮会
-define(PP_CLUB_LEVELUP, 		21020).         %% 帮会升级
-define(PP_CLUB_EXTEND_UPDATE, 	21021).        	%% 帮会扩展更新
-define(PP_CLUB_EXTEND_ADD, 	21022).         %% 帮会扩展


-define(PP_CLUB_TRYINRESPONSE, 	21030).       	%% 申请答复
-define(PP_CLUB_TRYIN, 			21031).         %% 申请加入帮会
-define(PP_CLUB_KICKOUT, 		21032).         %% 踢出帮会
-define(PP_CLUB_TRANSFER, 		21033).         %% 帮会转让
-define(PP_CLUB_INVITE,			21034).			%% 帮会邀请
-define(PP_CLUB_EXIT,			21035).			%% 帮会退出

-define(PP_CLUB_DUTY_UPDATE,	21036).			%% 职务列表更新
-define(PP_CLUB_DUTY_CHANGE,	21037).			%% 帮会职务更改
-define(PP_CLUB_WEAL_UPDATE,	21038).			%% 福利更新
-define(PP_CLUB_TRANSFER_RESPONSE,21039).		%% 帮会转让答复
-define(PP_CLUB_INVITE_RESPONSE,21040).			%% 帮会邀请答复
-define(PP_CLUB_LEVELUP_UPDATE,	21041).			%% 帮会升级更新

-define(PP_CLUB_SELF_EXPLOIT_UPDATE,21043).		%% 个人贡献更新
-define(PP_CLUB_ONLINE_UPDATE,	21044).			%% 在线状态更新

-define(PP_CLUB_NEW_PLAYER_IN,	21045).			%% 帮会新成员加入
-define(PP_CLUB_NEW_PLAYER_WELCOME_SUCCEED,	21046).			%% 帮会新成员欢迎成功

-define(PP_CLUB_ENTER, 			21051).			%% 帮派进入地图
-define(PP_CLUB_LEAVE_SCENCE, 		21052).     %% 退出帮会地图

-define(PP_CLUB_WAR_DECLEAR_INIT, 21053). 		%% 帮派宣战列表
-define(PP_CLUB_WAR_DEAL_INIT, 	21054). 		%% 宣战处理列表
-define(PP_CLUB_WAR_ENEMY_INIT, 21055).			%% 敌对帮派列表
-define(PP_CLUB_WAR_DECLEAR, 	21056). 		%% 向其他帮会宣战
-define(PP_CLUB_WAR_DEAL, 		21057).			%% 宣战处理
-define(PP_CLUB_WAR_STOP, 		21058).  		%% 停战
-define(PP_CLUB_WAR_REQUEST_RESPONSE, 21059).	%% 宣战请求
-define(PP_CLUB_WAR_ENEMY_LIST_UPDATE, 21060).	%% 敌对帮会信息

-define(PP_CLUB_MEMBER_LEAVE, 	21080).			%% 帮会成员离开
-define(PP_CLUB_UPGRADE_DEVICE, 21085).			%% 升级帮会设施，1商城，2,演武堂
-define(PP_CLUB_MEMBER_LIST, 	21091).			%% 帮会成员列表
-define(PP_CLUB_GET_NOTICE, 	21094).			%% 获取公告

-define(PP_CLUB_SUMMON, 21095).					%% 帮会活动召唤
-define(PP_CLUB_SUMMON_NUM, 21096).				%% 当天已召唤次数
-define(PP_CLUB_SUMMON_NOTICE, 21097).			%% 帮会召唤成功通知帮会成员
-define(PP_CLUB_PRAYER, 21098).					%% 帮会祈祷
-define(PP_CLUB_LIMIT_NUM_LIST, 21099).			%% 帮会限制次数列表
%%--------------------------------------------------


%%--------- 寄售信息-----------------------------------
-define(PP_SALES_ITEM_ADD, 22001).				%% 添加寄售物品
-define(PP_SALES_ITEM_DELETE, 22002).			%% 撤消寄售物品 
-define(PP_SALES_ITEM_QUERY, 22003).			%% 查询寄售物品
-define(PP_SALES_ITEM_BUY, 22004).				%% 购买寄售物品
-define(PP_SALES_ITEM_UPDATE, 22005).			%% 更新寄售物品
-define(PP_SALES_ITEM_QUERY_SELF, 22006).		%% 查看已寄售物品（我的寄售物品）
-define(PP_SALES_MONEY_ADD, 22007).				%% 添加铜币、元宝寄售
%% -define(PP_SALES_YB_DELETE, 22008).				%% 撤消元宝寄售
%% -define(PP_SALES_YB_UPDATE, 22009).				%% 更新元宝寄售
%% -define(PP_SALES_YB_TRADE, 22010).				%% 元宝寄售交易
-define(PP_SALES_SALE_AGAIN, 22011).			%% 再售
%%----------------------------------------------------

 
%%--------- 战斗信息------------------------------------
-define(PP_TARGET_ATTACKED_UPDATE, 23001).   %% 通知用户目标战斗信息更新
-define(PP_TARGET_DROPITEM_ADD, 23002).      %% 物品掉落信息
-define(PP_TARGET_DROPITEM_REMOVE, 23003).   %% 删除物品掉落信息

-define(PP_TARGET_DROPITEM_UPDATE, 23005).   %% 物品掉落信息更新
-define(PP_TARGET_ATTACKED_WAITING, 23006).  %% 大招，等待蓄气完成
-define(PP_TARGET_UPDATE_BLOOD, 23007).      %% 加血
%%-------------------------------------------------------

%%--------------boss 信息--------------------------------
-define(PP_BOSS_INFO, 23050).				%% 通知boss刷新时间信息
-define(PP_BOSS_ALIVE_NUM, 23051).			%% 通知boss存活数量

%%---------- pvp 信息------------------------------------
-define(PP_PVP_ACTIVE_START, 23060).			%% PVP活动开始
-define(PP_PVP_ACTIVE_JOIN, 23061).			%% 参加pvp活动
-define(PP_PVP_ACTIVE_QUIT, 23062).			%% 退出pvp活动
-define(PP_PVP_START,	23063).					%% pvp匹配成功
-define(PP_PVP_END, 23064).						%% PVP战斗结束
-define(PP_PVP_ACTIVE_FINISH, 23065).			%% PVP活动结束
-define(PP_PVP_EXPLOIT_INFO, 23066).			%% 功勋信息请求返回
%%--define().
%%--define().
-define(PP_ACTIVE_START_TIME_LIST, 23071).		%% 各活动开启时间状态
%%-------------------------------------------------------
%%答题活动
-define(PP_ACTIVE_QUESTION_ANSWER, 23081).		%% 开始答题（服务端推送题目）
-define(PP_ACTIVE_QUESTION_AWARD, 23082).		%% 答题结果奖励

%%巡逻活动+
-define(PP_ACTIVE_PATROL_JOIN, 23091).			%% 参加巡逻活动
-define(PP_ACTIVE_PATROL_START, 23092).			%% 巡逻开始
-define(PP_ACTIVE_PATROL_FINISH, 23093).		%% 巡逻结束

%%资源战场-----------------------------------------------
-define(PP_ACTIVE_RESOURCE_WAR_ENTER, 23101).	%% 进入资源战场
-define(PP_ACTIVE_RESOURCE_WAR_QUIT, 23102).	%% 退出资源战场
-define(PP_ACTIVE_RESOURCE_POINT_ADD, 23103).	%% 获得积分提示
-define(PP_ACTIVE_RESOURCE_TOP_LIST, 23104).	%% 资源战场排行榜
-define(PP_ACTIVE_RESOURCE_CAMP_CHANGE, 23105).	%% 转换阵营
-define(PP_ACTIVE_RESOURCE_RESULT, 23106).		%% 资源战结果

-define(PP_ACTIVE_PVP_FIRST_ENTER, 23111).	%% 进入天下第一战场
-define(PP_ACTIVE_PVP_FIRST_QUIT, 23112).	%% 退出天下第一战场
-define(PP_ACTIVE_PVP_FIRST_RESULT, 23113).		%% 天下第一战结果
-define(PP_ACTIVE_PVP_FIRST_THEFIRAST, 23114).	%% 天下第一角色数据

-define(PP_ACTIVE_MONSTER_ENTER, 23115).	%% 进入boss战
-define(PP_ACTIVE_MONSTER_QUIT, 23116).		%% 退出boss战
-define(PP_ACTIVE_MONSTER_TOP_LIST, 23117).	%% 活动boss伤害排行榜
%% -define(PP_ACTIVE_MONSTER_RESULT, 23118).		%% boss战结果
-define(PP_ACTIVE_MONSTER_GIFT, 23118).		%% boss战奖励物品

-define(PP_ACTIVE_GUILD_FIGHT_ENTER, 23119).	%% 进入帮会乱斗
-define(PP_ACTIVE_GUILD_FIGHT_QUIT, 23120).	%% 退出帮会乱斗
-define(PP_ACTIVE_GUILD_FIGHT_RESULT, 23121).		%% 帮会乱斗结果
-define(PP_ACTIVE_GUILD_FIGHT_KILL, 23122).			%% 帮会乱斗击杀数目
-define(PP_ACTIVE_GUILD_FIGHT_CONTINUE_TIME, 23123). 	%% 帮会乱斗剩余时间
-define(PP_ACTIVE_GUILD_FIGHT_THEFIRAST, 23132).	%% 帮会乱斗当前获取旗帜帮会信息
-define(PP_ACTIVE_GUILD_FIGHT_ITEM, 23133).	%% 帮会乱斗获取当前阶段性物品

-define(PP_ACTIVE_KING_FIGHT_SIGNUP_INFO, 23124). 	%% 王城战公会报名信息
-define(PP_ACTIVE_KING_FIGHT_SIGNUP, 23125). 	%% 王城战公会报名
-define(PP_ACTIVE_GET_SIGNUP_STATE, 23126). 	%% 获取王城战报名状态
-define(PP_ACTIVE_GET_CITYCRAFT_INFO, 23134).		%% 获取王城占领天数
-define(PP_ACTIVE_GUARD_INFO, 23135).		%% 守卫信息
-define(PP_ACTIVE_BUY_GUARD, 23136).		%% 购买守卫
-define(PP_ACTIVE_CHANGE_GUARD_POSITION, 23137).		%% 交换守卫位置
-define(PP_ACTIVE_DELETE_GUARD, 23138).		%% 删除守卫

-define(PP_ACTIVE_KING_FIGHT_ENTER, 23127). 	%% 进入王城战
-define(PP_ACTIVE_KING_FIGHT_QUIT, 23128). 	%% 退出王城战
-define(PP_ACTIVE_KING_WAR_TOP_LIST, 23129). 	%% 王城战积分前三
-define(PP_ACTIVE_KING_FIGHT_RESULT, 23130). 	%% 王城战结果 
-define(PP_ACTIVE_KING_WAR_CONTINUE_TIME, 23131). 	%% 王城战剩余时间

%%--------- 任务信息-------------------------------------
-define(PP_TASK_ACCEPT, 24001).              %% 接受任务
-define(PP_TASK_UPDATE, 24002).              %% 任务更新
-define(PP_TASK_CANCEL, 24003).              %% 任务取消
-define(PP_TASK_SUBMIT, 24004).              %% 任务提交
-define(PP_TASK_CLIENT, 24005).				 %% 客服端控制

-define(PP_TASK_QUERY, 24010).				 %% 任务查询
-define(PP_TASK_TRUST, 24020).				 %% 任务委托

-define(PP_TASK_QUALITY_REFRESH, 24021).	 %% 刷新运镖品质
-define(PP_TASK_START_CLUB_TRANSPORT, 24022).%% 开启帮会运镖
-define(PP_TASK_TRANSPORT_INIT,24023).		 %% 获取当前镖车品质
-define(PP_TASk_ALLSERVICE_TRANSPORT_TIME,24024).%% 获取全服运镖时间
-define(PP_TAsk_TRANSPORT_HELP,24025).		 %% 运镖求救


-define(PP_TOKEN_TASK_ACCEPT, 24031).		 %% 接受江湖令任务
-define(PP_TOKEN_TASK_PUBLISH, 24032).		%% 发布江湖令任务
-define(PP_TOKEN_USER_INFO, 24033).			%% 查看自己的江湖令任务
-define(PP_TOKEN_PUBLISH_LIST, 24034).		%% 查看发布江湖令任务
-define(PP_TOKEN_TRUST_FINISH, 24035).		%% 立即完成江湖令任务

-define(PP_TASK_SUBMIT_YUANBAO, 24040).      %% 立即完成任务
%%------------------------------------------------------


%%--------- 宠物信息-------------------------------------

-define(PP_PET_LIST_UPDATE, 25001).           	%% 宠物列表更新
-define(PP_PET_STATE_CHANGE,25002).				%% 宠物出战状态改变
-define(PP_PET_UPGRADE,25003).					%% 宠物升级(升级做通知)
-define(PP_PET_EXP_UPDATE,25004).				%% 宠物经验(暂时没有.移至人物经验包)
-define(PP_PET_GROW_UPDATE,25005).				%% 宠物成长更新
-define(PP_PET_QUALITY_UPDATE,25006).			%% 宠物资质更新
-define(PP_PET_STAIRS_UPDATE,25007).			%% 宠物进阶
-define(PP_PET_RELEASE,25008).					%% 宠物放生
-define(PP_PET_SKILL_UPDATE,25009).				%% 宠物技能更新
-define(PP_PET_REMOVE_SKILL,25010).				%% 宠物技能遗忘
-define(PP_PET_INHERIT,25011).					%% 宠物融合
-define(PP_PET_SKILL_ITEM_REFRESH,25012).		%% 宠物悟道
-define(PP_PET_CALL,25013).						%% 宠物召唤
-define(PP_PET_SKILL_ITEM_GET,25014).			%% 宠物技能书获得
-define(PP_PET_REMOVE_SKILL1,25015).			%% 宠物技能删除
-define(PP_PET_ATT_UPDATE,25016).				%% 宠物属性更新
-define(PP_PET_GET_SKILL_BOOK_LIST,25017).		%% 获取当前技能书的列表
-define(PP_PET_GET_OTHER_PETS,25018).			%% 获取宠物信息
-define(PP_PET_NAME_UPDATE,25019).              %% 宠物改名
-define(PP_PET_NAME_RELY,25020).				%% 宠物改名广播
-define(PP_PET_ENERGY_UPDATE,25021).			%% 宠物饱食度更新
-define(PP_PET_CHANGE_STYLE,25022).				%% 宠物幻形
-define(PP_PET_CHANGE_STYLE_REPLY,25023).		%% 宠物幻形广播
-define(PP_PET_XISUI_UPDATE,25024).				%% 宠物洗髓
-define(PP_PET_SKILL_STUDY,25025).				%% 宠物技能学习
-define(PP_PET_ATTACK,25027). 					%% 宠物攻击
%%------------------------------------------------------

%%--------- 宠物斗坛-------------------------------------
-define(PP_PET_BATTLE_JOIN, 25030).           	%% 加入宠物斗坛
-define(PP_PET_BATTLE_CHAMPION, 25031).           	%% 冠军榜
-define(PP_PET_BATTLE_CHALLENGE_LIST, 25032).           %% 宠物可挑战列表
-define(PP_PET_BATTLE_CHALLENGE,25033).			%% 宠物挑战
-define(PP_PET_BATTLE_TIME, 25034).           	%% 挑战次数，时间
-define(PP_PET_BATTLE_WINNING, 25035).           	%% 宠物连胜
-define(PP_PET_BATTLE_LOG, 25036).           	%% 宠物战日志
-define(PP_PET_BATTLE_CD_AND_BATTLE,25037).			%% 宠物连战减CD
-define(PP_PET_BATTLE_TOP_AWARD,25038).			%% 宠物战斗排行奖励
-define(PP_PET_BATTLE_SELF_PET,25039).			%% 宠物战斗自己的宠物
-define(PP_PET_BATTLE_SELF_LOG,25040).			%% 自己的宠物被打败

%%---------防沉迷信息-----------------------------------
-define(PP_INFANT_POST, 26001).              %%防沉迷信息提交和回复
-define(PP_INFANT_NOTICE, 26002).			 %%防沉迷填写通知
-define(PP_INFANT_OFF_LINE,26003).			 %%防沉迷下线通知
-define(PP_INFANT_CONTROL, 26004).			%%防沉迷开关控制(关防沉迷)
-define(PP_INFANT_SEND_STATE,26005).		%%通知客户端当前帐号防沉迷状态
%% ----------------------------------------------------

%%---------排行榜信息-----------------------------------
-define(PP_TOP_LIST, 26011).				%%个人排行
-define(PP_DUPLICATE_TOP_LIST, 26012).		%%副本排行
-define(PP_CHALLENGE_TOP_INFO, 26013).		%%试炼霸主信息
%% ----------------------------------------------------

%% --------直接交易信息---------------------------------
-define(PP_TRADE_REQUEST, 27001). 				%% 发起交易请求
-define(PP_TRADE_REQUEST_RESPONSE, 27002).		%% 通知对方发起交易请求
-define(PP_TRADE_ACCEPT, 27003).				%% 接受交易请求
-define(PP_TRADE_ACCEPT_RESPONSE, 27004).		%% 通知对方同意交易请求
-define(PP_TRADE_ITEM_ADD, 27005).				%% 添加交易物品、铜币、元宝; 
-define(PP_TRADE_ITEM_ADD_RESPONSE, 27006). 	%% 通知对方添加交易物品、铜币、元宝
-define(PP_TRADE_ITEM_REMOVE, 27007).			%% 移除交易物品、铜币、元宝; 
-define(PP_TRADE_ITEM_REMOVE_RESPONSE, 27008). 	%% 通知对方移除交易物品、铜币、元宝
-define(PP_TRADE_LOCK, 27009).					%% 锁定交易
-define(PP_TRADE_LOCK_RESPONSE, 27010).			%% 通知对方锁定交易
-define(PP_TRADE_SURE, 27011).					%% 确认交易
-define(PP_TRADE_SURE_RESPONSE, 27012).			%% 通知对方确定交易
-define(PP_TRADE_CANCEL, 27013).				%% 取消交易
-define(PP_TRADE_CANCEL_RESPONSE, 27014).		%% 通知对方取消交易
-define(PP_TRADE_START, 27015).					%% 通知双方进入交易状态
-define(PP_TRADE_RESULT, 27016).				%% 交易结果
-define(PP_TRADE_COPPER, 27017).				%% 交易铜币更新

%% ----------------------------------------------------


%%--------- 坐骑信息-------------------------------------
-define(PP_MOUNT_LIST_UPDATE, 28001).           %% 坐骑列表更新
-define(PP_MOUNT_STATE_CHANGE,28002).			%% 坐骑出战状态改变
-define(PP_MOUNT_UPGRADE,28003).				%% 坐骑喂养
-define(PP_MOUNT_EXP_UPDATE,28004).				%% 坐骑经验更新
-define(PP_MOUNT_GROW_UPDATE,28005).			%% 坐骑成长更新
-define(PP_MOUNT_QUALITY_UPDATE,28006).			%% 坐骑资质更新
-define(PP_MOUNT_STAIRS_UPDATE,28007).			%% 坐骑进阶
-define(PP_MOUNT_RELEASE,28008).				%% 坐骑放生
-define(PP_MOUNT_SKILL_UPDATE,28009).			%% 坐骑技能更新
-define(PP_MOUNT_REMOVE_SKILL,28010).			%% 坐骑技能遗忘
-define(PP_MOUNT_INHERIT,28011).				%% 坐骑融合
-define(PP_MOUNT_SKILL_ITEM_REFRESH,28012).		%% 坐骑悟道
-define(PP_MOUNT_SKILL_ITEM_GET,28013).			%% 坐骑技能书获得
-define(PP_MOUNT_REMOVE_SKILL1,28014).			%% 坐骑技能删除
-define(PP_MOUNT_ATT_UPDATE,28015).			%% 坐骑属性更新
-define(PP_MOUNT_GET_SKILL_BOOK_LIST,28016).	%% 获取当前技能书的列表
-define(PP_MOUNT_GET_OTHER_MOUNTS,28017).		%% 获取坐骑信息
-define(PP_MOUNT_REFINED_UPDATE, 28018).		%% 坐骑洗练


%%----------- 目标与成就  --------------------------------------------
-define(PP_TARGET_LIST_UPDATE,29001).			%% 目标列表更新
-define(PP_TARGET_GET_AWARD,29002).			 	%% 目标奖励获得
-define(PP_TARGET_ACHIEVEMENT_UPDATE,29003).	%% 成就值更新
-define(PP_TARGET_FINISH,29004).				%% 目标成就完成时通知
-define(PP_TARGET_HISTORY_UPDATE,29005).		%% 成就历史数据

-define(PP_MARRY_REQUEST, 29021).				%% 发起求婚请求
-define(PP_MARRY_REQUEST_NOTICE, 29022).		%% 通知求婚请求
-define(PP_MARRY_ECHO, 29023).					%% 返回求婚结果
-define(PP_MARRY_ECHO_NOTICE, 29024).			%% 返回求婚结果
-define(PP_SEND_INVITATION_CARD, 29025).		%% 发送请帖
-define(PP_GIVE_GIFT, 29026).					%% 送礼
-define(PP_SEE_GIFT_LIST, 29027).				%% 查看礼单
-define(PP_GET_CASH_GIFT, 29028).				%% 收取礼金(改成邮件所以现在不使用了)
-define(PP_SEND_CANDY, 29029).					%% 发送喜糖
-define(PP_START_MARRY, 29030).					%% 开始拜堂
-define(PP_MARRY_FINISH, 29031).				%% 婚礼结束
-define(PP_QUIT_HALL, 29032).					%% 离开礼堂  
-define(PP_MARRY_HALL_INFO,	29033).				%% 返回结婚礼堂相关信息
-define(PP_MARRY_LIST, 29034).					%% 结婚关系列表
-define(PP_MARRY_CHANGE, 29035).				%% 修改小妾为妻，原妻变妾10两
-define(PP_DIVORCE, 29036).						%% 离婚1普通，2强制收费（去除普通离婚）
-define(PP_DIVORCE_NOTICE, 29037).				%% 普通离婚通知（删除）
-define(PP_DIVORCE_REPLY, 29038).				%% 普通离婚处理（删除）

%%------------------------------------------------------


%%-------- 系统信息-------------------------------------
-define(PP_CENTER_RELAY, 30001).             %% 中心服务器广播
-define(PP_SYSTEM_MESS_ITEM, 30002).         %% 物品系统广播
-define(PP_NETWORK, 30003).                  %% 网络延迟
-define(PP_PING, 30004).                     %% PING
-define(PP_SYS_MESS, 30005).                 %% 系统消息
-define(PP_SYS_DATE, 30006).                 %% 系统时间
-define(PP_KICK_USER, 30007).                %% 踢人
-define(PP_OBSESSION_STATE, 30008).          %% 防沉迷状态
-define(PP_RSAKEY, 30009).                   %% rsa key

-define(PP_BAN_CHAT, 30010).                 %% 禁言
-define(PP_ALLOW_USER_LOGIN, 30011).         %% 允许用户登陆
-define(PP_USER_OFFLINE, 30012).             %% 用户下线
-define(PP_USER_ONLINE, 30013).              %% 用户上线
-define(PP_PAY, 30014).                      %% 付款

-define(PP_SYS_NOTICE, 30015).               %% 系统通知
-define(PP_CONFIG_RELOAD, 30016).            %% 配置更新
-define(PP_UPDATE_SERVER_STATE, 30017).      %% 更新服务器状态
-define(PP_SHUTDOWN, 30018).                 %% 关机
-define(PP_CENTER_INFO, 30019).              %% 中心服务器信息
-define(PP_NOTICE_CENTER, 30020).            %% 通知中心服务器
-define(PP_SERVER_LOGIN, 30021).             %% 系统登陆
-define(PP_PING_SERVER, 30022).              %% PING服务器


-define(PP_GM_SEND_MESSAGE, 30030).          %% GM发送反馈信息
%%-----------------------------------------------------


%%========================================================================
%% 测试用
%%========================================================================
-define(PP_PLAYER_ATTACK_AUTO, 20099).			%% 测试用玩家自动攻击
-define(PP_PLAYER_GET_DROPITEM_AUTO, 20098).	%% 测试用玩家自动拾取
-define(PP_PLAYER_COLLECT_AUTO, 20097).			%% 测试用玩家自动采集
-define(PP_ITEM_BUY_AUTO, 14099).				%% 测试用自动买物品
-define(PP_PLAYER_MOVE_AUTO, 12099).			%% 测试用自动走路
%%========================================================================

