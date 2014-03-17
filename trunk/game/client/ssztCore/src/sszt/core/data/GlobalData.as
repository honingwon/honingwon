package sszt.core.data
{
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	
	import sszt.core.data.OnlineReward.RewardData;
	import sszt.core.data.activity.ActiveStartInfo;
	import sszt.core.data.alert.NoAlertType;
	import sszt.core.data.bag.BagInfo;
	import sszt.core.data.bag.ClientBagInfo;
	import sszt.core.data.bag.PetBagInfo;
	import sszt.core.data.box.BoxMessageInfo;
	import sszt.core.data.challenge.ChallengeInfo;
	import sszt.core.data.chat.ChatInfoII;
	import sszt.core.data.chat.club.ClubChatInfo;
	import sszt.core.data.cityCraft.CityCraftInfo;
	import sszt.core.data.club.ClubShopInfo;
	import sszt.core.data.club.ClubSkillList;
	import sszt.core.data.club.memberInfo.ClubMemberInfo;
	import sszt.core.data.copy.CopyEnterNumberList;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.entrustment.EntrustmentInfo;
	import sszt.core.data.im.ImPlayerList;
	import sszt.core.data.itemDiscount.CheapInfo;
	import sszt.core.data.loginReward.LoginRewardData;
	import sszt.core.data.mail.MailInfo;
	import sszt.core.data.marriage.WeddingInfo;
	import sszt.core.data.mounts.MountShowInfo;
	import sszt.core.data.mounts.MountsItemList;
	import sszt.core.data.openActivity.OpenActivityInfo;
	import sszt.core.data.openActivity.SevenActivityInfo;
	import sszt.core.data.openActivity.YellowBoxInfo;
	import sszt.core.data.personal.PersonalInfo;
	import sszt.core.data.pet.PetItemList;
	import sszt.core.data.pet.PetShowInfo;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.data.quickIcon.QuickIconInfo;
	import sszt.core.data.quiz.QuizInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.shop.BuyBackInfo;
	import sszt.core.data.skill.SkillItemList;
	import sszt.core.data.skill.SkillShortCutList;
	import sszt.core.data.stall.StallInfo;
	import sszt.core.data.store.MysteryShopInfo;
	import sszt.core.data.swordsman.TokenInfo;
	import sszt.core.data.target.TargetInfo;
	import sszt.core.data.task.TaskItemList;
	import sszt.core.data.titles.TitleInfo;
	import sszt.core.data.veins.VeinsList;
	import sszt.core.data.worldBossInfo.WorldBossInfo;
	import sszt.core.manager.WarManager;
	import sszt.core.view.FriendIconList;
	import sszt.core.view.MailIcon;
	import sszt.core.view.VipIcon;
	import sszt.core.view.paopao.PaopaoSoure;
	import sszt.core.view.timerEffect.TimerEffectSource;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.scene.ISceneObj;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.SelectedBorder;
	
	/**
	 * 游戏全局参数
	 * @author Administrator
	 * 
	 */	
	public class GlobalData
	{
		public static var debugField:TextField = new TextField();
		/**
		 * 游戏服务器IP和端口
		 */		
		public static var tmpIp:String = "127.0.0.1";
		public static var tmpPort:int = 0;
		/**
		 * bgp ip和端口
		 */		
		public static var bgpIp:String = "";
		public static var bgpPort:int = 0;
		/**
		 * 是否游客
		 */		
		public static var isVisitor:Boolean;
		/**
		 * 是否第一次登陆
		 */		
		public static var isFirstLogin:Boolean;
		
		public static var tmpUserName:String;
		public static var tmpPassword:String;
		public static var tmpId:Number;
		public static var tmpSite:String;
		public static var tmpServerId:int;
		public static var tmpSign:String;
		public static var tmpTick:String;
		public static var tmpCM:String;
		public static var guest:Boolean;
		
		/**
		 *  是否为黄钻用户（0：不是； 1：是）
		 */		
		public static var tmpIsYellowVip:int;
		/**
		 *  是否为年费黄钻用户（0：不是； 1：是）
		 */		
		public static var tmpIsYellowYearVip:int;
		/**
		 *  黄钻等级，目前最高级别为黄钻8级（如果是黄钻用户才返回此参数）。
		 */		
		public static var tmpYellowVipLevel:int;
		/**
		 * 是否为豪华版黄钻用户（0：不是； 1：是）
		 */		
		public static var tmpIsYellowHighVip:int;
		
		/**
		 * 充值接口需要的字段 
		 */		
		public static var tmpPf:String;
		public static var tmpPfKey:String;
		public static var tmpOpenKey:String;
		public static var tmpZoneId:int;
		public static var tmpDomain:String;
		
		/**
		 * 是否自动全屏
		 */		
		public static var fullScene:Boolean = false;
		/**
		 * 回收时间
		 */		
		public static var GCTIME:int = 120000;
		/**
		 * 平台类型
		 */		
		public static var PLAT:int = 1;
		/**
		 * 游戏名字
		 */		
		public static var GAME_NAME:String = "盛世遮天";
		/**
		 * 资源前缀
		 */		
		public static var ASSET_PRE:String = "";
		
		public static var domain:ApplicationDomain;
		/**
		 * 玩家自己引用
		 */		
		public static var selfPlayer:SelfPlayerInfo;
		/**
		 * QQ群号
		 */		
		public static var QQ_GRUOP:String;
		/**
		 *客服QQ 
		 */
		public static var QQ_SERVER:String;
		/**
		 * 是否能充值
		 */
		public static var canCharge:Boolean = true;
		/**
		 * 能否使用辅助技能
		 */		
		public static var canUseAssist:Boolean = true;
		/**
		 * 是否有媒体礼包
		 */		
		public static var hasMediaPackage:Boolean = false;
		/**
		 *是否有类型2媒体礼包 
		 */
		public static var hasMediaPackageTwo:Boolean = false;
		
//		/**
//		 * 二级密码锁
//		 */		
//		public static var secPass:SecPassInfo = new SecPassInfo();
		/**
		 * 版本
		 */		
		public static var version:int = 10000;
		
		/**
		 *开服日期 
		 */		
		public static var openServerDate:Date;
		/**
		 * 系统时间
		 */		
		public static var systemDate:SystemDateInfo = new SystemDateInfo();
		/**
		 * 防沉迷类型(1不限制,2弹窗提示,3聊天提示)
		 */		
		public static var enthralType:int = 2;
		/**
		 *防沉迷是否已经验证 
		 */		
		public static var isEnthral:Boolean = false;
		/**
		 *当前防沉迷状态 0未登记，1成年，2登记但未成年， 3满三个小时收益减半 , 4满5小时收益清零
		 */
		public static var enthralState:int = 1;
		/**
		 *防沉迷是否已经存在弹窗
		 */
		public static var isEnthralPanel:Boolean = false;
		/**
		 * 服务器列表(合服用)
		 */		
		public static var serverList:Array = new Array();
		/**
		 *累积上线时间 
		 */		
		public static var onLineTime:int = 0;
		
		/**
		 * 冷却动画
		 */		
		public static var timerEffectSource:TimerEffectSource;
		/**
		 * 泡泡资源
		 */		
		public static var paopaoSource:PaopaoSoure;
		
		/**
		 *加好友弹窗 
		 */
		public static var friendAlert:MAlert;
		/**
		 * 帮会邀请弹窗
		 */		
		public static var clubInviteAlert:MAlert;
		/**
		 * 帮会军团邀请弹窗
		 */		
		public static var armyInviteAlert:MAlert;
		/**
		 * 王城争霸数据 
		 */		
		public static var cityCraftInfo:CityCraftInfo = new CityCraftInfo();
		/**
		 * 背包数据 
		 */		
		public static var bagInfo:BagInfo = new BagInfo();
		
		/**
		 * 快捷图标
		 * */
		public static var quickIconInfo:QuickIconInfo = new QuickIconInfo();
		
		/**
		 * 客户端背包数据
		 */		
		public static var clientBagInfo:ClientBagInfo = new ClientBagInfo();
		/**
		 *回购物品数据 
		 */		
		public static var buyBackInfo:BuyBackInfo = new BuyBackInfo();
		/**
		 * 聊天记录
		 */		
//		public static var chatInfo:ChatInfo = new ChatInfo();
		public static var chatInfo:ChatInfoII = new ChatInfoII();
		/**
		 *摆摊数据 
		 */		
		public static var stallInfo:StallInfo = new StallInfo();
		
		/**
		 * 任务数据
		 */		
		public static var taskInfo:TaskItemList = new TaskItemList();
		/**
		 * 技能数据
		 */		
		public static var skillInfo:SkillItemList = new SkillItemList();
		
		/**
		 * 当日公会技能升级次数 
		 */		
		public static var guildSkillUpTimes:int;
		
		public static var skillShortCut:SkillShortCutList = new SkillShortCutList();
		/**
		 * 经脉数据
		 */	
		public static var veinsInfo:VeinsList = new VeinsList();
		/**
		 *帮会技能数据 
		 */
		public static var clubSkillList:ClubSkillList = new ClubSkillList();
		/**
		 *Im好友数据 
		 */
		public static var imPlayList:ImPlayerList = new ImPlayerList();
		/**
		 *邮件icon 
		 */
		public static var mailIcon:MailIcon;
		/**
		 *VIP icon 
		 */		
		public static var vipIcon:VipIcon;
		/**
		 *好友icon 
		 */
		public static var friendIconList:FriendIconList = new FriendIconList();
		
		/**
		 * 坐骑列表数据
		 */		
		public static var mountsList:MountsItemList = new MountsItemList();
		
		/**
		 * 宠物列表数据
		 */		
		public static var petList:PetItemList = new PetItemList();
		/**
		 * 称号数据
		 */		
		public static var titleInfo:TitleInfo = new TitleInfo();
		/**
		 * 江湖令接受发布数据
		 */		
		public static var tokenInfo:TokenInfo = new TokenInfo();
		/**
		 * hp药mp药最后使用时间
		 */		
		public static var lastUseTime_hp:int;
		public static var lastUseTime_mp:int;
		/**
		 * 是否交易中
		 */		
		public static var isInTrade:Boolean = false;
		
		/**
		 *副本进入次数 
		 */
		public static var copyEnterCountList:CopyEnterNumberList = new CopyEnterNumberList();
		
		/**
		 * 邮件数据
		 */		
		public static var mailInfo:MailInfo = new MailInfo();
		
		/**
		 * 选中框
		 */		
		public static var selectBorder:SelectedBorder = new SelectedBorder();
		
		/**
		 * 神炉面板状态 0 都没打开 1 煅造 2 炼制 
		 */		
		public static var furnaceState:int = 0;
		/**
		 * 帮会运镖时间
		 */		
		public static var clubTransportTime:int;
		
		
		public static var npcId:int = 0;
		
		/**
		 * 飞靴之后的类型
		 */		
		public static var transferType:int;
		/**
		 * 飞靴之后的目标
		 */	
		public static var transferTarget:int;
		
		
		/**
		 * 采集的目标
		 */		
		public static var collectTarget:int;
		
		
		public static var taskCallback:Function;
		
		/**
		 * 新手卡领取状态 0未领 1已领
		 */
		public static var newPlayerCardState:int=0;
		
		/**
		 * 在线奖励id 
		 */
		public static var rewardId:int;
		
		/**
		 * 在线奖励数据
		 */
		public static var rewardData:RewardData = new RewardData();
		
		/**
		 * 登录奖励数据 
		 */
		public static var loginRewardData:LoginRewardData = new LoginRewardData();
		
		/**
		 * 抢购特区数据 
		 */		
		public static var cheapInfo:CheapInfo = new CheapInfo();
		
		/**
		 * 目标数据 
		 */
		public static var targetInfo:TargetInfo = new TargetInfo();
		
		/**
		 * pvp数据 
		 */
		public static var pvpInfo:PVPInfo = new PVPInfo();
		
		/**
		 * 试炼数据 
		 */		
		public static var challInfo:ChallengeInfo = new ChallengeInfo();
		
		/**
		 * 各个活动开启时间信息 
		 */		
		public static var activeStartInfo:ActiveStartInfo = new ActiveStartInfo();
		
		/**
		 * 黄钻用户信息记录  
		 */		
		public static var yellowBoxInfo:YellowBoxInfo = new YellowBoxInfo();
		/**
		 * 开服活动
		 */		
		public static var openActivityInfo:OpenActivityInfo = new OpenActivityInfo();
		/**
		 * 世界boss信息
		 */		
		public static var worldBossInfo:WorldBossInfo = new WorldBossInfo();
		
		/**
		 * 帮会商城用户信息
		 */		
		public static var clubShopInfo:ClubShopInfo = new ClubShopInfo();
		
		/**
		 * 七天嘉年华信息
		 */		
		public static var sevenActInfo:SevenActivityInfo = new SevenActivityInfo();
		
		/**
		 * 神秘商店数据 
		 */		
		public static var mysteryShopInfo:MysteryShopInfo = new MysteryShopInfo();
		
		
		/**
		 * 开服时间戳
		 * */
		public static var releaseTime:Number;
		
		public static function setClubTransportTime(value:int):void
		{
			if(clubTransportTime == value)return;
			clubTransportTime = value;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CLUB_TRANSPORT_UPDATE));
		}
		
		/**
		 * 设置引导tips
		 */		
		public static var guideTipInfo:DeployItemInfo;
		public static function setGuideTipInfo(info:DeployItemInfo):void
		{
			if(guideTipInfo == info)return;
			guideTipInfo = info;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.SET_GUIDETIP));
		}
		
		/**
		 * 场景临时数据
		 * 
		 */
		public static var selfScenePlayerInfo:BaseRoleInfo;
		public static var currentMapId:int;
		public static var preMapId:int = -1;
		public static var leaderId:Number = 0;
		public static var selfScenePlayer:ISceneObj;
