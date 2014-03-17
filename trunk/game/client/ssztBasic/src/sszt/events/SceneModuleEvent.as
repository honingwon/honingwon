package sszt.events
{
	import flash.events.Event;
	
	public class SceneModuleEvent extends Event
	{
		public static const SHOW_NPC_DIALOG:String = "showNpcDialog";
		
		public static const SHOW_GROUP_PANEL:String = "showGroupPanel";
		
		public static const SHOW_NEARLY_PANEL:String = "showNearlyPanel";
		
		public static const SHOW_COPY_PANEL:String = "showCopyPanel";
		
		public static const SHOW_COPY_ACTION:String = "showCopyAction";
		
		public static const SHOW_NPC_COPY_PANEL:String = "showNpcCopyPanel";
		
		public static const SHOW_SPA_COPY_PANEL:String = "showSpaCopyPanel";

		public static const SHOW_SPA_COPY_LEAVE:String = "showSpaCopyLeave";
		
		public static const SHOW_BIGMAP_PANEL:String = "showBigMapPanel";
		
		public static const SHOW_TRANSPORT_PANEL:String = "showTransportPanel";
		
		public static const SHOW_CLUB_SCENE_LEAVE_PANEL:String = "showClubSceneLeavePanel";
		
		public static const SHOW_CLUB_SCENE_ENTER_PANEL:String = "showClubSceneEnterPanel";
		
		public static const SHOW_ACCEPT_TRANSPORT_PANEL:String = "showAcceptTransportPanel";
		
		public static const SHOW_SERVER_TRANSPROT_PANEL:String = "showServerTransprotPanel";
		
		/**
		 * 打开挂机面板
		 */
		public static const SHOW_HANG_UP_PANEL:String = "showHangUpPanel";
		
		/**
		 * 自动寻路
		 */		
		public static const WALKTOPOINT:String = "walkToPoint";
		/**
		 * 自动寻路找NPC
		 */		
		public static const WALKTONPC:String = "walkToNpc";
		/**
		 * 自动寻路攻击怪物
		 */		
		public static const ATTACKMONSTER:String = "attackMonster";

		/**
		 *teamAction类型 0邀请组队，1更换队长，2离队，3踢出队伍，4解散队伍 
		 */		
		public static const TEAM_ACTION:String = "team action";
		/**
		 *创建队伍
		 */		
		public static const CREATE_TEAM:String = "createTeam";
		/**
		 * 跟随
		 */		
		public static const FOLLOW_PLAYER:String = "followPlayer";
		/**
		 * 技能栏应用（快捷键调用）
		 */		
		public static const APPLY_SKILLBAR:String = "applySkillBar";
		/**
		 * 添加事件消息
		 */		
		public static const ADD_EVENTLIST:String = "addEventList";
		/**
		 * PK模式改变
		 */		
		public static const PK_MODE_CHANGE:String = "pkModeChange";
		/**
		 * 捡道具
		 */		
		public static const PICKUP_DROP:String = "pickupDrop";
		/**
		 * 挂机捡道具
		 */		
		public static const PICKUP_SPACE:String = "pickUpSpace";
		/**
		 *显示神魔商城 
		 */		
		public static const SHOW_SHENMO_SHOP:String = "showShenMoShop";
		/**
		 * 进出泳池
		 */		
		public static const TO_SWIM:String = "toSwim";
		
		/**
		 * 打坐
		 */		
		public static const SIT:String = "sit";
		/**
		 * 邀请双修
		 */		
		public static const DOUBLESIT_INVITE:String = "doubleSitInvite";
		/**
		 * 挂机
		 */		
		public static const HANGUP:String = "hangup";
		/**
		 * 脱离异常坐标
		 */		
		public static const BREAKAWAY:String = "breakAway";
		/**
		 * 队伍设置改变
		 */		
		public static const TEAM_SETTING_CHANGE:String = "teamSettingChange";
		/**
		 * 更新玩家名字显示
		 */		
		public static const UPDATE_PLAYER_NAME:String = "updatePlayerName";
		/**
		 * 更新玩家形象
		 */		
		public static const UPDATE_PLAYER_FIGURE:String = "updatePlayerFigure";
		/**
		 * 更新玩家形象
		 */		
		public static const UPDATE_MONSTER_FIGURE:String = "updateMonsterFigure";
		/**
		 * 打开发起交易面板
		 */		
		public static const SEND_TRADEDIRECT:String = "sendTradeDirect";
		/**
		 * 直接交易自己删除物品
		 */		
		public static const TRADE_ITEM_SELFREMOVE:String = "tradeitemSelfRemove";
		/**
		 * 使用传送
		 */
		public static const USE_TRANSFER:String = "useTransfer";
		/**
		 * 打开pvp主面板
		 */
		public static const OPEN_PVP_MAINPANEL:String = "openPvpMainpanle";
		/**
		 * 跑到中心点采集
		 */		
		public static const WALK_TO_CENTERCOLLECT:String = "walkToCenterCollect";
		/**
		 * 打开NPC弹窗
		 */		
		public static const OPEN_NPC_POPPANEL:String = "openNpcPopPanel";
		/**
		 * 帮会运输状态更新
		 */		
		public static const CLUB_TRANSPORT_UPDATE:String = "clubTransportUpdate";
		/**
		 * 骑宠激活
		 */		
		public static const MOUNT_AVOID:String = "mountAvoid";
		/**
		 * 更改PK模式
		 */		
		public static const CHANGE_PK_MODE:String = "changePKMode";
		
		/**
		 * 打开排行榜
		 */
		public static const SHOW_TOP_PANEL:String = "showTopPanel";
		
		/**
		 * 进入副本
		 */		
		public static const COPY_ENTER:String = "copyEnter";
		
		/**
		 * 退出副本更新
		 */	
		public static const COPY_LEAVE_EVENT:String = "copyLeaveEvent";
		
		/**
		 *邀请PK
		 */
		public static const PK_INVITE:String = "pkInvite";
		/**
		 * 更换选中目标
		 */		
		public static const TARGET_CHANGE:String = "targetChange";
		/**
		 * 显示泡泡
		 */		
		public static const SHOW_PAOPAO:String = "showPaopao";
		
		/**
		 * 清除跨图寻路路径
		 */		
		public static const CLEAR_WALK_PATH:String = "clearWalkPath";
		/**
		 * 切换场景
		 */		
		public static const CHANGE_SCENE:String = "changeScene";
		
		public static const MAP_ENTER:String = "mapEnter";
		
		public static const AUTO_TASK_INIT:String = "autoTaskInit";
		public static const AUTO_TASK_START:String = "autoTaskStart";
		public static const AUTO_TASK_STOP:String = "autoTaskStop";
		public static const AUTO_TASK_DISPOSE:String = "autoTaskDispose";
		
		public static const OPEN_TREASURE_MAP:String = "openTreasureMap";
		
		public static const SHOW_MEDICINES_CAUTION_PANEL:String = "showMedicinesCautionPanel";
		
		/**
		 * 显示在线奖励面板 
		 */		
		public static const SHOW_ONLINE_REWARD_PANEL:String = "showOnlineRewardPanel";
		
		/**
		 * 显示投资计划面板 
		 */		
		public static const SHOW_BANK_PANEL:String = "showBankPanel";
		
		/**
		 * 显示在线奖励面板 
		 */		
		public static const SHOW_CHALLENGE_PANEL:String = "showChallengePanel";
		
		/**
		 * 显示pvp战斗结果面板 
		 */		
		public static const SHOW_PVP_RESULT_PANEL:String = "showpvpResulePanel";
		/**
		 * 显示参加pvp面板 
		 */		
		public static const SHOW_PVP_CLUE_PANEL:String = "showpvpCluePanel";
		
		public static const TOP_ICON_UDPATE:String = "topIconUpdate";
		
		/**
		 * 移除新手礼包topicon
		 */
		public static const REMOVE_NEWCOMER_GIFT_ICON:String = "removeNewcomerGiftIcon";
		
		/**
		 * 显示新手礼包topicon
		 */
		public static const SHOW_NEWCOMER_GIFT_ICON:String = "showNewcomerGiftIcon";
		
		/**
		 * 活跃度值，是否可领取
		 */
		public static const UPDATE_ACTIVE_INFO:String = 'updateActiveInfo';
		
		public static const SHOW_CLIMBING_TOWER:String = "showClimbingTower";
		
		public static const SHOW_RESOURCE_WAR_ENTRANCE_PANEL:String = "showResourceWarEntrancePanel";
		
		public static const SHOW_PVP_FIRST_ENTRANCE_PANEL:String = "showPvpFirstEntrancePanel";
		
		public static const SHOW_EXCHANGE_VIEW:String = "showExchangeView";
		
		public static const TIME_SIT_TASK_WARN:String = "timeSitTaskWarn";
		
		public static const ONLINE_REWARD_CAN_GET:String = "onlineRewardCanGet";
		
		public static const SHOW_ENTRUSTMENT_ATTENTION:String = "showEntrustmentAttention";
		
		public static const SHOW_GUILD_PVP_ENTER_PANEL:String = "showGuildPVPEnterPanel";
		/**
		 * 王城争霸
		 */
		public static const SHOW_CITY_CRAFT_GUILD_ENTER:String = "showCityCraftGuildEnter";
		public static const SHOW_CITY_CRAFT_AUCTION_VIEW:String = "showCityCraftAuctionView";
		public static const SHOW_CITY_CRAFT_AUCTION_PANEL:String = "showCityCraftAuctionPanel";
		public static const SHOW_CITY_CRAFT_ENTRANCE_PANEL:String = "showCityCraftEntrancePanel";
		public static const SHOW_CITY_CRAFT_CALL_BOSS_PANEL:String = "showCityCraftCallBossPanel";
		public static const SHOW_CITY_CRAFT_MANAGE_PANEL:String = "showCityCraftManagePanel";
		public static const CITY_CRAFT_NEW_AUCTION:String = "cityCraftNewAuction";
		
		
		public var data:Object;
		
		public function SceneModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}