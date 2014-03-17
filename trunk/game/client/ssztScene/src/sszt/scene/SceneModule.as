package sszt.scene
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToSceneData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.GetGameReleaseTimeSocketHandler;
	import sszt.core.socketHandlers.bag.PetItemPlaceUpdateSocketHandler;
	import sszt.core.socketHandlers.cityCraft.CityCraftAuctionStateSocketHandler;
	import sszt.core.socketHandlers.common.GetLoginDataSocketHandler;
	import sszt.core.socketHandlers.marriage.WeddingInfoUpdateSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.entrustment.EntrustmentAttentionView;
	import sszt.events.CommonModuleEvent;
	import sszt.events.NavigationModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.module.IModule;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.checks.AttackChecker;
	import sszt.scene.checks.DoubleSitChecker;
	import sszt.scene.checks.SceneTransferChecker;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.components.ActivityIcon.*;
	import sszt.scene.components.SceenShowWordView;
	import sszt.scene.components.SceneContainerInit;
	import sszt.scene.components.acrossServer.AcroSerIconView;
	import sszt.scene.components.acrossServer.AcroSerMainPanel;
	import sszt.scene.components.bank.BankMainPanel;
	import sszt.scene.components.bigBossWar.BigBossWarPanel;
	import sszt.scene.components.bossWar.BossIconView;
	import sszt.scene.components.bossWar.BossWarMainPanel;
	import sszt.scene.components.challenge.ChallengePassPanel;
	import sszt.scene.components.cityCraft.CityCraftAuctionPanel;
	import sszt.scene.components.cityCraft.CityCraftBossPanel;
	import sszt.scene.components.cityCraft.CityCraftEntrancePanel;
	import sszt.scene.components.cityCraft.CityCraftGuildEnterPanel;
	import sszt.scene.components.cityCraft.CityCraftJoinPanel;
	import sszt.scene.components.cityCraft.CityCraftManagePanel;
	import sszt.scene.components.cityCraft.CityCraftPanel;
	import sszt.scene.components.climbTowerPanel.ClimbTowerPanel;
	import sszt.scene.components.clubFire.ClubFireIconView;
	import sszt.scene.components.common.ClubTransportView;
	import sszt.scene.components.common.InCarTimeView;
	import sszt.scene.components.common.ServerTransportLeftTimeView;
	import sszt.scene.components.common.TransportBtn;
	import sszt.scene.components.common.TransportHelpBtn;
	import sszt.scene.components.copyGroup.CopyDetailView;
	import sszt.scene.components.copyGroup.CopyEnterAlert;
	import sszt.scene.components.copyGroup.CopyGroupPanel;
	import sszt.scene.components.copyGroup.NpcCopyPanel;
	import sszt.scene.components.copyIsland.beforeEnter.CopyIslandEnterPanel;
	import sszt.scene.components.doubleSit.DoubleSitIntroducePanel;
	import sszt.scene.components.doubleSit.DoubleSitPanel;
	import sszt.scene.components.duplicateLottery.DuplicateLotteryIcon;
	import sszt.scene.components.duplicateLottery.DuplicateLotteryPanel;
	import sszt.scene.components.elementInfoView.ElementInfoContainer;
	import sszt.scene.components.eventList.EventPanel;
	import sszt.scene.components.eventList.SceneEventView;
	import sszt.scene.components.eventList.SceneHidePlayerView;
	import sszt.scene.components.expCompensate.ExpCompensatePanel;
	import sszt.scene.components.firebox.FireBoxIconView;
	import sszt.scene.components.functionGuide.FunctionDetailPanel;
	import sszt.scene.components.functionGuide.FunctionGuideIconView;
	import sszt.scene.components.functionGuide.FunctionGuidePanel;
	import sszt.scene.components.gift.GiftView;
	import sszt.scene.components.group.GroupChatPanel;
	import sszt.scene.components.group.GroupPanel;
	import sszt.scene.components.guide.ShenMoGuideIconView;
	import sszt.scene.components.guildPVP.GuildPVPEnterPanel;
	import sszt.scene.components.guildPVP.GuildPVPPanel;
	import sszt.scene.components.hangup.NewHandupPanel;
	import sszt.scene.components.hangup.SimpleHandupPanel;
	import sszt.scene.components.lifeExpSit.LifeExpSitPanel;
	import sszt.scene.components.medicinesCaution.MedicinesCautionPanel;
	import sszt.scene.components.nearly.NearlyPanel;
	import sszt.scene.components.newBigMap.MapPanel;
	import sszt.scene.components.newcomerGift.NewcomerGiftPanel;
	import sszt.scene.components.npcPanel.NpcPanel;
	import sszt.scene.components.npcPanel.NpcPopPanel;
	import sszt.scene.components.onlineReward.OnlineRewardPanel;
	import sszt.scene.components.pvpFirst.PvpFirstPanel;
	import sszt.scene.components.quickIcon.QuickIconPanel;
	import sszt.scene.components.relive.PrisonRelivePanel;
	import sszt.scene.components.relive.ReliveBossWarPanel;
	import sszt.scene.components.relive.ReliveCopyIslandPanel;
	import sszt.scene.components.relive.ReliveMoneyPanel;
	import sszt.scene.components.relive.ReliveNormalPanel;
	import sszt.scene.components.relive.RelivePanel;
	import sszt.scene.components.relive.RelivePerWarPanel;
	import sszt.scene.components.relive.ReliveShenMoPanel;
	import sszt.scene.components.relive.ReliveTowerPanel;
	import sszt.scene.components.resourceWar.ResourceWarPanel;
	import sszt.scene.components.resourceWar.ResourceWarRelivePanel;
	import sszt.scene.components.shenMoWar.ShenMoRewardsPanel;
	import sszt.scene.components.shenMoWar.ShenMoWarMainPanel;
	import sszt.scene.components.shenMoWar.clubWar.ClubPointWarIconView;
	import sszt.scene.components.shenMoWar.clubWar.ClubPointWarScorePanel;
	import sszt.scene.components.shenMoWar.clubWar.shop.ClubPointWarShopPanel;
	import sszt.scene.components.shenMoWar.crystalWar.CrystalWarIconView;
	import sszt.scene.components.shenMoWar.crystalWar.CrystalWarRelivePanel;
	import sszt.scene.components.shenMoWar.crystalWar.CrystalWarScorePanel;
	import sszt.scene.components.shenMoWar.crystalWar.shop.CrystalWarShopPanel;
	import sszt.scene.components.shenMoWar.myWar.ShenMoMyWarInfoPanel;
	import sszt.scene.components.shenMoWar.personalWar.PerWarIcon;
	import sszt.scene.components.shenMoWar.personalWar.PerWarMyWarInfoPanel;
	import sszt.scene.components.shenMoWar.personalWar.PerWarRewardsPanel;
	import sszt.scene.components.shenMoWar.shenMoIcon.ShenMoIconView;
	import sszt.scene.components.shenMoWar.shop.ShenMoWarShopPanel;
	import sszt.scene.components.skillBar.SkillBarView;
	import sszt.scene.components.smallMap.SmallMapView;
	import sszt.scene.components.spa.SpaIconView;
	import sszt.scene.components.target.TargetFinishPanel;
	import sszt.scene.components.tradeDirect.TradeDirectPanel;
	import sszt.scene.components.transport.AcceptTransportPanel;
	import sszt.scene.components.transport.ServerTransportPanel;
	import sszt.scene.components.transport.TransportAwardPanel;
	import sszt.scene.components.transport.TransportPanel;
	import sszt.scene.components.treasureHunt.TreasurePanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.bank.BankInfo;
	import sszt.scene.data.bigBossWar.BigBossWarInfo;
	import sszt.scene.data.bossWar.BossWarInfo;
	import sszt.scene.data.clubPointWar.ClubPointWarInfo;
	import sszt.scene.data.copyIsland.CopyIslandInfo;
	import sszt.scene.data.crystalWar.CrystalWarInfo;
	import sszt.scene.data.duplicate.DuplicateChallInfo;
	import sszt.scene.data.duplicate.DuplicateGuardInfo;
	import sszt.scene.data.duplicate.DuplicateMayaInfo;
	import sszt.scene.data.duplicate.DuplicateMoneyInfo;
	import sszt.scene.data.duplicate.DuplicateNormalInfo;
	import sszt.scene.data.duplicate.DuplicatePassInfo;
	import sszt.scene.data.guildPVP.GuildPVPInfo;
	import sszt.scene.data.onlineReward.OnlineRewardInfo;
	import sszt.scene.data.personalWar.PerWarInfo;
	import sszt.scene.data.pools.ScenePoolManager;
	import sszt.scene.data.pvpFirst.PvpFirstInfo;
	import sszt.scene.data.resourceWar.ResourceWarInfo;
	import sszt.scene.data.shenMoWar.ShenMoWarInfo;
	import sszt.scene.data.treasureHunt.TreasureInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.scene.socketHandlers.PlayerBreakAwaySocketHandler;
	import sszt.scene.socketHandlers.SceneSetSocketHandler;
	import sszt.scene.socketHandlers.TeamCreateSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaveSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftDaysInfoSocketHandler;
	import sszt.scene.utils.ShowQuickIconTimer;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class SceneModule extends BaseModule
	{
		public var facade:SceneFacade;
		public var sceneInfo:SceneInfo;
		
		public var shenMoWarInfo:ShenMoWarInfo;
		public var clubPointWarInfo:ClubPointWarInfo;
		public var resourceWarInfo:ResourceWarInfo;
		public var pvpFirstInfo:PvpFirstInfo;
		public var bossWarInfo:BossWarInfo;
		public var perWarInfo:PerWarInfo;
		public var copyIslandInfo:CopyIslandInfo;//神魔岛
		
		public var duplicateMonyeInfo:DuplicateMoneyInfo;	// 打钱副本
		public var duplicatePassInfo:DuplicatePassInfo;	// 爬塔副本
		public var duplicateGuardInfo:DuplicateGuardInfo;	// 防守副本
		public var duplicateNormalInfo:DuplicateNormalInfo;// 普通副本
		public var duplicateChallInfo:DuplicateChallInfo;//试炼副本
		public var duplicateMayaInfo:DuplicateMayaInfo;// 玛雅神殿副本
		
		public var bankInfo:BankInfo;
		public var crystalWarInfo:CrystalWarInfo;
		public var bigBossWarInfo:BigBossWarInfo;
		public var guildPVPInfo:GuildPVPInfo;
		public var onlineRewardInfo:OnlineRewardInfo;
		
		public var sceneInit:SceneContainerInit;
		
		public var smallMap:SmallMapView;
		public var elementInfoContainer:ElementInfoContainer;
		public var skillBar:SkillBarView;
		
		public var npcPanel:NpcPanel;
		public var bigMapPanel:MapPanel;
		/**
		 * 在线奖励 
		 */		
		public var onlineRewardPanel:OnlineRewardPanel;
		/**
		 * 试炼结果 
		 */		
		public var challengePassPanel:ChallengePassPanel;
		//boss战
		public var bossMainPanel:BossWarMainPanel;
		public var bossIconView:BossIconView;
		public var clubFireIconView:ClubFireIconView;
		
		//跨服战
		public var acroSerMainPanel:AcroSerMainPanel;
		public var acroSerIconView:AcroSerIconView;
		//精致炼炉
		public var fireboxIconView:FireBoxIconView;
		//打钱副本
//		public var moneyDuplicatePanel:MoneyDuplicatePanel;
//		public var comboBatterPanel:ComboBatterPanel;
//		public var passDuplicatePanel:DuplicatePassPanel;
		
		//神魔乱斗
		public var shenMoWarMainPanel:ShenMoWarMainPanel;/**战字主面板**/
		public var shenMoRewardsPanel:ShenMoRewardsPanel;
		public var shenMoWarShopPanel:ShenMoWarShopPanel;
		public var shenMoMyWarInfoPanel:ShenMoMyWarInfoPanel;
		public var shenMoWarIcon:ShenMoIconView;
		
		public var treasurePanel:TreasurePanel;
		public var treasureInfo:TreasureInfo;
//		public var shenMoRankingPanel:ShenMoRankingPanel;
//		public var shenMoRankingTimePanel:ShenMoRankingTimePanel;
		//个人乱斗
		public var perWarIcon:PerWarIcon;
		public var perWarRewardsPanel:PerWarRewardsPanel;
		public var perWarMyInfoPanel:PerWarMyWarInfoPanel;
		//帮会据点战
		public var clubPointWarIcon:ClubPointWarIconView;
		public var clubPointWarScorePanel:ClubPointWarScorePanel;
		public var clubWarShopPanel:ClubPointWarShopPanel;
		
		//水晶战
		public var crystalWarIconView:CrystalWarIconView;
		public var crystalWarScorePanel:CrystalWarScorePanel;
		public var crystalWarShopPanel:CrystalWarShopPanel;
		
		//温泉
		public var spaIconView:SpaIconView;
		//复活面板
		public var relivePanel:RelivePanel;
		public var shenMoRelivePanel:ReliveShenMoPanel;
		public var bossWarRelivePanle:ReliveBossWarPanel;
		public var perWarRelivePanel:RelivePerWarPanel;
		public var prisonRelivePanel:PrisonRelivePanel;
		public var towerRelivePanel:ReliveTowerPanel;
		public var normalRelivePanel:ReliveNormalPanel;
		public var moneyRelivePanel:ReliveMoneyPanel;
		public var copyIslandRelivePanel:ReliveCopyIslandPanel;
		public var crystalWarRelivePanel:CrystalWarRelivePanel;
		public var resourceWarRelivePanel:ResourceWarRelivePanel;
		
		
		public var nearlyPanel:NearlyPanel;
		public var eventPanel:EventPanel;
		public var eventView:SceneEventView;
		public var hidePlayerIconVIew:SceneHidePlayerView;
//		public var hangupPanel:HangupPanel;
		public var hangupPanel:NewHandupPanel;
		public var simpleHandupPanel:SimpleHandupPanel;
		
		public var groupPanel:CopyGroupPanel;
		public var groupPanel1:GroupPanel;
		public var groupChatPanel:GroupChatPanel;
		
		public var copyDetailView:CopyDetailView;
		public var copyEnterAlert:CopyEnterAlert;
		public var copyGroupPanel:CopyGroupPanel;
		public var npcCopyPanel:NpcCopyPanel;
		public var copyIslandEnterPanel:CopyIslandEnterPanel;
		
		public var expCompensatePanel:ExpCompensatePanel;
		
		public var sitInvitePanel:MTimerAlert;
		public var doubleSitIntroPanel:DoubleSitIntroducePanel;
		public var doubleSitPanel:DoubleSitPanel;
		public var lifeExpSitPanel:LifeExpSitPanel;
		public var medicinesCautionPanel:MedicinesCautionPanel;
		public var groupAlert:MAlert;
		public var getTradeAlert:MTimerAlert;
		
		public var pkInviteAlert:MTimerAlert;
		
		public var tradeDirectPanel:TradeDirectPanel;
		
		public var npcPopPanel:NpcPopPanel;
		public var transportPanel:TransportPanel;
		public var transportBtn:TransportBtn;
		public var transportHelpBtn:TransportHelpBtn;
		public var inCarTimeView:InCarTimeView;
		public var clubTransportView:ClubTransportView;
		
		public var quickIconPanel:QuickIconPanel;
		/**
		 * 成就完成
		 */		
		public var targetFinishPanel:TargetFinishPanel;
		public var newcomerGiftPanel:NewcomerGiftPanel;
		
		public var sceneMediator:SceneMediator;
		
		public var shenMoGuideIconView:ShenMoGuideIconView;
		
		/**
		 * 运镖 
		 */		
		public var acceptTransportPanel:AcceptTransportPanel;
		public var transportAwardPanel:TransportAwardPanel;
		public var serverTransportLeftTimeView:ServerTransportLeftTimeView;
		public var serverTransportPanel:ServerTransportPanel;
		
		public var functionGuideIcon:FunctionGuideIconView;
		public var functionGuidePanel:FunctionGuidePanel;
		public var functionDetailPanel:FunctionDetailPanel;
		
		public var duplicateLotteryIcon:DuplicateLotteryIcon;
		public var duplicateLotteryPanel:DuplicateLotteryPanel;
		
		public var climbTowerPanel:ClimbTowerPanel;
		public var resourceWarEntrancePanel:ResourceWarPanel;
		public var guildPVPEntrancePanel:GuildPVPEnterPanel;
		public var cityCraftPanel:CityCraftPanel;
		public var cityCraftJoinPanel:CityCraftJoinPanel;		
		public var cityCraftEntrancePanel:CityCraftEntrancePanel;
		public var cityCraftGuildEnterPanel:CityCraftGuildEnterPanel;
		public var cityCraftAuctionPanel:CityCraftAuctionPanel;
		public var cityCraftCallBossPanel:CityCraftBossPanel;
		public var cityCraftManagePanel:CityCraftManagePanel;//CityCraftManagePanel;
		
		public var bankMainPanel:BankMainPanel;
		
		public var pvpFirstEntrancePanel:PvpFirstPanel;
		public var bigBossWarPanel:BigBossWarPanel;
		public var guildPVPPanel:GuildPVPPanel;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			
			ScenePoolManager.setup();
			
			sceneInfo = new SceneInfo(data as ToSceneData);
			resourceWarInfo = new ResourceWarInfo();
			pvpFirstInfo = new PvpFirstInfo();
			shenMoWarInfo = new ShenMoWarInfo();
			perWarInfo = new PerWarInfo();
			clubPointWarInfo = new ClubPointWarInfo();
			
			crystalWarInfo = new CrystalWarInfo();
			
			bossWarInfo = new BossWarInfo();
			copyIslandInfo = new CopyIslandInfo();
			duplicateMonyeInfo = new DuplicateMoneyInfo();
			duplicatePassInfo = new DuplicatePassInfo();
			duplicateGuardInfo = new DuplicateGuardInfo();
			duplicateNormalInfo = new DuplicateNormalInfo();
			duplicateChallInfo = new DuplicateChallInfo();
			duplicateMayaInfo = new DuplicateMayaInfo();
			
			bankInfo = new BankInfo();
			bigBossWarInfo = new BigBossWarInfo();
			guildPVPInfo = new GuildPVPInfo();
			onlineRewardInfo = new OnlineRewardInfo();

			SceneSetSocketHandler.add(this);
			
			ModuleEventDispatcher.dispatchNavigationEvent(new NavigationModuleEvent(NavigationModuleEvent.SHOW_NAVIGATION));
			
			SetModuleUtils.addChat();
			
			SetModuleUtils.addFriends();
			
			var info:ChatItemInfo = new ChatItemInfo();
			info.type = MessageType.SYSTEM;
			info.fromNick = "";
			info.fromId = 0;
			info.fromSex = 0;
			info.toNick = "";
			info.toId = 0;
			info.message = GlobalData.GAME_NAME + LanguageManager.getWord("ssztl.common.gameLoadingSuccess");
			GlobalData.chatInfo.appendMessage(info);
						
//			if(GlobalData.isFirstLogin || GlobalData.isVisitor)
//			if(GlobalData.selfPlayer.currentExp == 0 && GlobalData.selfPlayer.level == 1)
//			{
//				TaskAcceptSocketHandler.sendAccept(CategoryTy[pe.FIRST_CHARGE_TASK);
//				LoginTip.getInstance().show();
//			}
			
			
			if(GlobalData.selfPlayer.level >= 8) FirstPayView.getInstance().show();
			if(GlobalData.selfPlayer.level >= 8) GiftView.getInstance().show(0,0,true); 
			if(GlobalData.selfPlayer.level >= 18) 
			{
//				OpenActivityView.getInstance().show();
				WelfareView.getInstance().show();
			}
			if(GlobalData.selfPlayer.level >= 30) 
			{
				BankIconView.getInstance().show();
				AchievementView.getInstance().show();
			}
			if(GlobalData.selfPlayer.level >= 35) 
			{
				WorldBossView.getInstance().show();
//				if(GlobalData.functionYellowEnabled) 
				PetPVPIconView.getInstance().show();
			}
			if(GlobalData.selfPlayer.level >= 40)
			{
				BossView.getInstance().show();
			}
			if(GlobalData.selfPlayer.level >= 45) 
			{
				MayaIconView.getInstance().show();
			}
			if(GlobalData.functionYellowEnabled) YellowBoxView.getInstance().show();
			QuizView.getInstance().show(0);
			PVPView.getInstance().show();
			AcceptTransportView.getInstance().show();
			ActivityThievesView.getInstance().show();
			ActivityPunishView.getInstance().show();
			ClubActivityRaid.getInstance().show();
			CityCraftView.getInstance().show();
			if(GlobalData.isShowMergeServer ==1 )
			{
				MergeServerView.getInstance().show();
			}
			MidAutumnView.getInstance().show();
//			ConsumTagView.getInstance().show();
//			PayTagView.getInstance().show(0,null,true);
			BigBossIconView.getInstance().show();
			if(GlobalData.functionFriendInviteEnabled)
			{
				FriendInviteView.getInstance().show();
			}
			GuildPVPIconView.getInstance().show();
			
			GetLoginDataSocketHandler.send(1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
			if(MapTemplateList.isWeddingMap()) WeddingInfoUpdateSocketHandler.send();
			PetItemPlaceUpdateSocketHandler.send(0);
			CityCraftDaysInfoSocketHandler.send();
			facade = SceneFacade.getInstance(String(moduleId));
			facade.startup(this);
			
			SceneTransferChecker.setup(this.sceneMediator);
			DoubleSitChecker.setup(this.sceneMediator);
			AttackChecker.setup(this.sceneMediator);
			WalkChecker.setup(this.sceneMediator);
			
			//初始化快捷小图标
			showQuickIconPanelHandler();
			//初始化成就完成面板
			showTargetFinishPanelHandler();
			SceenShowWordView.getInstance().show(1);
			
			ShowQuickIconTimer.getInstance().startTimer(0);
			
			GetGameReleaseTimeSocketHandler.send();
//			TitleGuidePanel.getInstance().show();
			
//			shenMoGuideIconView = new ShenMoGuideIconView();
//			fireboxIconView = new FireBoxIconView();
//			facade.sendNotification(SceneBossWarUpdateEvent.BOSS_WAR_LEFT_TIME_UPDATE,null);
//			facade.sendNotification(SceneAcroSerUpdateEvent.ACROSER_ICON_UPDATE,null);
//			facade.sendNotification(SceneMediatorEvent.INIT_FUNCTION_ICON,null);
			
//			if(sceneInfo.mapInfo.mapId == MapType.QUIZ && GlobalData.quizInfo.hasBegun)
//			{
//				SetModuleUtils.addQuiz(new ToQuizData(0));
//			}
			
			//初始化一下
			ResourceWarView.getInstance().show();
			PvpFirstView.getInstance().show();
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			sceneInfo.configureMapData(data as ToSceneData);
			if(MapTemplateList.isWeddingMap()) WeddingInfoUpdateSocketHandler.send();
			if(npcPanel)
			{
				npcPanel.dispose();
				npcPanel = null;
			}
			if(npcPopPanel)
			{
				npcPopPanel.dispose();
				npcPopPanel = null;
			}
			if(onlineRewardPanel)
			{
				onlineRewardPanel.dispose();
				onlineRewardPanel = null;
			}
			if(challengePassPanel)
			{
				challengePassPanel.dispose();
				challengePassPanel = null;
			}
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE);
			
//			if(sceneInfo.mapInfo.mapId == MapType.QUIZ && GlobalData.quizInfo.hasBegun)
//			{
//				SetModuleUtils.addQuiz(new ToQuizData(0));
//			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_NPC_DIALOG,showNpcDialogHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_GROUP_PANEL,showGroupPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_NEARLY_PANEL,showNearlyPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_BIGMAP_PANEL,showBigmapPanelHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_CHECKSTATE,taskCheckStateHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.TEAM_ACTION,teamActionHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.WALKTONPC,walkToNpcHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.ATTACKMONSTER,attackMonsterHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.ADD_EVENTLIST,addEventListHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.FOLLOW_PLAYER,followPlayerHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.APPLY_SKILLBAR,applySkillBarHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.PICKUP_DROP,pickUpDropHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.PICKUP_SPACE,pickupSpaceHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SIT,sitHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.HANGUP,hangupHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.BREAKAWAY,breakAwayHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.TEAM_SETTING_CHANGE,teamSettingChangeHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SEND_TRADEDIRECT,sendTradeDirectHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.TRADE_ITEM_SELFREMOVE,tradeItemSelfRemoveHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.DOUBLESIT_INVITE,doubleSitInviteHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.WALKTOPOINT,walkToPointHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.USE_TRANSFER,useTransferHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.OPEN_PVP_MAINPANEL,openPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.WALK_TO_CENTERCOLLECT,walkToCenterCollectHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_COPY_PANEL,showCopyHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_NPC_COPY_PANEL,showNpcCopyPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_SPA_COPY_PANEL,showSpaCopyPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_SPA_COPY_LEAVE,showSpaCopyLeaveHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.OPEN_NPC_POPPANEL,openPopPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CLUB_TRANSPORT_UPDATE,clubTransportUpdateHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.MOUNT_AVOID,mountAvoidHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_PK_MODE,changePkModeHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_COPY_ACTION,copyActionHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_TRANSPORT_PANEL,showTransportPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CLUB_SCENE_LEAVE_PANEL,showClubSceneLeavePanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CLUB_SCENE_ENTER_PANEL,showClubSceneEnterPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.COPY_ENTER,copyEnterHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.COPY_LEAVE_EVENT, copyLeaveHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.PK_INVITE,pkInviteHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.GET_CLUB_WAR_REWARDS,getClubWarRewards);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_SHENMO_SHOP,shenMoShopHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_PAOPAO,showPaopaoHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.TO_SWIM,toSwimHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CLEAR_WALK_PATH,clearWalkPathHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.LEFT_PRESS,leftPressHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.RIGHT_PRESS,rightPressHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UP_PRESS,upPressHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.DOWN_PRESS,downPressHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_ACCEPT_TRANSPORT_PANEL,initTransportQualityHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_SERVER_TRANSPROT_PANEL,showServerTransportHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.FIREWORK_PLAY,fireworkPlayHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.ROSE_PLAY,rosePlayHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.OPEN_TREASURE_MAP, openTreasureMapHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_MEDICINES_CAUTION_PANEL,showMedicinesCautionPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_ONLINE_REWARD_PANEL,showOnlineRewardPanelHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_PVP_RESULT_PANEL,showPVPResultPanelHandler);//显示pvp战斗结果面板
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_PVP_CLUE_PANEL,showPVPCluePanelHandler);//显示参加pvp面板
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CHALLENGE_PANEL,showChallengePanelHandler);//显示试炼通关面板
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_BANK_PANEL,showBankPanelHandler);//显示试炼通关面板
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_NEWCOMER_GIFT_ICON,showNewcomerGiftIconHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.REMOVE_NEWCOMER_GIFT_ICON,removeNewcomerIconHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CREATE_TEAM,createTeamHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE, upgradeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.TEAM_LEAVE, teamLeave);
			
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.TASK_ACCEPT, taskAcceptHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.TASK_SUBMIT, taskSubmitHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CLIMBING_TOWER,showClimbingTowerHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.RELEASE_TIME_GOT,releaseTimeGotHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_RESOURCE_WAR_ENTRANCE_PANEL,showResourceWarEntranceHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_PVP_FIRST_ENTRANCE_PANEL,showPvpFirstEntranceHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_GUILD_PVP_ENTER_PANEL,showGuildPVPEntranceHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_ENTRANCE_PANEL,showCityCraftEntranceHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_CALL_BOSS_PANEL,showCityCraftCallBossHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_MANAGE_PANEL,showCityCraftManageHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_AUCTION_PANEL,showCityCraftAuctionHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_GUILD_ENTER,showCityCraftGuildEnterHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_ENTRUSTMENT_ATTENTION, showEntrustmentAttentionHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_NPC_DIALOG,showNpcDialogHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_GROUP_PANEL,showGroupPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_NEARLY_PANEL,showNearlyPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_BIGMAP_PANEL,showBigmapPanelHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_CHECKSTATE,taskCheckStateHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.TEAM_ACTION,teamActionHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.WALKTONPC,walkToNpcHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.ATTACKMONSTER,attackMonsterHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.ADD_EVENTLIST,addEventListHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.FOLLOW_PLAYER,followPlayerHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.APPLY_SKILLBAR,applySkillBarHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.PICKUP_DROP,pickUpDropHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.PICKUP_SPACE,pickupSpaceHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SIT,sitHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.HANGUP,hangupHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.BREAKAWAY,breakAwayHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.TEAM_SETTING_CHANGE,teamSettingChangeHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SEND_TRADEDIRECT,sendTradeDirectHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.TRADE_ITEM_SELFREMOVE,tradeItemSelfRemoveHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.DOUBLESIT_INVITE,doubleSitInviteHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.WALKTOPOINT,walkToPointHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.USE_TRANSFER,useTransferHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.OPEN_PVP_MAINPANEL,openPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.WALK_TO_CENTERCOLLECT,walkToCenterCollectHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_COPY_PANEL,showCopyHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_NPC_COPY_PANEL,showNpcCopyPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_SPA_COPY_PANEL,showSpaCopyPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_SPA_COPY_LEAVE,showSpaCopyLeaveHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.OPEN_NPC_POPPANEL,openPopPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CLUB_TRANSPORT_UPDATE,clubTransportUpdateHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.MOUNT_AVOID,mountAvoidHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_PK_MODE,changePkModeHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_COPY_ACTION,copyActionHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_TRANSPORT_PANEL,showTransportPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CLUB_SCENE_LEAVE_PANEL,showClubSceneLeavePanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CLUB_SCENE_ENTER_PANEL,showClubSceneEnterPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.COPY_ENTER,copyEnterHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.COPY_LEAVE_EVENT, copyLeaveHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.PK_INVITE,pkInviteHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.GET_CLUB_WAR_REWARDS,getClubWarRewards);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_SHENMO_SHOP,shenMoShopHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_PAOPAO,showPaopaoHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.TO_SWIM,toSwimHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CLEAR_WALK_PATH,clearWalkPathHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.LEFT_PRESS,leftPressHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.RIGHT_PRESS,rightPressHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UP_PRESS,upPressHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.DOWN_PRESS,downPressHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(SceneModuleEvent.SHOW_ACCEPT_TRANSPORT_PANEL,initTransportQualityHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.FIREWORK_PLAY,fireworkPlayHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.ROSE_PLAY,rosePlayHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.OPEN_TREASURE_MAP, openTreasureMapHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_MEDICINES_CAUTION_PANEL,showMedicinesCautionPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_ONLINE_REWARD_PANEL,showOnlineRewardPanelHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_PVP_RESULT_PANEL,showPVPResultPanelHandler);//显示pvp战斗结果面板
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_PVP_CLUE_PANEL,showPVPCluePanelHandler);//显示参加pvp面板
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CHALLENGE_PANEL,showChallengePanelHandler);//显示试炼通关面板
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_NEWCOMER_GIFT_ICON,showNewcomerGiftIconHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.REMOVE_NEWCOMER_GIFT_ICON,removeNewcomerIconHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CREATE_TEAM,createTeamHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE, upgradeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.TEAM_LEAVE, teamLeave);
			
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.TASK_ACCEPT, taskAcceptHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.TASK_SUBMIT, taskSubmitHandler);
			
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CLIMBING_TOWER,showClimbingTowerHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.RELEASE_TIME_GOT,releaseTimeGotHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_RESOURCE_WAR_ENTRANCE_PANEL,showResourceWarEntranceHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_PVP_FIRST_ENTRANCE_PANEL,showPvpFirstEntranceHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_GUILD_PVP_ENTER_PANEL,showGuildPVPEntranceHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_ENTRANCE_PANEL,showCityCraftEntranceHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_CALL_BOSS_PANEL,showCityCraftCallBossHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_MANAGE_PANEL,showCityCraftManageHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_AUCTION_PANEL,showCityCraftAuctionHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_CITY_CRAFT_GUILD_ENTER,showCityCraftGuildEnterHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_ENTRUSTMENT_ATTENTION, showEntrustmentAttentionHandler);
		}
		
		private function showEntrustmentAttentionHandler(e:SceneModuleEvent):void
		{
			var view:EntrustmentAttentionView = EntrustmentAttentionView.getInstance();
			if(!view.parent)
			{
				view.show(GlobalData.entrustmentInfo.currentEntrustment);
			}
			else
			{
				view.dispose();
			}
		}
		