//		public static var mapData:Array;
		
		/**
		 * 开箱子开出高品质物品发送聊天信息
		 */
		public static var boxMsgInfo:BoxMessageInfo = new BoxMessageInfo();
		
		/**
		 *战场管理 
		 */		
		public static var warManager:WarManager = new WarManager();
		/**
		 *个人中心信息 
		 */		
		public static var personalInfo:PersonalInfo = new PersonalInfo();
		
		/**
		 * 顶部图标的状态 
		 */		
		public static var topIconState:Array = [0,0,0];
		
		/**
		 * 背包图标坐标
		 */
		
		public static var bagIconPos:Point;
		
		public static var quizInfo:QuizInfo = new QuizInfo();
		
		public static var mountShowInfo:MountShowInfo = new MountShowInfo();
		public static var petShowInfo:PetShowInfo = new PetShowInfo();
		
		
		public static var clubMemberInfo:ClubMemberInfo = new ClubMemberInfo();
		
		/**
		 * 帮会聊天消息信息
		 * */
		public static var clubChatInfo:ClubChatInfo = new ClubChatInfo();
		
		/**
		 * 七天嘉年华是否显示
		 */		
		public static var isShowSevenActivity:int = 1;
		
		/**
		 * 合服活动 
		 */		
		public static var isShowMergeServer:int = 1;
		
		public static var lostConnectResult:int = 0;
		
		/**
		 * 黄钻功能是否开启
		 * */
		public static var functionYellowEnabled:Boolean;
		
		/**
		 * 好友邀请功能是否开启
		 * */
		public static var functionFriendInviteEnabled:Boolean;
		
		public static var fillPath2:String;
		
		public static var noAlertType:NoAlertType = new NoAlertType();
		
		public static var weddingInfo:WeddingInfo = new WeddingInfo();
		
		/**
		 * 委托信息
		 * */
		public static var entrustmentInfo:EntrustmentInfo = new EntrustmentInfo();
		
		/**
		 * 宠物背包数据 
		 */		
		public static var petBagInfo:PetBagInfo = new PetBagInfo();
	}
}