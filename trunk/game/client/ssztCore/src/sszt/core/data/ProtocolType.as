package sszt.core.data
{
	public class ProtocolType
	{
		public static const ACCOUNT_LOGIN:uint = 10001;						//登陆
		public static const ACCOUNT_USERSLIST_RETURN:uint = 10002;			//返回角色列表
		public static const ACCOUNT_SELECT:uint = 10003;					//选择角色进入游戏; 返回人物信息
		public static const ACCOUNT_CREATE:uint = 10004;					//创建角色
		public static const ACCOUNT_HEARTBEAT:uint = 10006;					//心跳包
		
		public static const ACCOUNT_GUEST_LOGIN:uint = 10011;				//游客选择角色进入游戏
		public static const ACCOUNT_LOST_CONNECT:uint = 10012;				//帐号断开连接
		
		//------------- 地图信息---------------------------
		public static const MAP_ENTER:uint = 12001;							//进入地图
		public static const MAP_EXIT:uint = 12002;							//退出地图
		public static const MAP_USER_ADD:uint = 12003;						//地图用户添加
		public static const MAP_USER_REMOVE:uint = 12004;					//地图用户删除
		public static const MAP_MONSTER_INFO_UPDATE:uint = 12005;			//怪物信息更新
		public static const MAP_MONSTER_REMOVE:uint = 12006;				//删除怪物
		public static const MAP_ROUND_INFO:uint = 12007;					//获取地图人物信息
		
		public static const PLAYER_MOVE:uint = 12010;						//玩家移动
		public static const PLAYER_MOVE_STEP:uint = 12011;					//玩家移动同步
		public static const PLAYER_FOLLOW:uint = 12012;						//玩家跟随
		public static const PLAYER_RELIVE:uint = 12013;						//玩家复活
		public static const PLAYER_SIT:uint = 12014;						//玩家打坐
		public static const PLAYER_INVITE_SIT:uint = 12015;					//邀请打坐
		public static const PALYER_INVITE_SIT_RELAY:uint = 12016;			//邀请打坐回复
		public static const PLAYER_STYLE_UPDATE:uint = 12017;				//玩家形象更新
		public static const PLAYER_HANGUPDATA:uint = 12018;					//玩家挂机数据更新
		public static const DEFENCE_LIST:uint = 12019;						//正当防卫列表
		public static const PLAYER_PLACE_UPDATE:uint = 12020;				//玩家位置更新（同地图）		
		public static const MAP_PET_INFO_UPDATE:uint = 12021;				//宠物信息更新
		public static const MAP_PET_REMOVE:uint = 12022;					//宠物删除
		public static const SKILL_RELIVE:uint = 12023;						//技能复活
		public static const NEW_SKILL_ADD:uint = 12024;						// 新增技能添加到挂机技能中
		
		public static const REMOVE_MONSTER:uint = 12030;					//移除怪物
		public static const MAP_COLLECT_UPDATE:uint = 12031;				//采集信息更新
		
		public static const PLAYER_LIFE_EXP_SIT:uint = 12070;				//历练专修
		
		//--------------副本----------------------------------
		public static const COPY_ENTER:uint = 12041;						//进入副本
		public static const COPY_TEAM_ENTER:uint = 17021;					//队长询问是否进入副本
		public static const COPY_ENTER_COUNT:uint = 12042;					//获取副本进入次数列表
		public static const COPY_LEAVE:uint = 12043;						//离开副本
		public static const COPY_NEXT_MONSTER_TIME:uint = 12044;			//下波怪出现时间
		public static const COPY_TOWER_ENTER:uint = 12045;					//守塔副本从特定波数进入
		public static const COPY_INFO:uint = 12046;						//副本信息%% 用户掉线后重新连接返回副本信息
		
		public static const COPY_CAN_OPEN_NEXT_MONSTER:uint = 12370;		//可以开放下一波怪物
		public static const COPY_OPEN_NEXT_MONSTER:uint = 12371;			//释放下波怪物
		public static const COPY_GUARD_KILL_AWARD:uint = 12372;			//防守怪物击杀奖励
		
		public static const COPY_PASS_REMAIN_MONSTER:uint = 12380;		//剩余怪物数		
		public static const COPY_PASS_MISSION_INFO:uint = 12381;			//本层数据信息
		
		public static const COPY_PASS:uint = 12382;			//副本通关（0通关，1通本）
		
		public static const COPY_TEAM_APPLY:uint = 12046;					//副本队伍报名
		public static const COPY_TEAM_APPLY_NOTICE:uint = 12047;			//队伍报名状态广播
		public static const COPY_TEAM_CONFIRM:uint = 12048;					//撮合队伍确认进入
		public static const COPY_LIMIT_NUM_RESET:uint = 12049;						//清除副本次数限制
		
		public static const VIP_MAP_ENTER:uint = 12050;						//进入vip地图
		public static const VIP_MAP_LEAVE:uint = 12051;						//离开vip地图
		
		public static const COPY_LOTTERY:uint = 12048;						//副本抽奖
		
		
		//---------------神魔乱斗------------------//
		public static const SHENMO_ENTER_WAR:uint = 12061;					//进入战场
		public static const SHENMO_LEAVE_WAR:uint = 12062;					//离开战场
		public static const SHENMO_WARLIST_UPDATE:uint = 12063;				//战场列表更新
		public static const SHENMO_MEMBERLIST_UPDATE:uint = 12064;			//战场用户信息
		public static const SHENMO_MYWAR_INFO_UPDATE:uint = 12065;			//我的战报信息(杀和被杀)
		public static const SHENMO_WARTIME_UPDATE:uint = 12066;				//战场状态，剩余时间
		public static const SHENMO_WARRESULT_UPDATE:uint = 12067;			//战场结果累计
		public static const SHENMO_WARAWARD:int = 12068;					//乱斗领取奖励
		public static const SHENMO_WARRELIVE:int = 12069;					//乱斗复活
		
		//----------------------帮会据点战--------------------------//
		public static const CLUB_POINT_ENTER:uint = 12080;					//进入据点战场
		public static const CLUB_POINT_LEAVE:uint = 12081;					//离开据点战场
		public static const CLUB_POINT_SCENE_INFO:uint = 12082;				//据点战场概况
		public static const CLUB_POINT_RANK:uint = 12083;					//据点战场排行
		public static const CLUB_POINT_REWARDS:uint = 12085;				//据点战场奖励
		public static const CLUB_POINT_TIME:uint = 12086;					//据点战场剩余时间
		public static const CLUB_POINT_PERSONINFO:uint = 12087;				//帮会战个人信息
		
		
		//----------------个人乱斗--------------------//
		public static const PERWAR_ENTER_WAR:uint = 12320;					//进入战场
		public static const PERWAR_LEAVE_WAR:uint = 12321;					//离开战场
		public static const PERWAR_WARLIST_UPDATE:uint = 12322;				//战场列表更新
		public static const PERWAR_MEMBERLIST_UPDATE:uint = 12323;			//战场用户信息
		public static const PERWAR_WARAWARD:int = 12324;					//乱斗领取奖励
		public static const PERWAR_MYWAR_INFO_UPDATE:uint = 12325;			//我的战报信息(杀和被杀)
		public static const PERWAR_WARTIME_UPDATE:uint = 12326;				//战场状态，剩余时间
		public static const SHENMO_ISLAND_RANK:uint = 12338;				//神魔岛排行数据查询
		
		//神魔岛
		public static const COPY_ISLAND_LEAVE:uint = 12330;					//离开神魔岛
		public static const COPY_ISLAND_LEADER_ENTER:uint = 12331;			//队长进入条件判断
		public static const COPY_ISLAND_TEAMER_ENTER:uint = 12332;			//队员进入条件判断
		public static const COPY_ISLAND_ENTER:uint = 12333;					//进入神魔岛
		public static const COPY_ISLAND_DOOR_ENTER:uint = 12334;			//跳转门进入
		public static const COPY_ISLAND_CLEAN:uint = 12335;					//清空进入副本前的数据
		public static const COPY_ISLAND_MAININFO:uint = 12336;				//神魔岛统计数据
		public static const COPY_ISLAND_KINGINFO:uint = 12337;				//神魔岛霸主数据
		public static const COPY_ISLAND_SHOWREWARD:uint = 12339;			//神魔岛退出奖励显示
		public static const COPY_ISLAND_MONSTERCOUNT:uint = 12340;			//神魔岛怪物数量
		public static const COPY_ISLAND_RELIVE:uint = 12341;				//神魔岛复活
		

		
		//----------------------水晶争夺战--------------------------//
		public static const CRYSTAL_WAR_ENTER:uint = 12350;					//进入据点战场
		public static const CRYSTAL_WAR_LEAVE:uint = 12351;					//离开据点战场
		public static const CRYSTAL_WAR_SCENE_INFO:uint = 12352;				//水晶战场概况
		public static const CRYSTAL_WAR_RANK:uint = 12353;					//水晶战场排行
		public static const CRYSTAL_WAR_TIME:uint = 12354;					//水晶战场剩余时间
		public static const CRYSTAL_WAR_REWARDS:uint = 12355;				//水晶战场奖励
		public static const CRYSTAL_WAR_PERSONINFO:uint = 12356;				//水晶战个人信息
		public static const CRYSTAL_WAR_RELIVE:uint = 12357;				//水晶战复活
		
		//-----打钱副本
		public static const COPY_CLEAR_DROPITEM_ALL:uint = 12360;				//清除全部物品
		public static const COPY_CLEAR_MOUNSTER_ALL:uint = 12361;				//清除全部怪物
		public static const COPY_UPDATE_BATTER_NUM:uint = 12362;				//更新连击数
		public static const COPY_PICKUP_MONEY_AMOUNT:uint = 12363;			//更新拾取货币数两
		//public static const COPY_KILL_BOSS:uint = 12364;						//杀死boss进入拾取货币阶段（可以使用清除全部怪物同时执行）
		public static const COPY_RAND_MONEY:uint = 12365;						//随机掉落铜币数量
		
		//------------------副本商店-------------------------------//
		public static const DUPLICATE_SHOP_SALE_NUM:uint = 12390;			//返回商品可购买数量
		public static const DUPLICATE_SHOP_BUY:uint = 12391;				//请求购买
			
		//----------------PK擂台-------------------//
		public static const PK_INVITE:uint = 12090;							//pk邀请
		public static const PK_RESPONSE:uint = 12091;						//pk回应
		public static const PK_RESULT:uint = 12092;							//pk结果
		//-----------------------温泉----------------------//
		public static const SPA_ENTER:uint = 12101;							//温泉进入
		public static const SPA_LEAVE:uint = 12102;							//温泉离开
		public static const SPA_POND:uint = 12103;							//进入温泉池
		public static const SPA_ICON_TIME:uint = 12104;						//温泉图标时间
		
		//-------------------------boss战------------------------//
		public static const BOSS_WAR_MAIN_INFO:uint = 12200;				//boss战时间信息
		public static const BOSS_WAR_SINGLE_BOSS_UPDATE:uint = 12201;		//单个boss刷新
		
		//---------------------玩家行为公告----------------------//
		public static const PLAYER_NOTICE:uint = 12300;						//玩家行为公告
		
		//----------------------跨服地图-------------------------------//
		public static const ACROSS_SERVER_BOSS_ENTER:uint = 12310;			//跨服场景进入
		public static const ACROSS_SERVER_BOSS_LEAVE:uint = 12311;			//跨服场景离开
		
		//----------------------红名岛-------------------------------//
		public static const PRISION_LEAVE:uint = 12400;						//离开红名岛	
		
		//--------------------个人中心-------------------//
		public static const PERSONAL_MAININFO:uint = 0;					//个人面板信息
		public static const PERSONAL_INFO_CHANGE:uint = 0;				//个人面板信息修改
		public static const PERSONAL_REWARDS:uint = 0;					//个人面板领取奖励
		public static const PERSONAL_RANDOM:uint = 20094;					//个人面板随机切磋
		
		public static const PERSONAL_FRIEND_UPGRADE:uint = 20100;			//个人面板好友升级提示
		public static const PERSONAL_FRIEND_DEAD:uint = 20101;				//个人面板好友被杀提示
		public static const PERSONAL_FRIEND_TASK_SHARE:uint = 20102;		//个人面板好友任务共享
		public static const PERSONAL_CLUB_UPGRADE:uint = 20105;				//帮会升级提示
		public static const PERSONAL_CLUBMATE_UPGRADE:uint = 20106;			//帮会成员升级提示
		public static const PERSONAL_CLUBMATE_DEAD:uint = 20107;			//帮会成员被杀提示
		public static const PERSONAL_CLUBTASK_SHARE:uint = 20108;			//帮会成员任务共享
		public static const PERSONAL_LUCKY_LISTINFO:uint = 14065;			//幸运轮盘图标数据
		public static const PERSONAL_LUCKY_SELECTINFO:uint = 14066;			//幸运轮盘选中数据

		//------------ 物品信息------------------------------
		public static const ITEM_STALL:uint = 14001;						//道具摆摊
		public static const ITEM_SPLIT:uint = 14002;						//道具拆分
		public static const ITEM_ARRANGE:uint = 14003;						//道具整理
		public static const ITEM_RETRIEVE:uint = 14004;						//道具回收
		public static const BAG_EXTEND:uint = 14005;						//背包扩充
		public static const ITEM_PLACE_UPDATE:uint = 14006;					//物品更新
		public static const ITEM_MOVE:uint = 14007;							//移动物品
		public static const PET_ITEM_PLACE_UPDATE:uint = 14008;		//宠物物品更新
		
		public static const FIREWORK_PLAY:uint = 14100;						//烟花播放
		public static const ROSE_PLAY:uint = 14101;							//玫瑰播放
		
		public static const PP_SHENMO_REFRESH_STATE:uint = 14071;			//神魔令刷新品质
		
		public static const ITEM_STALL_STATE_REPLY:uint = 14009;			//摊位状态[收摊或暂停、摆摊](广播)
		
		//-------------------------天工炉----------------------------
		public static const ITEM_STRENG:uint = 14011;						//道具强化
		public static const ITEM_USE:uint = 14012;							//道具使用
		public static const ITEM_BUY:uint = 14014;							//道具购买
		public static const ITEM_BUY_BACK:uint = 14017;						//道具回购
		public static const ITEM_BUY_BACK_UPDATE:uint = 14018;				//道具回购更新
		public static const ITEM_ENCHASE:uint = 14019;						//道具镶嵌
		public static const ITEM_REBUILD:uint = 14020;						//道具重铸
		public static const ITEM_REMOVE:uint = 14021;						//宝石摘取
		public static const ITEM_EQUIP_SPLIT:uint = 14022;					//装备分解
		public static const ITEM_STRENGTH_TRANSFORM:uint = 14023;			//装备强化转移
		public static const ITEM_REPLACE_REBUILD:uint = 14024;			//替换鉴定属性
		public static const ITEM_TAP:uint = 14025;							//装备开孔
		public static const ITEM_FIX:uint = 14027;							//道具修理
		public static const ITEM_FIRE:uint = 14028;							//道具炼制
		public static const ITEM_SELL:uint = 14029;							//道具出售
		public static const ITEM_UPGRADE:uint = 14030;						//升级成橙色装备
		public static const ITEM_SCORE:uint = 14031;						//装备评分
		public static const ITEM_UPLEVEL:uint = 14032;						//装备升级
		public static const ITEM_LUCKY_COMPOSE:uint = 14033;				//物品合成
		public static const ITEM_WUHUN_UPGRADE:uint = 14034;    			//武魂升级
		public static const ITEM_MULTI_FIRE:uint = 14035;						//道具批量合成
		
		public static const ITEM_DISCOUNT:uint = 14037;						//获取优惠商品
		public static const ITEM_DISCOUNT_UPDATE:uint = 14038;				//优惠商品数量更新
		public static const ITEM_DISCOUNT_BUY:uint = 14039;					//优惠商品购买
		public static const ITEM_EXPLOIT_BUY:uint = 14040;					//功勋购买
		public static const IITEM_EXCHANG_BUY:uint = 14046;					//物品兑换 （神木203019蚕丝203016）
		public static const ITEM_REPAIR:uint = 14041;						//道具修理
		public static const ITEM_COMPOSE:uint = 14042;						//宝石合成
		public static const ITEM_EQUIP_COMPOSE:uint = 14043;				//装备融合
//		public static const ITEM_LOCK_UPDATE:uint = 14043;                  //道具加锁状态更新
//		public static const SKILLBAR_ITEM_USE:uint = 14044;					//快捷栏道具使用
		public static const ITEM_REFER:uint = 14045;						//查询道具
		
		public static const DEPOT_ITEM_UPDATE:uint = 14050;					//仓库物品更新 
		public static const BANK_UPDATE:uint = 14051;						//仓库存取款
		public static const QUENCHING:uint = 14052;						//宝石淬炼
		public static const EQUIP_FUSE:uint = 14054;							//装备熔炼
		public static const USE_TRANSFER_SHOE:uint = 14060;					//飞天鞋使用
		
		public static const SHENMOLING_ADD_TASK:uint = 14070;               //新增神魔令任务
		
		
		public static const SM_OPEN_BOX:uint = 14080;							//开箱子 
		public static const SM_REMOVE_STORE_ITEM:uint = 14081;				//移除仓库物品
		public static const SM_SOTRE_ITEM_UPDATE:uint = 14082;				//获取神魔仓库物品信息
		public static const SM_GAIN_ITEM_INIT:uint = 14083;					//获取开箱子所得物品
		public static const SM_BOX_MSG_ADD:uint = 14084;						//开箱子开出极品装备广播信息
		public static const SM_NEAR_BOX_MSG:uint = 14085;						//开箱子最近开出极品装备信息
		public static const SM_STORE_INFO_UPDATE:uint = 14086;				//开箱子后仓库物品增加
		
		
		public static const MYSTERY_SHOP_LAST_UPDATE_TIMER:uint = 14090;		//神秘商店更新时间
		public static const MYSTERY_SHOP_INFO:uint = 14091;					//神秘商店商品实时信息
		public static const MYSTERY_SHOP_REFRESH:uint = 14092;				//神秘商店商品主动刷新
		public static const MYSTERY_SHOP_MSG_ADD:uint = 14093;				//神秘商店出极品并广播
		public static const MYSTERY_SHOP_NEAR_MSG:uint = 14094;				//开箱子最近开出极品装备信息
		public static const MYSTERY_SHOP_BUY:uint = 14095;					//开神秘商店商品购买
		
		
		public static const  ITEM_BATCH_USE:uint = 14201;						//批量使用
		
		
//		public static const STALL_ITEM_ADD:uint = 15031;					//添加道具摆摊
//		public static const STALL_ITEM_REMOVE:uint = 15032;					//摆摊道具移除
//		public static const STALL_ITEM_EMPTY:uint = 15033;					//清空摊位物品
		
//		public static const STALL_DELETE:uint = 15034;						//地图摆摊删除
//		public static const STALL_STATE_REPLY:uint = 15038;					//摆摊状态广播
		
		public static const STALL_CREATE:uint = 15000;						//开始摆摊
		public static const STALL_CANCEL:uint = 15010;						//取消摆摊
		public static const STALL_QUERY:uint = 15020;						//查询摊位信息
		public static const STALL_ITEM_SALE:uint = 15030;					//出售道具给摊位
		public static const STALL_ITEM_BUY:uint = 15040;					//摊位道具购买
		public static const STALL_STATE_UPDATE:uint = 15050;				//地图摆摊状态更新
		public static const STALL_UPDATE:uint = 15060;						//摊位更新
		public static const STALL_MESSAGE:uint = 15070;						//摆摊留言
		public static const STALL_LOG:uint = 15080; 						//摊位 购买 求购记录

		
		//---------------------------------------------------
		
		
		//----------- 聊天信息-------------------------------
		public static const CHAT:uint = 16001;								//用户聊天
//		public static const CHAT_SYSTEM_INFO:uint = 16002;					//系统消息
		//---------------------------------------------------
		
		//----------- 投资计划-------------------------------
		public static const BANK_BUY:uint = 16101;						// 银行投资购买
		public static const BANK_GET:uint = 16102;						// 银行投资红利领取
		public static const BANK_LIST:uint = 16103;					// 获取银行投资信息
		
		//----------- 组队信息-------------------------------
		public static const TEAM_INVITE:uint = 17001;						//组队邀请
		public static const TEAM_INVITE_MSG:uint = 17002;					//邀请信息
		public static const TEAM_UPDATE_MSG:uint = 17003;					//组队信息更新
		public static const TEAM_NOFULL_MSG:uint = 17004;					//未满队伍及未组队队员
		public static const TEAM_KICK:uint = 17005;							//逐出队伍
		public static const TEAM_LEAVE:uint = 17006;						//离开队伍
		public static const TEAM_DISBAND:uint = 17007;						//解散队伍
		public static const TEAM_LEADER_CHANGE:uint = 17008;				//更改队长
		public static const TEAM_CHANGE_SETTING:uint = 17009;				//队伍设置
//		public static const TEAM_FOLLOW_LEADER:uint = 17010;				//跟随队长
		public static const TEAM_STOPFOLLOW:uint = 17011;					//取消跟随
		public static const TEAM_BATTLEINFO:uint = 17012;					//血蓝更新
		public static const TEAM_CREATE:uint = 17013;						//创建队伍
		public static const TEAM_LEVEL_UPDATE:uint = 17014;				//队伍等级更新
		public static const TEAM_POSITION_UPDATE:uint = 17015;			//队伍位置更新
		//---------------------------------------------------
		
		
		//---------- 好友信息--------------------------------
		public static const FRIEND_STATE:uint = 18000;						//好友友好状态
		public static const FRIEND_SEND_ADD:uint = 18001;					//发送添加好友请求
		public static const FRIEND_UPDATE:uint = 18002;						//更新好友信息
		public static const FRIEND_GROUP_UPDATE:uint = 18003;				//更新好友分组名字
		public static const FRIEND_GET_LIST:uint = 18004;					//获取好友列表
		
		
		public static const FRIEND_DELETE:uint = 18012;						//好友删除
		public static const FRIEND_AUTO_REPLY:uint = 18013;					//自动回复设置
		public static const FRIEND_RESPONSE:uint = 18014;					//好友添加响应
		public static const FRIEND_ONLINE_STATE:uint = 18015;				//好友在线状态
		public static const FRIEND_ACCEPT:uint = 18016;						//好友同意拒绝
		public static const FRIEND_GROUP_CHANGE:uint = 18017;				//好友分组添加，改名
		public static const FRIEND_GROUP_DELETE:uint = 18018;				//分组删除
		public static const FRIEND_GROUP_MOVE:uint = 18019;					//分组移动
		public static const PLAYER_INFO:uint = 18020;						//查询用户信息
		public static const QUERY_FRIEND_INFO:uint = 18021;					//好友搜索
		public static const FRIEND_SYS_MESSAGE:uint = 18050;				//好友模块提示信息
		
		
		public static const FRIEND_AMITY_UPDATE:uint = 18023;				//好友度更新
		//---------------------------------------------------
		
		
		//---------- 邮件信息--------------------------------
		public static const MAIL_SEND:uint = 19001;							//邮件发送
		public static const MAIL_RECEIVE:uint = 19002;						//邮件收取
		public static const MAIL_READ:uint = 19003;							//邮件读取
//		public static const MAIL_RESPONSE:uint = 19004;						//邮件响应
		public static const MAIL_DELETE:uint = 19005;						//邮件删除
//		public static const MAIL_RECEIVE_LIST:uint = 19006;					//邮件列表
		public static const MAIL_UPDATE:uint = 19008;						//更新邮件
		public static const MAIL_CLEAR:uint = 19007;						//邮件一键清除
		public static const MAIL_GUILD:uint = 19020;						//群发帮会邮件
		//--------------------------------------------------
		
		
		//---------- 人物信息--------------------------------
		public static const LOGIN:uint = 20001;								//用户登陆
		public static const GETLOGINDATA:uint = 20002;						//获取登陆信息
		
		public static const UPDATE_SELF_INFO:uint = 20003;					//个人货币信息
		public static const UPDATE_USER_INFO:uint = 20004;					//更新玩家信息
		public static const UPDATE_SELF_EXP:uint = 20006;					//个人经验更新
		public static const UPDATE_PLAYER_LEVEL:uint = 20007;				//玩家升级广播
		public static const UPDATE_SELF_PHYSICAL:uint = 20008;				//个人体力更新
		public static const UPDATE_SELF_HONOR:uint = 20009;					//个人荣誉
		
		public static const CONFIG:uint = 20010;							//游戏设置
		public static const GET_RELEASE_TIME:uint = 20011;							//开服时间
		
		public static const BUFF_UPDATE:uint = 20012;						//buff更新
		public static const SKILL_LEARNORUPDATE:uint = 20013;				//技能学习/升级
		public static const SKILL_INIT:uint = 20014;						//用户技能加载
		public static const SKILL_BAR_INIT:uint = 20015;					//技能位置加载
		public static const PLAYER_DRAG_SKILL:uint = 20016;					//玩家拖放调整快捷栏技能
		public static const PLAYER_SET_HOUSE:uint = 20017;					//玩家上下马
		public static const PLAYER_CHOOSE_TITLE:uint = 20018;				//玩家选择称号
		public static const BUFF_CONTROL:uint = 20019;						//多倍经验开关
		
		public static const PLAYER_ROLE_NAME:uint = 20021;					//玩家称号信息
		public static const PLAYER_FIRST_TITLE:uint = 20022;					//首个称号
		
		public static const PLAYER_ATTACK:uint = 20031;						//玩家攻击
		public static const PLAYER_GET_DROPITEM:uint = 20032;				//玩家拾取
		
		public static const PLAYER_SELF_LIFEEXP:uint = 20040;				//玩家历练值更新
		public static const PLAYER_PK_MODE_CHANGE:uint = 20050;				//PK模式改变
		public static const PLAYER_PK_VALUE_CHANGE:uint = 20051;			//PK值更新
		
		
		public static const PLAYER_BREAK_AWAY:uint = 20110;				// 回到京城防卡死 
		
		public static const PLAYER_QQ_BUY_GOODS:uint = 20600;				// 获取交易token 
		
		public static const EXCHANGE_SILVER_MONEY:int = 20601; //兑换绑定银两
		
		public static const START_ENTRUSTING:int = 20610; //副本神游请求
		public static const QUICK_ENTRUSTING:int = 20611; //副本神游立即完成
		public static const STOP_ENTRUSTING:int = 20612; //副本神游中断
		
		public static const PLAYER_STOP_COLLECT:uint = 20060;				//玩家停止采集
		
		public static const PLAYER_START_COLLECT:uint = 20061;			//玩家开始采集
		
		public static const PLAYER_COLLECT:uint = 20062;					//玩家采集
		
		
		public static const PLAYER_ROLE_NAME_REMOVE:uint = 20063;					//
		
		public static const PLAYER_DYNAMIC_INFO:uint = 0;				//玩家动态属性更新		
		//----------------------------------------------------
		
		
		//--------- 帮会信息---------------------------------
		public static const CLUB_SKILL_INIT:uint = 20111;					//帮会技能更新协议
		public static const UPDATE_CLUB_EXPLOIT:uint = 20112;				//个人贡献更新
		public static const PLAYER_CLUB_FURNACE_INIT:uint = 20113;		//加载任务帮会神炉设置
		public static const GET_MAIL_GUILD_NUM:uint = 19021;		       //获取帮派群发邮件数量
		
		
		
		public static const HIDE_FASHION:uint = 20130;					//隐藏时装
		public static const HIDE_WEAPONACCES:uint = 20131;				//隐藏武饰
		
		//-------------经验减少----------//
		public static const REDUCE_EXP:uint = 20140;						//减少经验
		
		public static const YUANBAO_SCORE:uint = 20141;                  //充值积分
		
		
		public static const CLUB_CREATE:uint = 21001;						//帮会创建
		public static const CLUB_QUERYLIST:uint = 21002;					//帮会查询
		public static const CLUB_DETAIL:uint = 21003;						//帮会细节
		public static const CLUB_SET_NOTICE:uint = 21004;					//修改信息
		public static const CLUB_CONTRIBUTION:uint = 21005;					//帮会贡献
		public static const CLUB_GETWEAL:uint = 21006;						//领取福利
		public static const CLUB_GETPAY:uint = 21007;						//领取工资
		public static const CLUB_QUERYMEMBER:uint = 21008;					//查询帮会成员
		public static const CLUB_QUERYTRYIN:uint = 21009;					//查询申请列表
		public static const CLUB_CLEARTRYIN:uint = 21010;					//清除申请列表
		
		public static const CLUB_STORE_PAGEUPDATE:uint = 21011;			//获取仓库数据(分页获取)
		public static const CLUB_STORE_REQUEST_LIST:uint = 21012;			//帮会仓库物品待申请列表
		public static const CLUB_STORE_MY_REQUEST_LIST:uint = 21013;		//个人物品待申请列表
		public static const CLUB_STORE_GET:uint = 21014;					//帮会仓库取
		public static const CLUB_STORE_PUT:uint = 21015;					//帮会仓库存
		public static const CLUB_STORE_CHECK:uint = 21016;				//物品审核操作
		public static const CLUB_STORE_EVENT:uint = 21017;				//帮会仓库日志
		public static const CLUB_STORE_CANCEL_ITEM_REQUEST:uint = 21018;				//取消仓库物品申请
		
		public static const PP_ITEM_USER_GUILD_SHOP:uint = 14061;			//玩家购买帮会物品信息
		public static const PP_ITEM_GUILD_SHOP_BUY:uint = 14062;			//帮会商品购买
		
		
//		public static const CLUB_EVENT_UPDATE:uint = 21017;					//帮会记事
//		public static const CLUB_EVENT_ADD:uint = 21018;					//帮会记事添加
		public static const CLUB_DISMISS:uint = 21019;						//解散帮会
		public static const CLUB_LEVELUP:uint = 21020;						//帮会升级
		public static const CLUB_EXTEND_UPDATE:uint = 21021;				//帮会扩展更新
		public static const CLUB_EXTEND_ADD:uint = 21022;					//帮会扩展
		
		public static const CLUB_ARMY_UPDATE:uint = 21023;					//军团信息更新
		public static const CLUB_ARMY_CREATE:uint = 21024;					//创建军团
		public static const CLUB_ARMY_APPOINT:uint = 21025;					//任命团长
		public static const CLUB_ARMY_INVITE:uint = 21026;					//军团邀请
		public static const CLUB_ARMY_KICKOUT:uint = 21027;					//踢出军团
		public static const CLUB_ARMY_RENAME:uint = 21028;					//军团改名
		public static const CLUB_ARMY_ENOUNCE:uint = 21029;					//军团宣言
		
		public static const CLUB_TRYINRESPONSE:uint = 21030;					//申请答复
		public static const CLUB_TRYIN:uint = 21031;							//申请加入帮会
		public static const CLUB_KICKOUT:uint = 21032;						//踢出帮会
		public static const CLUB_TRANSFER:uint = 21033;						//帮会转让
		public static const CLUB_INVITE:uint = 21034;							//帮会邀请
		public static const CLUB_EXIT:uint = 21035;							//退出帮会
		public static const CLUB_DUTY_UPDATE:uint = 21036;					//职务列表更新
		public static const CLUB_DUTY_CHANGE:uint = 21037;					//帮会职务更改
		public static const CLUB_WEAL_UPDATE:uint = 21038;					//福利更新
		public static const CLUB_TRANSFER_RESPONSE:uint = 21039;				//帮会转让答复
		public static const CLUB_INVITE_RESPONSE:uint = 21040;				//帮会邀请答复
		public static const CLUB_LEVELUP_UPDATE:uint = 21041;					//帮会升级更新
		public static const CLUB_ARMY_INVITERESPONSE:uint = 21042;			//军团邀请答复
		public static const CLUB_SELF_EXPLOIT_UPDATE:uint = 21043;			//个人功勋更新
		public static const CLUB_ONLINE_UPDATE:uint = 21044;				    //在线状态更新
		
		public static const CLUB_NEWCOMER:uint = 21045;				    //帮会新加成员提醒
		public static const CLUB_NEWCOMER2:uint = 21046;				    //关照新成员成功
		
		public static const CLUB_FIRE_ICON_LEFT_TIME:uint = 21050;			//帮会篝火剩余时间
		public static const CLUB_ENTER_SCENCE:uint = 21051;					//进入帮会场景
		public static const CLUB_LEAVE_SCENCE:uint = 21052;					//离开帮会场景
		
		public static const CLUB_WAR_DECLEAR_INIT:uint = 21053;				//帮会宣战列表
		public static const CLUB_WAR_DEAL_INIT:uint = 21054;					//宣战处理列表
		public static const CLUB_WAR_ENEMY_INIT:uint = 21055;					//敌对帮会列表
		public static const CLUB_WAR_DECLEAR:uint = 21056;					//向其他帮会宣战
		public static const CLUB_WAR_DEAL:uint = 21057;						//宣战处理
		public static const CLUB_WAR_STOP:uint = 21058;						//停战
		public static const CLUB_WAR_REQUEST_RESPONSE:uint = 21059;			//宣战请求
		public static const CLUB_WAR_ENEMY_LIST_UPDATE:uint = 21060;			//敌对帮会列表更新
		public static const CLUB_CLEARTRYIN_PAGE:uint = 21061;				//清空当前页申请列表
		public static const CLUB_CONTRIBUTE_UPDATE:uint = 21062;				//贡献统计
		public static const CLUB_CONTRIBUTE_LOG:uint = 21063;					//贡献日志
		public static const CLUB_BACK_CAMP:uint = 21064;						//快速回营地
		public static const CLUB_TASK_USABLE_UPDATE:uint = 21070;				//帮会任务是否可接
		public static const CLUB_REMOVE_MEMBER_RETURN_INFO:uint = 21080;		//帮会删除成员返回信息
		
		public static const CLUB_SKILL_LEARN:uint = 21081;					//帮会技能学习
		public static const CLUB_SKILL_ACTIVE:uint = 21082;					//帮会技能激活
		public static const CLUB_GET_DEVICE_INFO:uint = 21083;				//获取帮会设施数据
		public static const ClUB_UPDATE_DEVICE_INFO:uint = 21084;				//修改设施数据
		public static const CLUB_UPGRADE_DEVICE:uint = 21085;					//升级帮会设施，1神炉，2商城
		public static const CLUB_CALL:uint = 21086;							//帮会召集
		public static const CLUB_MONSTER:uint = 21087;						//帮会神兽信息
		public static const CLUB_MONSTER_UPGRADE:uint = 21088;				//帮会神兽升级
		
		public static const CLUB_MEMBER_LIST:uint = 21091;					//帮会成员列表
		public static const CLUB_CHARGE_MASTER:uint = 21092;					//弹劾帮主
		
		
		public static const CLUB_GET_NOTICE:uint = 21094;
		
		public static const CLUB_SUMMON:uint = 21095;							//帮会活动召唤
		public static const CLUB_SUMMON_REMAINING_TIMES:uint = 21096;			//帮会活动召唤剩余次数信息
		
		public static const CLUB_SUMMON_NOTICE:uint = 21097;					//帮会召唤成功通知帮会中成员
		public static const CLUB_PRAYER:uint = 21098;							//帮会祈祷		
		public static const CLUB_PRAYER_TIMES:uint = 21099;					//帮会祈祷剩余次数
		
		//--------------------------------------------------
		
		
		//--------- 寄售信息-----------------------------------
		public static const CONSIGN_ADD:uint = 22001;						//添加寄售物品
		public static const CONSIGN_DELETE:uint = 22002;					//撤消寄售物品
		public static const CONSIGN_QUERY:uint = 22003;						//查询寄售物品 （搜索寄售）
		public static const CONSIGN_BUY:uint = 22004;					    //购买寄售物品
		public static const CONSIGN_UPDATE:uint = 22005;					//更新寄售物品
		public static const CONSIGN_QUERY_SELF:uint = 22006;				//查看已寄售物品（我的寄售）
		public static const CONSIGN_YUANBAO_ADD:uint = 22007;				//添加寄售货币
		public static const CONSIGN_MY_YUANBAO_DEAL:uint = 22008;			//我的元宝信息交易
		public static const CONSIGN_YUANBAO_UPDATE:uint = 22009;			//元宝列表更新
		public static const CONSIGN_YUANBAO_DEAL:uint = 22010;         		//元宝市场信息交易
		public static const CONSIGN_CONTINUE:uint = 22011;					//再售
		//----------------------------------------------------
		
		
		//--------- 战斗信息------------------------------------
		public static const TARGET_ATTACKED_UPDATE:uint = 23001;			//通知用户目标战斗信息更新
		public static const TARGET_DROPITEM_ADD:uint = 23002;				//物品掉落信息
		public static const TARGET_DROPITEM_REMOVE:uint = 23003;			//删除物品掉落信息
		public static const TARGET_DROPITEM_UPDATE:uint = 23005;			//物品掉落信息更新
		public static const TARGET_ATTACKED_WAITING:uint = 23006;			//大招，等待蓄气完成
		public static const TARGET_UPDATE_BLOOD:uint = 23007;				//加血等等
		public static const TARGET_REPEL:uint = 23011;						//击退
		//-------------------------------------------------------
		
		//--------- 活动信息--------------------------------------
		public static const ACTIVE_START:uint = 23060;				//活动开始
		public static const ACTIVE_FINISH:uint = 23065;				//活动结束
		
		
		public static const PVP_ACTIVE_JOIN:uint = 23061;					//参加pvp活动
		public static const PVP_ACTIVE_QUIT:uint = 23062;					//退出pvp活动
		public static const PVP_START:uint = 23063;						//pvp匹配成功
		public static const PVP_END:uint = 23064;							// PVP战斗结束
		
		public static const PVP_EXPLOIT_INFO:uint = 23066;				//功勋信息请求返回
		
		
		public static const ACTIVE_START_TIME_LIST:uint = 23071;				//各活动开启时间状态
		
		/** 开始答题（服务端推送题目） */
		public static const QUIZ_START:uint = 23081;
		/** 答题结果奖励 */
		public static const QUIZ_RESULT:uint = 23082;
		
		/**
		 * 多人pvp
		 * */
		public static const ACTIVE_RESOURCE_WAR_ENTER:uint = 23101; //进入资源战场
		public static const ACTIVE_RESOURCE_WAR_QUIT:uint = 23102; //退出资源战场
		
		public static const ACTIVE_RESOURCE_POINT_ADD:uint = 23103; //获得积分提示
		public static const ACTIVE_RESOURCE_TOP_LIST:uint = 23104; //资源战场排行榜
		public static const ACTIVE_RESOURCE_CAMP_CHANGE:uint = 23105; //转换阵营
		public static const ACTIVE_RESOURCE_RESULT:uint = 23106; //资源战结果
		
		public static const ACTIVE_PVP_FIRST_ENTER:uint = 23111; //进入天下第一战场
		public static const ACTIVE_PVP_FIRST_QUIT:uint = 23112; //退出天下第一战场
		public static const ACTIVE_PVP_FIRST_RESULT:uint = 23113; //天下第一战结果
		public static const ACTIVE_PVP_FIRST_INFO:uint = 23114; //天下第一角色数据
		
		public static const BIG_BOSS_WAR_ENTER:uint = 23115; //全民boss场景进入
		public static const BIG_BOSS_WAR_INFO:uint = 23117; //全民boss
		public static const BIG_BOSS_WAR_QUIT:uint = 23116; //全民boss退出
		public static const BIG_BOSS_WAR_RESULT:uint = 23118; //全民boss战斗结果
		
		public static const GUILD_PVP_ENTER:uint = 23119;//帮会乱斗进入
		public static const GUILD_PVP_QUIT:uint = 23120;//帮会乱斗退出
		public static const GUILD_PVP_RESULT:uint = 23121;//帮会乱斗结果
		public static const GUILD_PVP_KILL:uint = 23122;//帮会乱斗帮会击杀数
		public static const GUILD_PVP_RELOAD:uint = 23123;//帮会乱斗时间
		public static const GUILD_PVP_THEFIRAST:uint = 23132;//帮会乱斗旗帜持有帮会
		public static const GUILD_PVP_ITEM:uint = 23133;//帮会乱斗奖励领取
		
		public static const CITY_CRAFT_AUCTION_INFO:uint = 23124;// 	王城战公会报名信息
		public static const CITY_CRAFT_AUCTION:uint = 23125;// 	王城战公会报名
		public static const CITY_CRAFT_AUCTION_STATE:uint = 23126;// 	获取王城战报名状态					
		public static const CITY_CRAFT_ENTER:uint = 23127;// 	进入王城战
		public static const CITY_CRAFT_QUIT:uint = 23128;// 	退出王城战
		public static const CITY_CRAFT_TOP_LIST:uint = 23129;// 	王城战积分前三
		public static const CITY_CRAFT_RESULT:uint = 23130;// 	王城战结果 
		public static const CITY_CRAFT_CONTINUE_TIME:uint = 23131;// 	王城战剩余时间
		public static const CITY_CRAFT_DAYS:uint = 23134;// 	王城战占领信息
		public static const CITY_CRAFT_GUARD_INFO:uint = 23135;// 	王城守卫信息
		public static const CITY_CRAFT_BUY_GUARD:uint = 23136;// 	购买王城守卫
		public static const CITY_CRAFT_CHANGE_GUARD_POSITION:uint = 23137;// 	交换王城守卫位置
		public static const CITY_CRAFT_DELETE_GUARD:uint = 23138;// 	删除王城守卫
		
		//--------- 任务信息-------------------------------------
		public static const TASK_ACCEPT:uint = 24001;						//接受任务
		public static const TASK_UPDATE:uint = 24002;						//任务更新
		public static const TASK_CANCEL:uint = 24003;						//任务取消
		public static const TASK_SUBMIT:uint = 24004;						//任务提交
		public static const TASK_CLIENT:uint = 24005;						//客户端控制
		public static const TASK_TRUST:uint = 24020;						//任务委托
		
		public static const TRANSPORT_QUALITY_REFRESH:uint = 24021;			//刷新运镖品质
		public static const START_CLUB_TRANSPORT:uint = 24022;				//开启帮会运镖
		public static const TRANSPORT_QUALITY_INIT:uint = 24023;			//获取当前镖车品质
		public static const ALLSERVICE_TRANSPORT_TIME:uint = 24024;			//获取全服运镖时间
		public static const TRANSPORT_HELP:uint = 24025;					//运镖求救
		
		public static const TASK_TRUST_FINISH:uint = 24031;					//任务委托立即完成
		public static const TASK_QUICK_COMPLETE:uint = 24040;					//任务立即完成
		
		//------------------------------------------------------
		
		
		//---------- 宠物信息------------------------------------		
		public static const PET_LIST_UPDATE:uint = 25001;					//宠物列表更新
		public static const PET_STATE_CHANGE:uint = 25002;					//宠物出战状态改变
		public static const PET_UPGRADE:uint = 25003;					//宠物升级
		public static const PET_EXP_UPDATE:uint = 25004;					//宠物经验更新
		public static const PET_GROW_UPDATE:uint = 25005;//宠物成长更新
		public static const PET_QUALITY_UPDATE:uint = 25006;//宠物资质更新
		public static const PET_STAIRS_UPDATE:uint = 25007;//宠物进阶
		public static const PET_RELEASE:uint = 25008;//宠物放生
		public static const PET_SKILL_UPDATE:uint = 25009;//宠物技能更新
		public static const PET_SEAL_SKILL:uint = 25010;//宠物技能封印
		public static const PET_INHERIT:uint = 25011;//宠物融合
		public static const PET_SKILL_ITEM_REFRESH:uint = 25012;		// 宠物悟道
		public static const PET_SKILL_ITEM_GET:uint = 25014;			// 宠物技能书获得
		public static const PET_REMOVE_SKILL:uint = 25015;//宠物技能删除
		public static const PET_ATT_UPDATE:uint = 25016;	//宠物属性更新
		public static const PET_GET_SKILL_BOOK_LIST:uint = 25017;//获取宠物技能书列表
		public static const PET_NAME_UPDATE:uint = 25019;					//宠物改名
		public static const PET_ENERGY_UPDATE:uint = 25021;					//宠物饱食度更新
		public static const PET_CALL:uint = 25013;							//宠物召唤
		public static const PET_GET_OTHER_PETS:uint = 25018;			//获取宠物信息
		public static const PET_NAME_RELY:uint = 25020;						//宠物改名广播
		public static const PET_CHANGE_STYLE:uint = 25022;					//宠物幻形
		public static const PET_CHANGE_STYLE_REPLY:uint = 25023;			//宠物幻形广播
		public static const PET_STUDY_SKILL:uint = 25025;					//宠物技能学习
		public static const PET_ATTACK:uint = 25027;							//宠物攻击
		public static const PET_XISUI_UPDATE:uint = 25024;					//宠物洗髓
		
		public static const PET_PVP_INFO:uint = 25030;					//宠物pvp
		public static const PET_PVP_RANK_INFO:uint = 25031;					//宠物pvp排行
		public static const PET_PVP_CHALLENGE_INFO_UPDATE:uint = 25032;					//宠物挑战信息
		public static const PET_PVP_START_CHALLENGING:uint = 25033;					//宠物挑战
		public static const PET_PVP_CHALLENGE_TIMES_UPDATE:uint = 25034;					//宠物挑战剩余次数，时间更新
		public static const PET_PVP_LOG_LIST:uint = 25036;					//宠物挑战日志
		public static const PET_PVP_START_CHALLENGING_WITH_CLEAR_CD:uint = 25037;					//宠物清除cd并挑战
		public static const PET_PVP_GET_DAILY_REWARD:uint = 25038;					//宠物战斗排行日常奖励
		public static const PET_PVP_MY_PET_INFO:uint = 25039;					//petpvp我的宠物信息
		public static const PET_PVP_SELF_LOG:uint = 25040;					//petpvp我的日志更新
		
		
		//-------------------------------------------------------
		
		//------------防沉迷---------------------------------
		public static const ENTHRAL_SUBMIT:uint = 26001;					//防沉迷信息提交
		public static const ENTHRAL_NOTICE:uint = 26002;					//防沉迷通知
		public static const ENTHRAL_OFF_LINE:uint = 26003;					//防沉迷下线通知
		public static const ENTHRAL_CONTROL:uint = 26004;					//防沉迷开关控制
		public static const ENTHRAL_SEND_STATE:uint = 26005;				//防沉迷帐号当前状态更新
		
		//---------------交易--------------------------------
		public static const TRADE_REQUEST:uint = 27001;						//发起交易请求
		public static const TRADE_REQUEST_RESPONSE:uint = 27002;			//通知对方发起交易请求
		public static const TRADE_ACCEPT:uint = 27003;						//接受交易请求
		public static const TRADE_ACCEPT_RESPONSE:uint = 27004;				//通知对方同意交易请求
		public static const TRADE_ITEM_ADD:uint = 27005;					//添加交易物品、铜币、元宝; 
		public static const TRADE_ITEM_ADD_RESPONSE:uint = 27006;			//通知对方添加交易物品、铜币、元宝
		public static const TRADE_ITEM_REMOVE:uint = 27007;					//移除交易物品、铜币、元宝; 
		public static const TRADE_ITEM_REMOVE_RESPONSE:uint = 27008;		//通知对方移除交易物品、铜币、元宝
		public static const TRADE_LOCK:uint = 27009;						//锁定交易
		public static const TRADE_LOCK_RESPONSE:uint = 27010;				//通知对方锁定交易
		public static const TRADE_SURE:uint = 27011;						//确认交易
		public static const TRADE_SURE_RESPONSE:uint = 27012;				//通知对方确定交易
		public static const TRADE_CANCEL:uint = 27013;						//取消交易
		public static const TRADE_CANCEL_RESPONSE:uint = 27014;				//通知对方取消交易
		public static const TRADE_START:uint = 27015;						//通知双方进入交易状态
		public static const TRADE_RESULT:uint = 27016;						//交易结果
		public static const TRADE_COPPER:uint = 27017;						//交易铜币
		
		public static const MOUNTS_LIST_UPDATE:uint = 28001;           	// 坐骑列表更新
		public static const MOUNTS_STATE_CHANGE:uint = 28002;				// 坐骑出战状态改变
		public static const MOUNTS_UPGRADE:uint = 28003;					// 坐骑喂养
		public static const MOUNTS_EXP_UPDATE:uint = 28004;				// 坐骑经验更新
		public static const MOUNTS_GROW_UPDATE:uint = 28005;				// 坐骑成长更新
		public static const MOUNTS_QUALITY_UPDATE:uint = 28006;			// 坐骑资质更新
		public static const MOUNTS_STAIRS_UPDATE:uint = 28007;			// 坐骑进阶
		public static const MOUNTS_RELEASE:uint = 28008;					// 坐骑放生
		public static const MOUNTS_SKILL_UPDATE:uint = 28009;				// 坐骑技能更新
		public static const MOUNTS_REMOVE_SKILL:uint = 28010;				// 坐骑技能遗忘
		public static const MOUNTS_INHERIT:uint = 28011;					// 坐骑融合
		public static const MOUNTS_SKILL_ITEM_REFRESH:uint = 28012;		// 坐骑悟道
		public static const MOUNTS_SKILL_ITEM_GET:uint = 28013;			// 坐骑技能书获得
		public static const MOUNTS_REMOVE_SKILL1:uint = 28014;			// 坐骑技能删除
		public static const MOUNTS_ATT_UPDATE:uint = 28015;				// 坐骑属性更新
		public static const MOUNTS_GET_SKILL_BOOK_LIST:uint = 28016;//获取技能书列表
		public static const MOUNTS_GET_MOUNT_SHOW_ITEM_INFO:uint = 28017;//坐骑展示坐骑信息
		public static const MOUNTS_REFINED:uint = 28018;					//坐骑洗练
		
		
		
	
		//-------------领取每日奖励-------------------------
		public static const PLAYER_DAILY_AWARD:uint = 20071;				//每日奖励领取
		public static const PLAYER_DAILY_AWARD_LIST:uint = 20072;				//每日奖励列表
		public static const PLAYER_ACTIVY_COLLECT:uint = 20073;				//激活码领取奖励
		public static const PLAYER_WELF_SEARCH:uint = 20074;				//福利领取查询
		
		//-------------活动-------------------------
		public static const PLAYER_ACTIVE_AWARD:uint = 20075;				//活跃度礼包领取
		public static const PLAYER_ACTIVE_INFO:uint = 20076;				//活跃度详细信息
		public static const PLAYER_ACTIVE_REWARDS_STATE:uint = 20077;	//活跃度奖励领取状态
		public static const PLAYER_ACTIVE_NUM:uint = 20078;//活跃度值以及更新状态
		
		//------------vip------------------------------------
		public static const PLAYER_VIP_USE:uint = 20080;						//使用VIP
		public static const PLAYER_VIP_DETAIL:uint = 20081;					//vip明细    
		public static const PLAYER_VIP_AWARD:uint = 20082;					//vip奖励
		public static const PLAYER_VIP_ONE_HOUR:uint = 20083;					//成功使用VIP体验卡
		
		//------------经脉------------------------------------
		public static const VEINS_ACUPOINT_UPDATE:uint = 20201;					//升级筋脉
		public static const VEINS_GENGU_UPDATE:uint = 20202;					//升级根骨
		public static const VEINS_CLEAR_CD:uint = 20203;						//清除CD
		public static const VEINS_INIT:uint = 20204;							// 请求筋脉信息
		public static const VEINS_INFO:uint = 18022;							// 请求其他玩家筋脉信息
		//------------系统---------------------------------
		public static const CENTER_RELAY:uint = 30001;						//中心服务器广播
		public static const SYSTEM_MESS_ITEM:uint = 30002;					//物品系统广播
		public static const NETWORK:uint = 30003;							//网络延迟
		public static const PING:uint = 30004;								//PING
		public static const SYS_MESS:uint = 30005;							//系统消息
		public static const SYS_DATE:uint = 30006;							//系统时间
		public static const KICK_USER:uint = 30007;							//踢人
		public static const OBSESSION_STATE:uint = 30008;					//防沉迷状态
		public static const RSAKEY:uint = 30009;							//rsa key
		public static const BAN_CHAT:uint = 30010;							//禁言
		public static const ALLOW_USER_LOGIN:uint = 30011;					//允许用户登陆
		public static const USER_OFFLINE:uint = 30012;						//用户下线
		public static const USER_ONLINE:uint = 30013;						//用户上线
		public static const PAY:uint = 30014;								//付款
		public static const SYS_NOTICE:uint = 30015;						//系统通知
		public static const CONFIG_RELOAD:uint = 30016;						//配置更新
		public static const UPDATE_SERVER_STATE:uint = 30017;				//更新服务器状态
		public static const SHUTDOWN:uint = 30018;							//关机 
		public static const CENTER_INFO:uint = 30019;						//中心服务器信息
		public static const NOTICE_CENTER:uint = 30020;						//通知中心服务器
		public static const SERVER_LOGIN:uint = 30021;						//系统登陆
		public static const PING_SERVER:uint = 30022;						//PING服务器
		public static const GM_SEND_MESSAGE:uint = 30030;					//GM发送反馈信息
		
		//排行榜
		public static const RANK:uint = 26011;					//获取排行榜信息
		public static const DUPLICATE_TOP_LIST:uint = 26012;					//获取副本排行榜信息
		
		//登录奖励
		public static const WELFARE_UPDATE:uint = 20090;  //更新福利信息
		public static const WELFARE_RECEIVE:uint = 20091;  //领取连续登录福利
		public static const WELFARE_EXCHANGE:uint = 20092;  //兑换经验
		public static const WELFARE_LOGIN_DAY:uint = 20093;  //重置连续登录天数
		
		//boss
		public static const BOSS_INFO:uint = 23050;  //通知boss刷新时间信息
		public static const BOSS_ALIVE_NUM:uint = 23051;  //通知boss存活数量
		
		
		//江湖令
		public static const TOKEN_TASK_ACCEPT:uint = 24031;  //接受江湖令任务
		public static const TOKEN_TASK_PUBLISH:uint = 24032;  //发布江湖令任务
		public static const TOKEN_USER_INFO:uint = 24033;  //看自己的江湖令任务
		public static const TOKEN_PUBLISH_LIST:uint = 24034;  //查看发布江湖令任务
		public static const TOKEN_TRUST_FINISH:uint = 24035;  //立即完成江湖令任务
		
		//目标
		public static const TARGET_LIST_UPDATE:uint = 29001;  //目标列表更新
		public static const TARGET_GET_AWARD:uint = 29002;  //目标奖励获得
		public static const UPDATE_ACHIEVEMENT:uint = 29003;  //更新当前成就和总成就点数
		public static const TARGET_FINISH:uint = 29004;  //目标成就完成时通知
		public static const TARGET_HISTORY_UPDATE:uint = 29005;  //成就历史数据
		
		//结婚
		public static const MARRY_REQUEST:uint = 29021;  //发起求婚请求
		public static const MARRY_REQUEST_NOTICE:uint = 29022;  //通知求婚请求
		public static const MARRY_ECHO:uint = 29023;  //处理求婚，返回处理求婚结果
		public static const MARRY_ECHO_NOTICE:uint = 29024;  //返回求婚结果
		public static const SEND_INVITATION_CARD:uint = 29025;  //发送请帖
		public static const WEDDING_GIVE_GIFT:uint = 29026;  //送礼
		public static const WEDDING_SEE_GIFT_LIST:uint = 29027;  //查看礼单
		public static const WEDDING_GET_CASH_GIFT:uint = 29028;  //收取礼金
		
		public static const WEDDING_SEND_CANDY:uint = 29029;  //发送喜糖
		public static const START_WEDDING:uint = 29030;  //开始婚礼
		public static const END_WEDDING:uint = 29031;  //结束婚礼
		public static const WEDDING_QUIT_HALL:uint = 29032;  //离开礼堂  
		public static const MARRY_HALL_INFO:uint = 29033;  //返回结婚礼堂相关信息
		public static const MARRY_LIST:uint = 29034;  //结婚关系
		public static const MARRY_CHANGE:uint = 29035;  //修改小妾为妻，原妻变妾10两
		public static const DIVORCE:uint = 29036;  //离婚
		
		//试炼
		public static const ENTER_CHALLENGE_BOSS:uint = 12401;  //请求进入试炼副本
		public static const CHALLENGE_BOSS_INFO:uint = 12402;  //请求试炼副本记录信息
		public static const CHALLENGE_BOSS_PASS:uint = 12403; //试炼副本通关返回评星
		public static const CHALLENGE_NEXT_BOSS:uint = 12404; //挑战下一个试炼boss
		public static const CHALLENGE_TOP_INFO:uint = 26013; //获取试炼副本霸主信息
		
		public static const PLAYER_ACTIVE_OPEN_SERVER:uint = 20310; //开服相关活动 
		public static const PLAYER_ACTIVE_OPEN_SERVER_AWARD:uint = 20311; //领取开服相关活动的奖励
		public static const PLAYER_ACTIVE_FIRST_PAY:uint = 20312; //开服首充活动
		
		//黄钻
		public static const PLAYER_YELLOW_INFO:uint = 20400; //玩家黄钻信息
		public static const PLAYER_YELLOW_GET_REWARD:uint = 20401; //玩家黄钻奖励获取
		
		//七天嘉年华
		public static const ACTIVE_SEVEN:uint = 20500; //7天活动列表
		public static const ACTIVE_SEVEN_GETREWARD:uint = 20501; //7天活动列表奖励
		public static const ACTIVE_SEVEN_GETREWARD2:uint = 20502; //全民奖励
		
		//模板协议号
		/**
		 * 模板协议号 1000000
		 */		
		public static const TEMP_1:uint = 1000000;              //模板协议号1
		/**
		 * 模板协议号 1000001
		 */		
		public static const TEMP_2:uint = 1000001;              //模板协议号2
	}
}