//		private function showExchangeViewHandler(e:Event):void
//		{
//			var remainingExchangeSilverMoneyNum:int = GlobalData.selfPlayer.getRemainingExchangeSilverMoneyNum();		
//			if(remainingExchangeSilverMoneyNum > 0 && GlobalData.selfPlayer.level >= 30)
//			{
//				ExchangeView.getInstance().show(0,null,true,remainingExchangeSilverMoneyNum);
//			}
//			else
//			{
//				ExchangeView.getInstance().hide();
//			}
//		}
		
		private function releaseTimeGotHandler(e:Event):void
		{
			var releaseTime:Number = GlobalData.releaseTime;//秒
			var nowTime:Number = GlobalData.systemDate.getSystemDate().time/1000;//秒
			var seconds:Number = nowTime - releaseTime;
			var secondPerDay:Number = 24*60*60;
			var t:Number = seconds/secondPerDay;//GlobalData.functionYellowEnabled && 
			if(Math.ceil(seconds/secondPerDay) <= 8 && GlobalData.isShowSevenActivity == 1)
			{
				SevenActivityView.getInstance().show(0,null,true);
			}
		}
		
		private function showClimbingTowerHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_CLIMBING_TOWER);
		}
		private function showResourceWarEntranceHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_RESOURCE_WAR_ENTRANCE_PANEL);
		}
		private function showPvpFirstEntranceHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_PVP_FIRST_ENTRANCE_PANEL);
		}
		private function showGuildPVPEntranceHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_GUILD_PVP_ENTRANCE_PANEL);
		}
		private function showCityCraftEntranceHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_CITY_CRAFT_ENTRANCE_PANEL);
		}
		private function showCityCraftGuildEnterHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_CITY_CRAFT_GUILD_ENTER);
		}
		private function showCityCraftAuctionHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_CITY_CRAFT_AUCTION_PANEL);
		}
