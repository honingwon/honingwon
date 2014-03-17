package sszt.scene.events
{
	public class SceneMediatorEvent
	{
		public static const SCENE_COMMAND_START:String = "sceneCommandStart";
		public static const SCENE_COMMAND_END:String = "sceneCommandEnd";
		
		public static const SCENE_MEDIATOR_START:String = "sceneMediatorStart";
		public static const SCENE_MEDIATOR_DISPOSE:String = "sceneMediatorDispose";
		/**
		 * 弹开NPC对话框
		 */		
		public static const SCENE_MEDIATOR_SHOWNPCDIALOG:String = "sceneMediatorShowDialog";
		
		/**
		 * 切换场景
		 */		
		public static const SCENE_MEDIATOR_CHANGESCENE:String = "sceneChangeScene";
		/**
		 * 打开大地图
		 */		
		public static const SCENE_MEDIATOR_SHOWBIGMAP:String = "sceneShowBigMap";
		/**
		 *显示神魔乱斗面板 
		 */		
		public static const SCENE_MEDIATOR_SHOWSHENMOWAR:String = "sceneShowShenMoWar";
		/**
		 *领取帮会战奖励 
		 */		
		public static const SCENE_MEDIATOR_GET_CLUBWARREWARDS:String = "sceneMediatorGetClubWarRewards";
		/**
		 * 显示神魔奖励面板
		 */		
		public static const SCENE_MEDIATOR_SHOWSHENMOREWARDS:String = "sceneShowShenMoRewards";
		/**
		 *显示神魔荣誉商店 
		 */		
		public static const SCENE_MEDIATOR_SHOWSHENMOSHOP:String = "sceneShowShenMoShop"
		/**
		 *显示神魔图标 
		 */		
		public static const SCENE_MEDIATOR_SHOWSHENMOICON:String = "sceneShowShenMoIcon";
		/**
		 *显示帮会据点战图标 
		 */		
		public static const SCENE_MEDIATOR_SHOWCLUBPOINTWARICON:String = "sceneShowClubPointWarIcon";
		/**
		 *显示水晶战图标 
		 */		
		public static const SCENE_MEDIATOR_SHOWCRYTSALWARICON:String = "sceneShowCrystalWarIcon";
		/**
		 *显示水晶战排行版 
		 */		
		public static const SCENE_MEDIATOR_SHOWCRYSTALPOINTSCORE:String = "sceneShowCrystalPointScore";
		
		/**
		 *显示个人乱斗图标 
		 */		
		public static const SCENE_MEDIATOR_SHOWPERWARICON:String = "sceneShowPerWarIcon";
		/**
		 *显示帮会据点战排行版 
		 */		
		public static const SCENE_MEDIATOR_SHOWCLUBPOINTSCORE:String = "sceneShowClubPointScore";
		/**
		 *显示个人乱斗奖励面板
		 */		
		public static const SCENE_MEDIATOR_SHOWPERWAR_REWARDS:String = "sceneShowPerWarRewards";
//		/**
//		 *显示帮会据点战排名面板 
//		 */		
//		public static const SCENE_MEDIATOR_SHOWCLUBPOINTWARRANKING:String = "sceneShowClubPointWarRanking";
		/**
		 * 显示复活面板
		 */		
		public static const SCENE_MEDIATOR_SHOWRELIVE:String = "showRelive";
		
		/**
		 * 发送攻击
		 */		
		public static const SCENE_MEDIATOR_SENDATTACK:String = "sendAttack";
		
		/**
		 * 显示组队设置
		 */		
		public static const SCENE_MEDIATOR_SHOWGROUP:String = "showGroup";
		/**
		 * 显示附近面板
		 */		
		public static const SCENE_MEDIATOR_SHOWNEARLY:String = "showNearly";
		/**
		 * 显示组队邀请对话框
		 */		
		public static const SCENE_MEDIATOR_SHOWGROUPINVITE:String = "showGroupInvite";
		/**
		 * 显示快速副本面板
		 */
		public static const SCENE_MEDIATOR_SHOWCOPYGROUP:String = "showCopyGroup";
		/**
		 *打开npc副本界面 
		 */
		public static const SCENE_MEDIATOR_SHOWNPCCOPY:String = "showNpcCopy";
		/**
		 *打开神魔岛进入面板 
		 */		
		public static const SCENE_MEDIATOR_SHOWCOPYISLAND:String = "showIsland";
		/**
		 *打开挖宝地图 
		 */		
		public static const OPEN_TREASURE_MAP:String = "openTreasureMap";
		/**
		 * 
		 *打开温泉界面 
		 */		
		public static const SCENE_MEDIATOR_SHOWSPACOPY:String = "showSpaCopy";
		/**
		 *离开温泉场景 
		 */		
		public static const SCENE_MEDIATOR_LEAVE_SPACOPY:String = "leaveSpaCopy";
		/**
		 *显示温泉图标
		 */		
		public static const SCENE_MEDIATOR_SPA_ICON:String = "spaIcon";
		/**
		 *快速副本确认窗口 
		 */
		public static const SCENE_MEDIATOR_SHOWCOPYALERT:String = "ShowCopyElart";
		/**
		 *离开副本警告框 
		 */
		public static const COPY_ACTION:String = "copyAction";
		/**
		 *进入帮会场景警告框 
		 */		
		public static const CLUB_SCENE_ENTER:String = "clubSceneEnter";
		/**
		 *离开帮会场景警告框 
		 */		
		public static const CLUB_SCENE_LEAVE:String = "clubSceneLeave";
		/**
		 *快捷按钮 
		 */
		public static const QUICK_ICON_PANEL:String = "quickIconPanel";
		public static const QUICK_ICON_DISPOSE:String = "quickIconDispose";
		
		/**
		 * 成就完成面板 
		 */
		public static const TARGET_FINISH_PANEL:String = "targetFinishPanel";
		public static const TARGET_FINISH_DISPOSE:String = "targetFinishDispose";
		
		
		/**
		 * 新手礼包 
		 */
		public static const NEWCOMER_GIFT_ICON:String = "newcomerGiftIcon";
		public static const REMOVE_NEWCOMER_GIFT_ICON:String = "removeNewcomerGiftIcon";
		
		public static const SHOW_NEWCOMER_GIFT_PANEL:String = "showNewcomerGiftPanel";
		
		/**
		 * 事件面板
		 */		
		public static const SCENE_MEDIATOR_EVENTPANEL:String = "sceneMediatorEventPanel";
		/**
		 * 显示挂机设置面板
		 */		
		public static const SCENE_MEDIATOR_SHOWHANGUP:String = "sceneMediatorShowHangup";
		/**
		 * 显示挂机简单设置面板
		 */		
		public static const SCENE_MEDIATOR_SHOWSIMPLEHANDUP:String = "sceneMediatorShowSimpleHandup";		
		/**
		 * 走路
		 */		
		public static const SCENE_MEDIATOR_WALK:String = "sceneMediatorWalk";
		/**
		 * 走到NPC处
		 */		
		public static const SCENE_MEDIATOR_WALKTONPC:String = "sceneMediatorWalkToNpc";
		/**
		 * 走一步
		 */		
		public static const SCENE_MEDIATOR_WALKASTEP:String = "sceneMediatorWalkAStep";
		/**
		 * 攻击怪物
		 */		
		public static const SCENE_MEDIATOR_ATTACKMONSTER:String = "sceneMediatorAttackMonster";
		/**
		 * 显示经验补偿界面
		 */		
		public static const SCENE_MEDIATOR_SHOWEXPCOMPENSATE:String = "sceneMediatorShowExpCompensate";
		/**
		 * 
		 */
		public static const SCENE_MEDIATOR_TEAMACTION:String = "sceneMediatorTeamAction";
		/**
		 * 添加事件消息
		 */		
		public static const SCENE_ADD_EVENTLIST:String = "sceneAddEventList";
		/**
		 * 跟随玩家
		 */		
		public static const SCENE_MEDIATOR_FOLLOWPLAYER:String = "sceneMediatorFollowPlayer";
		/**
		 * 捡道具
		 */		
		public static const SCENE_MEDIATOR_PICKROUND:String = "sceneMediatorPickupRound";
		
		/**
		 * 应用技能栏
		 */		
		public static const SCENE_MEDIATOR_APPLYSKILLBAR:String = "sceneMediatorApplySkillBar";
		/**
		 * 打坐
		 */		
		public static const SIT:String = "sit";
		/**
		 * 打坐邀请
		 */		
		public static const SIT_INVITE:String = "sitInvite";
		/**
		 * 坐骑激活
		 */		
		public static const CHANGE_MOUNTAVOID:String = "changeMountAvoid";
		/**
		 * 显示双修说明
		 */		
		public static const SCENE_SHOWDOUBLESITINTRO:String = "sceneShowDoubleSitIntro";
		/**
		 * 显示双修
		 */		
		public static const SCENE_SHOWDOUBLESIT:String = "sceneShowDoubleSit";
		/**
		 * 历练专修
		 */		
		public static const SCENE_SHOW_LIFE_EXP_SIT:String = "sceneShowLifeExpSit";
		/**
		 * 发送双修邀请
		 */		
		public static const SEND_DOUBLESIT_INVITE:String = "sendDoubleSitInvite";
		/**
		 * 队伍设置改变
		 */		
		public static const TEAM_SETTING_CHANGE:String = "teamSettingChange";
//		/**
//		 * 跑过去双修
//		 */		
//		public static const WALKTO_DOUBLESIT:String = "walkToDoubleSit";
		/**
		 * 发起交易
		 */		
		public static const SEND_TRADEDIRECT:String = "sendTradeDirect";
		/**
		 * 收到交易申请
		 */		
		public static const GET_TRADEDIRECT:String = "getTradeDirect";
		/**
		 * 显示交易面板
		 */		
		public static const SHOW_TRADEDIRECT:String = "showTradeDirect";
		/**
		 * 玩家被打
		 */		
		public static const SELF_BEHIT:String = "selfBeHit";
		/**
		 * 玩家攻击
		 */		
		public static const SELF_HIT:String = "selfHit";
		
		/**
		 * 使用传送
		 */		
		public static const USE_TRANSFER:String = "useTransfer";
		/**
		 * 跑到中心点进行采集
		 */		
		public static const WALK_TO_CENTERCOLLECT:String = "walkToCenterCollect";
		/**
		 * 打开NPC弹窗
		 */		
		public static const OPEN_POP_PANEL:String = "openPopPanel";
		/**
		 * 更新帮会运镖状态
		 */		
		public static const UPDATE_CLUB_TRANSPORT:String = "updateClubTransport";
		/**
		 * 打开运镖窗口
		 */		
		public static const OPEN_TRANSPORT_PANEL:String = "openTransportPanel";
		/**
		 * 更改PK模式
		 */		
		public static const CHANGE_PK_MODE:String = "changePKMode";
		/**
		 *PK邀请 
		 */		
		public static const PK_INVITE:String = "pkInvite";
		/**
		 * 显示复活确认
		 */		
		public static const SHOW_RELIVE_MALERT:String = "showReliveMalert";
//		/**
//		 * 激活坐骑
//		 */		
//		public static const SCENE_MEDIATOR_MOUNTAVOID:String = "sceneMediatorMountAvoid";
		
		/**
		 * 进入副本
		 */		
		public static const COPY_ENTER:String = "copyEnter";
		
		
		/**
		 * 显示泡泡
		 */		
		public static const SHOW_PAOPAO:String = "showPaopao";
		/**
		 * 进出泳池
		 */		
		public static const TOSWIM:String = "toSwim";
		
		/**
		 * 打开接镖面板
		 */
		public static const SHOW_ACCEPT_TRANSPORT_PANEL:String = "showAcceptTransportPanel";
		/**
		 * 获取镖车品质
		 */
		public static const INIT_TRANSPORT_QUALITY:String = "initTransportQuality";
		/**
		 * 获取全服运镖剩余时间
		 */
		public static const INIT_SERVER_TRANSPORT_TIME:String = "initServerTransportTime";
		
		public static const SHOW_SERVER_TRANSPORT_PANEL:String = "showServerTransportPanel";
		/**
		 * 播放烟花
		 */		
		public static const FRIEWORK_PLAY:String = "fireWorkPlay";
		/**
		 * 播放玫瑰
		 */		
		public static const ROSE_PLAY:String = "rosePlay";
		
		/**
		 * 停止移动 
		 */		
		public static const STOP_MOVING:String = "StopMoving";
		
		/**
		 * 初始化场景小图标
		 */
		public static const INIT_FUNCTION_ICON:String = "initFunctionIcon";
		
		/**
		 * 药品提醒
		 */
		public static const SHOW_MEDICINES_CAUTION_PANEL:String = "showMedicinesCautionPanel";
		
		/**
		 * 显示在线奖励面板 
		 */		
		public static const SHOW_BANK_PANEL:String = "showBankPanel";
		/**
		 * 显示在线奖励面板 
		 */		
		public static const SHOW_ONLINE_REWARD_PANEL:String = "showOnlineRewardPanel";
		
		/**
		 * 显示试炼结果面板
		 */		
		public static const SHOW_CHALLENGE_PANEL:String = "showChallengePanel";
		
		/**
		 * 显示pvp战斗结果面板 
		 */		
		public static const SHOW_PVP_RESULT_PANEL:String = "showpvpResulePanel";
		/**
		 * 参加pvp面板 
		 */		
		public static const SHOW_PVP_CLUE_PANEL:String = "showpvpCluePanel";

		
		/**
		 * 副本抽奖
		 */
		public static const DUPLICATE_LOTTERY_ATTENTIION:String = "duplicateLotteryAttention";
		public static const SHOW_DUPLICATE_LOTTERY_PANEL:String = "showDuplicateLotteryPanel";
		
		/**
		 * 显示死亡tips
		 * */
		public static const SHOW_DEATH_TIP:String = "showDeathTip";
		
		/**
		 * 打开爬塔副本入口界面
		 * */
		public static const SHOW_CLIMBING_TOWER:String = "showClimbingTower";
		
		/**
		 * 打开资源战场入口界面
		 * */
		public static const SHOW_RESOURCE_WAR_ENTRANCE_PANEL:String = "showResourceWarEntrancePanel";
		
		/**
		 * 打开帮会乱斗入口界面
		 * */
		public static const SHOW_GUILD_PVP_ENTRANCE_PANEL:String = "showGuildPvpEntrancePanel";
		/**
		 * 打开天下第一战场入口界面
		 * */
		public static const SHOW_PVP_FIRST_ENTRANCE_PANEL:String = "showPvpFirstEntrancePanel";
		/**
		 * 打开王城争霸入口界面
		 * */
		public static const SHOW_CITY_CRAFT_GUILD_ENTER:String = "showCityCraftGuildEnter";
		public static const SHOW_CITY_CRAFT_ENTRANCE_PANEL:String = "showCityCraftEntrancePanel";
		/**
		 * 打开王城争霸竞拍界面
		 * */
		public static const SHOW_CITY_CRAFT_AUCTION_PANEL:String = "showCityCraftAuctionPanel";
		/**
		 * 打开王城争霸召唤boss界面
		 * */
		public static const SHOW_CITY_CRAFT_CALL_BOSS_PANEL:String = "showCityCraftCallBossPanel";
		/**
		 * 打开王城争霸管理界面
		 * */
		public static const SHOW_CITY_CRAFT_MANAGE_PANEL:String = "showCityCraftManagePanel";
		
		public static const CITY_CRAFT_START:String = "cityCraftStart";
		public static const CITY_CRAFT_END:String = "cityCraftEnd";
		public static const CITY_CRAFT_DISPOSE:String = "cityCraftDispose";
		/**
		 * 打坐提示 
		 */		
		public static const TIME_SIT_TASK_WARN:String = "timeSitTaskWarn";
		
		/**
		 * 全民boss
		 * */
		public static const BIG_BOSS_WAR_START:String = "bigBossWarStart";
		public static const BIG_BOSS_WAR_END:String = "bigBossWarEnd";
		public static const BIG_BOSS_WAR_DISPOSE:String = "bigBossWarDispose";
		
		/**
		 * 帮会乱斗
		 * */
		public static const GUILD_PVP_START:String = "guildPVPStart";
		public static const GUILD_PVP_END:String = "guildPVPEnd";
		public static const GUILD_PVP_DISPOSE:String = "guildPVPDispose";
	}
}