//		private function showCityCraftAuctionViewHandler(e:SceneModuleEvent):void
//		{
//			var state:int = e.data as int;
//			if(state==1)
//				CityCraftAuctionView.getInstance().show();
//			else
//				CityCraftAuctionView.getInstance().hide();
//		}
		private function showCityCraftManageHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_CITY_CRAFT_MANAGE_PANEL);
		}
		private function showCityCraftCallBossHandler(e:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_CITY_CRAFT_CALL_BOSS_PANEL);
		}
		private function upgradeHandler(e:Event):void
		{
			if(GlobalData.selfPlayer.level >= 8) GiftView.getInstance().show(0,0,true); 
			
			if(GlobalData.selfPlayer.level >= 8) FirstPayView.getInstance().show(0,null,true);
			if(GlobalData.selfPlayer.level >= 18)
			{
//				OpenActivityView.getInstance().show();
				WelfareView.getInstance().show(0,null,true);
			}
			if(GlobalData.selfPlayer.level >= 30) 
			{
				BankIconView.getInstance().show();
				AchievementView.getInstance().show(0,null,true);
				var remainingExchangeSilverMoneyNum:int = GlobalData.selfPlayer.getRemainingExchangeSilverMoneyNum();
				if(remainingExchangeSilverMoneyNum > 0)
				{
					ExchangeView.getInstance().show(0,null,true,remainingExchangeSilverMoneyNum);
					if(GlobalData.selfPlayer.level == 30) SetModuleUtils.addActivity(new ToActivityData(4,0));
				}
			}
			if(GlobalData.selfPlayer.level >= 35) 
			{
				WorldBossView.getInstance().show(0,null,true);
//				if(GlobalData.functionYellowEnabled) 
				PetPVPIconView.getInstance().show(0,null,true);
				CityCraftAuctionStateSocketHandler.send();
			}
			if(GlobalData.selfPlayer.level >= 40) BossView.getInstance().show(0,null,true);
			if(GlobalData.selfPlayer.level >= 45) MayaIconView.getInstance().show();
			
			if(GlobalData.selfPlayer.level == 31) //角色等级等于31级时，要求立即显示穴位按钮
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.VEINS_UPGRADE));
			}
			if(GlobalData.selfPlayer.level == 22)
			{
				var isGet:Boolean = GlobalData.openActivityInfo.isGetAward(1);
				if(!isGet)
				{
					SetModuleUtils.addFirstRecharge();
				}
			}
			if(GlobalData.functionYellowEnabled) YellowBoxView.getInstance().show();
		}
		
		private function createTeamHandler(e:SceneModuleEvent):void
		{
			TeamCreateSocketHandler.send();
		}
		
		private function removeNewcomerIconHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.REMOVE_NEWCOMER_GIFT_ICON);
		}
		
		private function showNewcomerGiftIconHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.NEWCOMER_GIFT_ICON,e.data);
		}
		
		private function showMedicinesCautionPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_MEDICINES_CAUTION_PANEL,e.data);
		}
		
		private function showOnlineRewardPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_ONLINE_REWARD_PANEL,e.data);
		}
		private function showBankPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_BANK_PANEL,e.data);
		}
		private function showChallengePanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_CHALLENGE_PANEL,e.data);
		}
		
		private function showPVPResultPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_PVP_RESULT_PANEL,e.data);
		}
		
		private function showPVPCluePanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_PVP_CLUE_PANEL,e.data);
		}
		
		private function showCopyHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYGROUP);
		}
		
		private function showNpcCopyPanelHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWNPCCOPY,evt.data);
		}
		
		private function showSpaCopyPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSPACOPY);
		}
		
		private function showSpaCopyLeaveHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_LEAVE_SPACOPY);
		}
		
		private function showPaopaoHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_PAOPAO,e.data);
		}
		
		private function shenMoShopHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOSHOP);
		}
		
		private function teamActionHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_TEAMACTION,evt.data);
		}
		
		private function walkToPointHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_WALK,e.data);
		}
		
		private function leftPressHandler(evt:CommonModuleEvent):void
		{
			
		}
		private function rightPressHandler(evt:CommonModuleEvent):void
		{
		}
		private function upPressHandler(evt:CommonModuleEvent):void
		{
		}
		private function downPressHandler(evt:CommonModuleEvent):void
		{
		}
		
		private function getClubWarRewards(e:TaskModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_GET_CLUBWARREWARDS);
		}
		
		private function walkToNpcHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_WALKTONPC,int(e.data));
		}
		
		private function attackMonsterHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_ATTACKMONSTER,e.data);
		}
		
		private function addEventListHandler(e:SceneModuleEvent):void
		{
			addEventList(e.data as String);
		}
		
		public function addEventList(mes:String):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_ADD_EVENTLIST,mes);
		}
		
		private function showNpcDialogHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWNPCDIALOG,int(evt.data));
		}
		
		private function showQuickIconPanelHandler():void
		{
			facade.sendNotification(SceneMediatorEvent.QUICK_ICON_PANEL);
		}
		
		private function showTargetFinishPanelHandler():void
		{
			facade.sendNotification(SceneMediatorEvent.TARGET_FINISH_PANEL);
		}
		
		private function showGroupPanelHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWGROUP);
		}
		private function showNearlyPanelHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWNEARLY);
		}
		private function showBigmapPanelHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWBIGMAP);
		}
		private function followPlayerHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_FOLLOWPLAYER,Number(evt.data));
		}
		private function applySkillBarHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_APPLYSKILLBAR,int(evt.data));
		}
		private function taskCheckStateHandler(e:TaskModuleEvent):void
		{
			sceneInfo.mapInfo.updateNpcState(e.data as int);
		}
		private function pickUpDropHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_PICKROUND,true);
		}
		private function pickupSpaceHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_PICKROUND,false);
//			facade.sendNotification(SceneMediatorEvent);
		}
		private function sitHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SIT);
		}
		private function hangupHandler(evt:SceneModuleEvent):void
		{
			sceneMediator.setHangup(true);
		}
		
		private function breakAwayHandler(evt:SceneModuleEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.scene.breakAway1"),
				LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,breakAwayCloseHandler);
			function breakAwayCloseHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					PlayerBreakAwaySocketHandler.send();
				}
			}
		}
		
		private function taskAcceptHandler(event:SelfPlayerInfoUpdateEvent) : void
		{
			var t:TaskItemInfo = event.data as TaskItemInfo;
			SceenShowWordView.getInstance().show(16000000 + t.getTemplate().taskId);
		} 
		
		private function taskSubmitHandler(event:SelfPlayerInfoUpdateEvent) : void
		{
			var t:TaskItemInfo = event.data as TaskItemInfo;
			SceenShowWordView.getInstance().show(17000000 + t.getTemplate().taskId);
		}
		
		/**
		 * 发起交易请求
		 * @param evt
		 * 
		 */
		private function sendTradeDirectHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SEND_TRADEDIRECT,evt.data);
//			facade.sendNotification(SceneMediatorEvent.SHOW_TRADEDIRECT,{id:123,nick:"123",serverId:8008});
		}
		
		private function tradeItemSelfRemoveHandler(evt:SceneModuleEvent):void
		{
			if(sceneInfo.tradeDirectInfo)
			{
				sceneInfo.tradeDirectInfo.removeSelfItem(evt.data as Number);
			}
		}
		private function doubleSitInviteHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SEND_DOUBLESIT_INVITE,evt.data);
		}
		private function useTransferHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.USE_TRANSFER,evt.data);
		}
		
		private function openPanelHandler(evt:SceneModuleEvent):void
		{
			WalkChecker.doWalkToNpc(102110);
		}
		
		private function walkToCenterCollectHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.WALK_TO_CENTERCOLLECT,evt.data);
		}
		private function copyEnterHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.COPY_ENTER,evt.data);
		}
		private function copyLeaveHandler(evt:SceneModuleEvent):void
		{
			CopyLeaveSocketHandler.send();
		}
		private function toSwimHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.TOSWIM,evt.data);
		}
		private function clearWalkPathHandler(evt:SceneModuleEvent):void
		{
			GlobalData.selfPlayer.scenePathCallback = null;
			GlobalData.selfPlayer.scenePathTarget = null;
			GlobalData.selfPlayer.scenePathStopAtDistance = 0;
			GlobalData.selfPlayer.scenePath = null;
			if(sceneInit && sceneInit.playerListController && sceneInit.playerListController.getSelf() && sceneInit.playerListController.getSelf().isMoving)
			{
				sceneInit.playerListController.getSelf().stopMoving();
			}
		}
		private function fireworkPlayHandler(evt:CommonModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.FRIEWORK_PLAY,evt.data);
		}
		private function rosePlayHandler(evt:CommonModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.ROSE_PLAY);
		}
		
		private function openPopPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.OPEN_POP_PANEL,e.data);
		}
		
		private function clubTransportUpdateHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.UPDATE_CLUB_TRANSPORT);
		}
		
		private function teamSettingChangeHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.TEAM_SETTING_CHANGE,e.data);
		}
		private function mountAvoidHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.CHANGE_MOUNTAVOID);
		}
		
		private function changePkModeHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.CHANGE_PK_MODE,e.data);
		}
		
		private function copyActionHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.COPY_ACTION,evt.data);
		}
		
		private function showTransportPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.OPEN_TRANSPORT_PANEL);
		}
		
		private function showClubSceneLeavePanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.CLUB_SCENE_LEAVE,e.data);
		}
		
		private function showClubSceneEnterPanelHandler(e:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.CLUB_SCENE_ENTER,e.data);
		}
		
		private function showTopPanelHandler(evt:SceneModuleEvent):void
		{
//			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWTOP, evt.data);
		}
		
		private function pkInviteHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.PK_INVITE,evt.data);
		}
		
		//打开接镖面板
		private function initTransportQualityHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.INIT_TRANSPORT_QUALITY);
		}
		
		private function showServerTransportHandler(evt:SceneModuleEvent):void
		{
			facade.sendNotification(SceneMediatorEvent.SHOW_SERVER_TRANSPORT_PANEL);
		}

		private function openTreasureMapHandler(event:SceneModuleEvent) : void
		{
			if (this.treasureInfo == null)
			{
				this.treasureInfo = new TreasureInfo();
			}
			this.facade.sendNotification(SceneMediatorEvent.OPEN_TREASURE_MAP, event.data);
		}
		private function teamLeave(evt:CommonModuleEvent):void
		{
			TeamLeaveSocketHandler.sendLeave();
		}
		override public function get moduleId():int
		{
			return ModuleType.SCENE;
		}
		
		override public function dispose():void
		{
			SceneSetSocketHandler.remove();
			super.dispose();
		}
	}
}