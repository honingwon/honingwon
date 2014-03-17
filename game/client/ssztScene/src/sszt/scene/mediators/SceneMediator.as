package sszt.scene.mediators
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.PK.PKType;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.functionGuide.FunctionGuideItemInfo;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.npcPanel.NpcPopType;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.PlayerPKModeChangeSocketHandler;
	import sszt.core.socketHandlers.scene.MapEnterSocketHandler;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.QuizModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.checks.AttackChecker;
	import sszt.scene.checks.SceneTransferChecker;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.components.SceneContainerInit;
	import sszt.scene.components.bank.BankMainPanel;
	import sszt.scene.components.challenge.ChallengePassPanel;
	import sszt.scene.components.cityCraft.CityCraftAuctionPanel;
	import sszt.scene.components.cityCraft.CityCraftBossPanel;
	import sszt.scene.components.cityCraft.CityCraftEntrancePanel;
	import sszt.scene.components.cityCraft.CityCraftGuildEnterPanel;
	import sszt.scene.components.cityCraft.CityCraftManagePanel;
	import sszt.scene.components.climbTowerPanel.ClimbTowerPanel;
	import sszt.scene.components.common.ClubTransportView;
	import sszt.scene.components.common.InCarTimeView;
	import sszt.scene.components.common.ServerTransportLeftTimeView;
	import sszt.scene.components.common.TransportBtn;
	import sszt.scene.components.common.TransportHelpBtn;
	import sszt.scene.components.functionGuide.FunctionDetailPanel;
	import sszt.scene.components.functionGuide.FunctionGuideIconView;
	import sszt.scene.components.functionGuide.FunctionGuidePanel;
	import sszt.scene.components.guildPVP.GuildPVPEnterPanel;
	import sszt.scene.components.lifeExpSit.ExpSitPanel;
	import sszt.scene.components.npcPanel.NpcPanel;
	import sszt.scene.components.npcPanel.NpcPopPanel;
	import sszt.scene.components.onlineReward.OnlineRewardPanel;
	import sszt.scene.components.pvpFirst.PvpFirstPanel;
	import sszt.scene.components.resourceWar.ResourceWarPanel;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.components.transport.AcceptTransportPanel;
	import sszt.scene.components.transport.ServerTransportPanel;
	import sszt.scene.components.transport.TransportAwardPanel;
	import sszt.scene.components.transport.TransportPanel;
	import sszt.scene.data.HangupData;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.SceneMonsterList;
	import sszt.scene.data.clubPointWar.ClubPointWarInfo;
	import sszt.scene.data.copyIsland.CopyIslandInfo;
	import sszt.scene.data.crystalWar.CrystalWarInfo;
	import sszt.scene.data.dropItem.DropItemInfo;
	import sszt.scene.data.duplicate.DuplicateChallInfo;
	import sszt.scene.data.duplicate.DuplicateGuardInfo;
	import sszt.scene.data.duplicate.DuplicateMayaInfo;
	import sszt.scene.data.duplicate.DuplicateMoneyInfo;
	import sszt.scene.data.duplicate.DuplicateNormalInfo;
	import sszt.scene.data.duplicate.DuplicatePassInfo;
	import sszt.scene.data.onlineReward.OnlineRewardInfoUpdateEvent;
	import sszt.scene.data.personalWar.PerWarInfo;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.data.shenMoWar.ShenMoWarInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.proxy.SceneLoadMapDataProxy;
	import sszt.scene.socketHandlers.MapRoundInfoSocketHandler;
	import sszt.scene.socketHandlers.PlayerCollectSocketHandler;
	import sszt.scene.socketHandlers.PlayerDairyAwardListSocketHandler;
	import sszt.scene.socketHandlers.PlayerDairyAwardSocketHandler;
	import sszt.scene.socketHandlers.PlayerFollowSocketHandler;
	import sszt.scene.socketHandlers.PlayerGetDropItemSocketHandler;
	import sszt.scene.socketHandlers.PlayerInviteSitRelaySocketHandler;
	import sszt.scene.socketHandlers.PlayerMoveSocketHandler;
	import sszt.scene.socketHandlers.PlayerMoveStepSocketHandler;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	import sszt.scene.socketHandlers.PlayerStartCollectSocketHandler;
	import sszt.scene.socketHandlers.PlayerStopCollectSocketHandler;
	import sszt.scene.socketHandlers.pk.PkInviteSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandDoorEnterSocketHandler;
	import sszt.scene.socketHandlers.spa.SpaPondSocketHandler;
	import sszt.scene.socketHandlers.transport.TransportHelpSocketHandler;
	import sszt.scene.socketHandlers.transport.TransportQualityInitHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class SceneMediator extends Mediator
	{
		public static const NAME:String = "SceneMediator";
		private var _doubleSitalert:MAlert;
		
		public function SceneMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_START,
				SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE,
				SceneMediatorEvent.SCENE_MEDIATOR_SENDATTACK,
				SceneMediatorEvent.SCENE_MEDIATOR_WALK,
				SceneMediatorEvent.SCENE_MEDIATOR_WALKTONPC,
				SceneMediatorEvent.SCENE_MEDIATOR_ATTACKMONSTER,
				SceneMediatorEvent.SCENE_MEDIATOR_FOLLOWPLAYER,
				SceneMediatorEvent.SCENE_MEDIATOR_PICKROUND,
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWNPCDIALOG,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE,
				SceneMediatorEvent.SIT,
//				SceneMediatorEvent.SIT_INVITE,
				SceneMediatorEvent.USE_TRANSFER,
				SceneMediatorEvent.WALK_TO_CENTERCOLLECT,
				SceneMediatorEvent.OPEN_POP_PANEL,
				SceneMediatorEvent.UPDATE_CLUB_TRANSPORT,
				SceneMediatorEvent.CHANGE_PK_MODE,
				SceneMediatorEvent.PK_INVITE,
				SceneMediatorEvent.SHOW_PAOPAO,
				SceneMediatorEvent.TOSWIM,
//				SceneMediatorEvent.SCENE_MEDIATOR_MOUNTAVOID
				SceneMediatorEvent.INIT_TRANSPORT_QUALITY,
				SceneMediatorEvent.SHOW_ACCEPT_TRANSPORT_PANEL,
				SceneMediatorEvent.INIT_SERVER_TRANSPORT_TIME,
				SceneMediatorEvent.SHOW_SERVER_TRANSPORT_PANEL,
				SceneMediatorEvent.FRIEWORK_PLAY,
				SceneMediatorEvent.ROSE_PLAY,
				SceneMediatorEvent.INIT_FUNCTION_ICON,
				SceneMediatorEvent.SHOW_ONLINE_REWARD_PANEL,
				SceneMediatorEvent.SHOW_BANK_PANEL,
				SceneMediatorEvent.SHOW_CHALLENGE_PANEL,
				SceneMediatorEvent.SHOW_CLIMBING_TOWER,
				SceneMediatorEvent.SHOW_RESOURCE_WAR_ENTRANCE_PANEL,
				SceneMediatorEvent.SHOW_PVP_FIRST_ENTRANCE_PANEL,
				SceneMediatorEvent.SHOW_GUILD_PVP_ENTRANCE_PANEL,
				SceneMediatorEvent.SHOW_CITY_CRAFT_ENTRANCE_PANEL,
				SceneMediatorEvent.SHOW_CITY_CRAFT_GUILD_ENTER,
				SceneMediatorEvent.SHOW_CITY_CRAFT_AUCTION_PANEL,
				SceneMediatorEvent.SHOW_CITY_CRAFT_CALL_BOSS_PANEL,
				SceneMediatorEvent.SHOW_CITY_CRAFT_MANAGE_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_START:
					initScene();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE:
					changeScene();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SENDATTACK:
					AttackChecker.doAttack(null,0,(notification.getBody() as SkillItemInfo));
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_WALK:
					var data:Object = notification.getBody();
					walk(data["sceneId"],data["target"],data["walkComplete"],data["stopAtDistance"]);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_WALKTONPC:
					sceneInfo.playerList.self.state.setFindPath(true);
					walkToNpc(notification.getBody() as int);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_ATTACKMONSTER:
					sceneInfo.playerList.self.state.setFindPath(true);
					walkToHangup(int(notification.getBody()));
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_FOLLOWPLAYER:
					followPlayer(notification.getBody() as Number);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWNPCDIALOG:
					showNpcPanel(notification.getBody() as int);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_PICKROUND:
					pickUpRound(notification.getBody() == true);
					break;
				case SceneMediatorEvent.SIT:
					selfSit(!GlobalData.selfPlayer.isSit());
					break;
//				case SceneMediatorEvent.SIT_INVITE:
//					var data2:Object = notification.getBody();
//					sitInvite(data2["nick"],data2["id"],data2["x"],data2["y"]);
//					break;
//				case SceneMediatorEvent.WALKTO_DOUBLESIT:
//					var data1:Object = notification.getBody();
//					walkToDoubleSit(data1["nick"],data1["id"],data1["x"],data1["y"]);
//					break;
				case SceneMediatorEvent.USE_TRANSFER:
					var data3:Object = notification.getBody();
					useTransfer(data3["sceneId"], data3["target"], data3["npcId"], data3["checkItem"], data3["checkWalkField"], data3["type"], data3["targetID"]);
//					useTransfer(data3["sceneId"],data3["target"]);
					break;
				case SceneMediatorEvent.WALK_TO_CENTERCOLLECT:
					sceneInfo.playerList.self.state.setFindPath(true);
					walkToCenterCollect(int(notification.getBody()));
					break;
				case SceneMediatorEvent.OPEN_POP_PANEL:
					openPopPanel(notification.getBody());
					break;
				case SceneMediatorEvent.UPDATE_CLUB_TRANSPORT:
					updateClubTransport();
					break;
				case SceneMediatorEvent.CHANGE_PK_MODE:
					changePKMode(int(notification.getBody()));
					break;
				case SceneMediatorEvent.PK_INVITE:
					pkInvite(Number(notification.getBody()));
					break;
				case SceneMediatorEvent.SHOW_PAOPAO:
					showPaopao(notification.getBody());
					break;
				case SceneMediatorEvent.TOSWIM:
					toSwim(notification.getBody());
					break;
				case SceneMediatorEvent.INIT_TRANSPORT_QUALITY:
					TransportQualityInitHandler.send();
					break;
				case SceneMediatorEvent.SHOW_ACCEPT_TRANSPORT_PANEL:
					showAcceptTransportPanel(notification.getBody() as int);
					break;
				case SceneMediatorEvent.INIT_SERVER_TRANSPORT_TIME:
					showServerTransprotLeftTimeView(notification.getBody() as Number);
					break;
				case SceneMediatorEvent.SHOW_SERVER_TRANSPORT_PANEL:
					showServerTransportPanel();
					break;
				case SceneMediatorEvent.FRIEWORK_PLAY:
					frieworkPlay(notification.getBody());
					break;
				case SceneMediatorEvent.ROSE_PLAY:
					rosePlay();
					break;
				case SceneMediatorEvent.STOP_MOVING:
					this.stopMoving(notification.getBody() as Point);
					break;
				case SceneMediatorEvent.INIT_FUNCTION_ICON:
					initFunctionIcon();
					break;
				case SceneMediatorEvent.SHOW_ONLINE_REWARD_PANEL:
					initOnlineReward(notification.getBody());
					break;				
				case SceneMediatorEvent.SHOW_BANK_PANEL:
					initBankMainPanel(notification.getBody());
					break;
				case SceneMediatorEvent.SHOW_CHALLENGE_PANEL:
					initChallenge(notification.getBody());
					break;
				case SceneMediatorEvent.SHOW_CLIMBING_TOWER:
					showClimbingTowerPanel();
					break;
				case SceneMediatorEvent.SHOW_RESOURCE_WAR_ENTRANCE_PANEL:
					showResourceWarEntrancePanel();
					break;
				case SceneMediatorEvent.SHOW_PVP_FIRST_ENTRANCE_PANEL:
					showPvpFirstEntrancePanel();
					break;
				case SceneMediatorEvent.SHOW_GUILD_PVP_ENTRANCE_PANEL:
					showGuildPVPEntrancePanel();
					break;
				case SceneMediatorEvent.SHOW_CITY_CRAFT_ENTRANCE_PANEL:
					showCityCraftEntrancePanel();
					break;
				case SceneMediatorEvent.SHOW_CITY_CRAFT_GUILD_ENTER:
					showCityCraftGuildEnterPanel();
					break;
				case SceneMediatorEvent.SHOW_CITY_CRAFT_AUCTION_PANEL:
					showCityCraftAuctionPanel();
					break;
				case SceneMediatorEvent.SHOW_CITY_CRAFT_CALL_BOSS_PANEL:
					showCityCraftCallBossPanel();
					break;
				case SceneMediatorEvent.SHOW_CITY_CRAFT_MANAGE_PANEL:
					showCityCraftManagePanel();
					break;
			}
		}
//		public function showCityCraftJoinPanel():void
//		{
//			if(sceneModule.cityCraftJoinPanel == null)
//			{
//				sceneModule.cityCraftJoinPanel = new CityCraftJoinPanel(this);
//				GlobalAPI.layerManager.addPanel(sceneModule.cityCraftJoinPanel);
//				sceneModule.cityCraftJoinPanel.addEventListener(Event.CLOSE,cityCraftJoinPanelCloseHandler);
//			}else
//			{
//				sceneModule.cityCraftJoinPanel.dispose();
//				sceneModule.cityCraftJoinPanel = null;
//			}
//		}
		public function showResourceWarEntrancePanel():void
		{
			if(sceneModule.resourceWarEntrancePanel == null)
			{
				sceneModule.resourceWarEntrancePanel = new ResourceWarPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.resourceWarEntrancePanel);
				sceneModule.resourceWarEntrancePanel.addEventListener(Event.CLOSE,resourceWarEntrancePanelCloseHandler);
			}else
			{
				sceneModule.resourceWarEntrancePanel.dispose();
				sceneModule.resourceWarEntrancePanel = null;
			}
		}
		public function showGuildPVPEntrancePanel():void
		{
			if(sceneModule.guildPVPEntrancePanel == null)
			{
				sceneModule.guildPVPEntrancePanel = new GuildPVPEnterPanel();
				GlobalAPI.layerManager.addPanel(sceneModule.guildPVPEntrancePanel);
				sceneModule.guildPVPEntrancePanel.addEventListener(Event.CLOSE,guildPVPEntrancePanelCloseHandler);
			}else
			{
				sceneModule.guildPVPEntrancePanel.dispose();
				sceneModule.guildPVPEntrancePanel = null;
			}
		}
		public function showCityCraftGuildEnterPanel():void
		{
			if(sceneModule.cityCraftGuildEnterPanel == null)
			{
				sceneModule.cityCraftGuildEnterPanel = new CityCraftGuildEnterPanel();
				GlobalAPI.layerManager.addPanel(sceneModule.cityCraftGuildEnterPanel);
				sceneModule.cityCraftGuildEnterPanel.addEventListener(Event.CLOSE,cityCraftGuildEnterCloseHandler);
			}else
			{
				sceneModule.cityCraftGuildEnterPanel.dispose();
				sceneModule.cityCraftGuildEnterPanel = null;
			}
		}
		public function showCityCraftEntrancePanel():void
		{
			if(sceneModule.cityCraftEntrancePanel == null)
			{
				sceneModule.cityCraftEntrancePanel = new CityCraftEntrancePanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.cityCraftEntrancePanel);
				sceneModule.cityCraftEntrancePanel.addEventListener(Event.CLOSE,cityCraftEntrancePanelCloseHandler);
			}else
			{
				sceneModule.cityCraftEntrancePanel.dispose();
				sceneModule.cityCraftEntrancePanel = null;
			}
		}
		public function showCityCraftAuctionPanel():void
		{
			if(sceneModule.cityCraftAuctionPanel == null)
			{
				sceneModule.cityCraftAuctionPanel = new CityCraftAuctionPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.cityCraftAuctionPanel);
				sceneModule.cityCraftAuctionPanel.addEventListener(Event.CLOSE,cityCraftAuctionPanelCloseHandler);
			}else
			{
				sceneModule.cityCraftAuctionPanel.dispose();
				sceneModule.cityCraftAuctionPanel = null;
			}
		}
		public function showCityCraftManagePanel():void
		{
			if(GlobalData.selfPlayer.clubName != GlobalData.cityCraftInfo.defenseGuild)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.cityCraft.notMasterGuild"));
				return;
			}
			if(sceneModule.cityCraftManagePanel == null)
			{
				sceneModule.cityCraftManagePanel = new CityCraftManagePanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.cityCraftManagePanel);
				sceneModule.cityCraftManagePanel.addEventListener(Event.CLOSE,cityCraftManagePanelCloseHandler);
			}else
			{
				sceneModule.cityCraftManagePanel.dispose();
				sceneModule.cityCraftManagePanel = null;
			}
		}
		public function showCityCraftCallBossPanel():void
		{
			if(sceneModule.cityCraftCallBossPanel == null)
			{
				sceneModule.cityCraftCallBossPanel = new CityCraftBossPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.cityCraftCallBossPanel);
				sceneModule.cityCraftCallBossPanel.addEventListener(Event.CLOSE,cityCraftCallBossPanelCloseHandler);
			}else
			{
				sceneModule.cityCraftCallBossPanel.dispose();
				sceneModule.cityCraftCallBossPanel = null;
			}
		}
		public function showPvpFirstEntrancePanel():void
		{
			if(sceneModule.pvpFirstEntrancePanel == null)
			{
				sceneModule.pvpFirstEntrancePanel = new PvpFirstPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.pvpFirstEntrancePanel);
				sceneModule.pvpFirstEntrancePanel.addEventListener(Event.CLOSE,pvpFirstEntrancePanelCloseHandler);
			}else
			{
				sceneModule.pvpFirstEntrancePanel.dispose();
				sceneModule.pvpFirstEntrancePanel = null;
			}
		}
		public function cityCraftManagePanelCloseHandler(evt:Event):void
		{
			sceneModule.cityCraftManagePanel.removeEventListener(Event.CLOSE,cityCraftManagePanelCloseHandler);
			sceneModule.cityCraftManagePanel = null;
		}
		public function cityCraftCallBossPanelCloseHandler(evt:Event):void
		{
			sceneModule.cityCraftCallBossPanel.removeEventListener(Event.CLOSE,cityCraftCallBossPanelCloseHandler);
			sceneModule.cityCraftCallBossPanel = null;
		}
		public function cityCraftAuctionPanelCloseHandler(evt:Event):void
		{
			sceneModule.cityCraftAuctionPanel.removeEventListener(Event.CLOSE,cityCraftAuctionPanelCloseHandler);
			sceneModule.cityCraftAuctionPanel = null;
		}
		public function guildPVPEntrancePanelCloseHandler(evt:Event):void
		{
			sceneModule.guildPVPEntrancePanel.removeEventListener(Event.CLOSE,guildPVPEntrancePanelCloseHandler);
			sceneModule.guildPVPEntrancePanel = null;
		}
		public function cityCraftGuildEnterCloseHandler(evt:Event):void
		{
			sceneModule.cityCraftGuildEnterPanel.removeEventListener(Event.CLOSE,cityCraftGuildEnterCloseHandler);
			sceneModule.cityCraftGuildEnterPanel = null;
		}
		public function cityCraftEntrancePanelCloseHandler(evt:Event):void
		{
			sceneModule.cityCraftEntrancePanel.removeEventListener(Event.CLOSE,cityCraftEntrancePanelCloseHandler);
			sceneModule.cityCraftEntrancePanel = null;
		}
//		public function cityCraftJoinPanelCloseHandler(evt:Event):void
//		{
//			sceneModule.cityCraftJoinPanel.removeEventListener(Event.CLOSE,cityCraftJoinPanelCloseHandler);
//			sceneModule.cityCraftJoinPanel = null;
//		}
		
		public function resourceWarEntrancePanelCloseHandler(evt:Event):void
		{
			sceneModule.resourceWarEntrancePanel.removeEventListener(Event.CLOSE,resourceWarEntrancePanelCloseHandler);
			sceneModule.resourceWarEntrancePanel = null;
		}
		
		public function pvpFirstEntrancePanelCloseHandler(evt:Event):void
		{
			sceneModule.pvpFirstEntrancePanel.removeEventListener(Event.CLOSE,pvpFirstEntrancePanelCloseHandler);
			sceneModule.pvpFirstEntrancePanel = null;
		}
		
		public function showClimbingTowerPanel():void
		{
			if(sceneModule.climbTowerPanel == null)
			{
				sceneModule.climbTowerPanel = new ClimbTowerPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.climbTowerPanel);
				sceneModule.climbTowerPanel.addEventListener(Event.CLOSE,climbingTowerPanelCloseHandler);
			}else
			{
				sceneModule.climbTowerPanel.removeEventListener(Event.CLOSE,climbingTowerPanelCloseHandler);
				sceneModule.climbTowerPanel.dispose();
				sceneModule.climbTowerPanel = null;
			}
		}
		
		public function climbingTowerPanelCloseHandler(evt:Event):void
		{
			sceneModule.climbTowerPanel.removeEventListener(Event.CLOSE,climbingTowerPanelCloseHandler);
			sceneModule.climbTowerPanel = null;
		}
		
		private function initFunctionIcon():void
		{
			if(sceneModule.functionGuideIcon == null)
			{
				sceneModule.functionGuideIcon = new FunctionGuideIconView(this);
				sceneModule.functionGuideIcon.show();
			}
		}
		private function initBankMainPanel(data:Object):void
		{
			if(sceneModule.bankMainPanel == null)
			{
				sceneModule.bankMainPanel = new BankMainPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.bankMainPanel);
				sceneModule.bankMainPanel.addEventListener(Event.CLOSE,bankPanelCloseHandler);
			}
			else
			{
				sceneModule.bankMainPanel.removeEventListener(Event.CLOSE,bankPanelCloseHandler);
				sceneModule.bankMainPanel.dispose();
				sceneModule.bankMainPanel = null;
			}
		}
		private function initOnlineReward(data:Object):void
		{
			if(sceneModule.onlineRewardPanel == null)
			{
				sceneModule.onlineRewardPanel = new OnlineRewardPanel(getOnlineRewardHandler,btnGetAllOnlineRewardClickHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.onlineRewardPanel);
				sceneModule.onlineRewardPanel.addEventListener(Event.CLOSE,onlineRewardPanelCloseHandler);
				sceneModule.onlineRewardInfo.addEventListener(OnlineRewardInfoUpdateEvent.UPDATE,onlineRewardInfoUpdateHandler);
				PlayerDairyAwardListSocketHandler.send();
			}
			else
			{
				sceneModule.onlineRewardPanel.removeEventListener(Event.CLOSE,onlineRewardPanelCloseHandler);
				sceneModule.onlineRewardPanel.dispose();
				sceneModule.onlineRewardPanel = null;
			}
		}
		
		protected function onlineRewardInfoUpdateHandler(event:Event):void
		{
			sceneModule.onlineRewardPanel.updateView(sceneModule.onlineRewardInfo.seconds,sceneModule.onlineRewardInfo.list);
		}
		
		private function btnGetAllOnlineRewardClickHandler():void
		{
			PlayerDairyAwardSocketHandler.send(0);
			
			
		}
		
		private function getOnlineRewardHandler(awardId:int):void
		{
			PlayerDairyAwardSocketHandler.send(awardId);
		}
		
		private function bankPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.bankMainPanel)
			{
				sceneModule.bankMainPanel.removeEventListener(Event.CLOSE,bankPanelCloseHandler);
				sceneModule.bankMainPanel.dispose();
				sceneModule.bankMainPanel = null;
			}
		}
		private function onlineRewardPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.onlineRewardPanel)
			{
				sceneModule.onlineRewardInfo.removeEventListener(OnlineRewardInfoUpdateEvent.UPDATE,onlineRewardInfoUpdateHandler);
					
				sceneModule.onlineRewardPanel.removeEventListener(Event.CLOSE,onlineRewardPanelCloseHandler);
				sceneModule.onlineRewardPanel.dispose();
				sceneModule.onlineRewardPanel = null;
			}
		}
		
		private function initChallenge(data:Object):void
		{
			if(sceneModule.challengePassPanel == null)
			{
				sceneModule.challengePassPanel = new ChallengePassPanel(this,data);
				GlobalAPI.layerManager.addPanel(sceneModule.challengePassPanel);
				sceneModule.challengePassPanel.addEventListener(Event.CLOSE,challengePanelCloseHandler);
			}
			else
			{
				sceneModule.challengePassPanel.removeEventListener(Event.CLOSE,challengePanelCloseHandler);
				sceneModule.challengePassPanel.dispose();
				sceneModule.challengePassPanel = null;
			}
		}
		
		private function challengePanelCloseHandler(evt:Event):void
		{
			if(sceneModule.challengePassPanel)
			{
				sceneModule.challengePassPanel.removeEventListener(Event.CLOSE,challengePanelCloseHandler);
				sceneModule.challengePassPanel.dispose();
				sceneModule.challengePassPanel = null;
			}
		}
		
		/**
		 * 打坐返回
		 * @param nick
		 * 
		 */		
		private function sitInvite(serverId:int,nick:String,id:Number,x:Number,y:Number):void
		{
			if(sceneModule.sitInvitePanel)
			{
				sceneModule.sitInvitePanel.dispose();
			}
			sceneModule.sitInvitePanel = MTimerAlert.show(30,MAlert.REFUSE,LanguageManager.getWord("ssztl.scene.isAcceptDoubleSit",serverId,nick),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,sitInviteClose);
			
			sceneModule.sitInvitePanel.addEventListener(Event.CLOSE,sitInviteCloseHandler);
			function sitInviteClose(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.AGREE)
				{
					walkToDoubleSit(serverId,nick,id,x,y);
//					sendNotification(SceneMediatorEvent.WALKTO_DOUBLESIT,{nick:nick,id:id,x:x,y:y});
				}
				else
				{
					PlayerInviteSitRelaySocketHandler.send(false,id);
				}
			}
		}
		private function sitInviteCloseHandler(evt:Event):void
		{
			sceneModule.sitInvitePanel.removeEventListener(Event.CLOSE,sitInviteCloseHandler);
			sceneModule.sitInvitePanel = null;
		}
		
		private function openPopPanel(obj:Object):void
		{
			if(sceneModule.npcPopPanel == null)
			{
				sceneModule.npcPopPanel = new NpcPopPanel(this);
				sceneModule.npcPopPanel.addEventListener(Event.CLOSE,npcPopPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.npcPopPanel);
			}
			sceneModule.npcPopPanel.setInfo(NpcPopType.getPopInfo(obj["type"],obj["npcId"]));
		}
		private function npcPopPanelCloseHandler(e:Event):void
		{
			if(sceneModule.npcPopPanel)
			{
				sceneModule.npcPopPanel.removeEventListener(Event.CLOSE,npcPopPanelCloseHandler);
				sceneModule.npcPopPanel = null;
			}
		}
		
		private function pkInvite(id:Number):void
		{
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				return;
			}
			if(GlobalData.selfPlayer.level < 40)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unAchieveLeiTaiMinLevel"));
				return;
			}
			if(GlobalData.copyEnterCountList.isInCopy || sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			if(GlobalData.isInTrade)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unInviteLeiTaiOneInTrade"));
				return;
			}
			if(GlobalData.taskInfo.getTransportTask())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unInviteLeiTaiOneInTransport"));
				return;
			}
			PkInviteSocketHandler.send(id);
		}
		
		private function changePKMode(type:int):void
		{
			if(type == GlobalData.selfPlayer.PKMode)return;
//			if(GlobalData.copyEnterCountList.isInCopy || sceneInfo.mapInfo.isSpaScene())
//			{
//				QuickTips.show("特殊场景内不允许此行为。");
//				return;
//			}
//			if(GlobalData.taskInfo.getTransportTask() != null)
//			{
//				QuickTips.show("运镖期间不能修改战斗模式。");
//				return;
//			}
//			if(MapTemplateList.getIsPrison())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
//				return;
//			}
			if(sceneInfo.mapInfo.isShenmoDouScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unChangeFightModeInWarScene"));
				return;
			}
			if(sceneInfo.mapInfo.isClubPointWarScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unChangeFightModeInClubWarScene"));
				return;
			}
			if(GlobalData.taskInfo.getTransportTask() != null && type == PKType.PEACE)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unChangePeaceModeInTransport"));
				return;
			}
			if(GlobalData.selfPlayer.level < 30)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.changeFightModeNeedLevel40"));
				return;
			}
			if(type == PKType.TEAM && GlobalData.leaderId == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.noTeamUnChangeMode"));
				return;
			}
			if(type == PKType.CLUB && GlobalData.selfPlayer.clubId == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.noClubUnChangeMode"));
				return;
			}
//			if(type == PKType.CAMP && GlobalData.selfPlayer.camp == 0)
//			{
//				QuickTips.show("你没有所属阵营，不能切换此模式。");
//				return;
//			}
			var time:Number = DateUtil.getTimeBetween(GlobalData.selfPlayer.PKModeChangeDate,GlobalData.systemDate.getSystemDate());
			var countdown:int = PKType.CHANGE_CD - time / 60000;
			if(type == PKType.PEACE)
			{
				if(GlobalData.selfPlayer.PKValue >= 11)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.redNameUnChangePeaceMode"));
					return;
				}
				else if(countdown > 0)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.changePeaceModeNeedMinValue",countdown));
					return;
				}
			}
			PlayerPKModeChangeSocketHandler.send(type);
		}
		
		private function updateClubTransport():void
		{
			if(GlobalData.clubTransportTime > 0)
			{
				if(sceneModule.clubTransportView == null)
				{
					sceneModule.clubTransportView = new ClubTransportView();
					sceneModule.clubTransportView.setTime(GlobalData.clubTransportTime);
					GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.clubTransportView);
				}
			}
			else
			{
				if(sceneModule.clubTransportView)
				{
					sceneModule.clubTransportView.dispose();
					sceneModule.clubTransportView = null;
				}
			}
		}
		
		public function showTransport():void
		{
			if(sceneModule.transportBtn == null)
			{
				sceneModule.transportBtn = new TransportBtn(this);
//				GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.transportBtn);
			}
			if(sceneModule.inCarTimeView == null)
			{
				sceneModule.inCarTimeView = new InCarTimeView(this);
				sceneModule.inCarTimeView.setTime(sceneInfo.playerList.self.inDarts);
				GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.inCarTimeView);
			}
			if(sceneModule.transportHelpBtn == null)
			{
				sceneModule.transportHelpBtn = new TransportHelpBtn(this);
//				GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.transportHelpBtn);
			}
		}
		
		public function hideTransport():void
		{
			if(sceneModule.transportBtn)
			{
				sceneModule.transportBtn.dispose();
				sceneModule.transportBtn = null;
			}
			if(sceneModule.inCarTimeView)
			{
				sceneModule.inCarTimeView.dispose();
				sceneModule.inCarTimeView = null;
			}
			if(sceneModule.transportPanel)
			{
				sceneModule.transportPanel.removeEventListener(Event.CLOSE,transportCloseHandler);
				sceneModule.transportPanel.dispose();
				sceneModule.transportPanel = null;
			}
			if(sceneModule.transportHelpBtn)
			{
				sceneModule.transportHelpBtn.dispose();
				sceneModule.transportHelpBtn = null;
			}
		}
		
		public function transportHelp():void
		{
			TransportHelpSocketHandler.send();
		}
		
		private function initScene():void
		{
			if(sceneModule.sceneInit == null)
			{
				sceneModule.sceneInit = new SceneContainerInit(this);
			}
		}
		
		private function changeScene():void
		{
			SceneLoadMapDataProxy.clear();
			if(sceneModule.sceneInfo)sceneModule.sceneInfo.changeScene();
			if(sceneModule.sceneInit)
			{
				selfSit(false);
				sceneModule.sceneInit.clear();
				
				GlobalAPI.loaderAPI.changeSceneClear();
//				GCUtil.gc();
				sceneModule.sceneInit.startLoad();
			}
		}
		
		public function loadMapData(id:int,loadComplete:Function = null):void
		{
			SceneLoadMapDataProxy.loadMapData(id,loadComplete);
		}
		
		public function loadMapPre(id:int,loadComplete:Function = null):void
		{
			SceneLoadMapDataProxy.loadMapPre(id,loadComplete);
		}
		
		public function loadNeedMapData(id:int,row:int,col:int,loadComplete:Function = null):void
		{
			SceneLoadMapDataProxy.loadNeedMapData(id,row,col,loadComplete);
		}
		
		public function followPlayer(id:Number):void
		{
			var player:BaseScenePlayerInfo = sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				PlayerFollowSocketHandler.send(id);
				sceneInfo.playerList.self.setFollower(player);
			}
			else
			{
				//提示玩家不在附近，无法跟随
			}
		}
		
		public function useTransfer(sceneId:int, target:Point, npcId:int = 0, checkItem:Boolean = true, checkWalkField:Boolean = false, type:int = 0, targetId:int = 0) : void
		{
			SceneTransferChecker.doTransfer(sceneId, target, npcId, checkItem, checkWalkField, type, targetId);
		}
			
//			if(MapTemplateList.getIsPrison())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
//				return;
//			}
//			if(sceneModule.sceneInit.playerListController.getSelf() == null)
//			{
//				return;
//			}
//			if(GlobalData.copyEnterCountList.isInCopy || sceneInfo.mapInfo.isSpaScene() || MapTemplateList.isClubWarMap() || MapTemplateList.isShenMoMap() || MapTemplateList.isPerWarMap())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
//				return;
//			}
//			if(GlobalData.taskInfo.getTransportTask() != null)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotUseTransfer"));
//				return;
//			}
//			if(!sceneInfo.playerList.self.getIsCommon())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.inWarState"));
//				return;
//			}
//			if(MapTemplateList.isAcrossBossMap())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
//				return;
//			}
//			if(MapTemplateList.getIsPrison())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.scene.sceneUnoperatable"));
//				return;
//			}
//			if(sceneInfo.playerList.isDoubleSit())
//			{
//				if(!_doubleSitalert)
//					_doubleSitalert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,stopDoubleSit);
//			}
//			else
//			{
//				doUse();
//			}
//			function stopDoubleSit(evt:CloseEvent):void
//			{
//				if(evt.detail == MAlert.OK)
//				{
//					PlayerSitSocketHandler.send(false);
//					sceneInfo.playerList.clearDoubleSit();
//					doUse();
//				}
//				_doubleSitalert = null;
//			}
//			function doUse():void
//			{
//				if(sceneModule.sceneInit.playerListController.getSelf().isSit())
//				{
//					selfSit(false);
//				}
//				if(sceneModule.sceneInit.playerListController.getSelf().isMoving)
//				{
//					sceneModule.sceneInit.playerListController.getSelf().stopMoving();
//				}
//				UseTransferShoeSocketHandler.send(sceneId,target.x,target.y);
//				
//				GlobalData.selfPlayer.scenePath = null;
//				GlobalData.selfPlayer.scenePathTarget = null;
//				GlobalData.selfPlayer.scenePathCallback = null;
//			}
//		}
		
	
		public function walk(sceneId:int, p:Point, walkComplete:Function = null, stopAtDistance:Number = 0, clearState:Boolean = true, clearFollowState:Boolean = true, showClickEffect:Boolean = false, clearSpanState:Boolean = true, clearCollectState:Boolean = true):void
		{
			WalkChecker.doWalk(sceneId, p, walkComplete, stopAtDistance, clearState, showClickEffect, clearSpanState, clearCollectState, clearFollowState);
		}
		
		public function walkToNpc(npcId:int, sceneX:Number = -1, sceneY:Number = -1) : void
		{
			WalkChecker.doWalkToNpc(npcId, sceneX, sceneY);
		}
		public function walkToDoor(doorId:int):void
		{
			WalkChecker.doWalkToDoor(doorId);
		}
		
//		public function walkToStall(playerId:Number,pos:Point,sceneId:int,playerName:String = ""):void
//		{
//			sceneModule.sceneInit.walkToStall(playerId,pos,sceneId,playerName);
//		}
		
		public function walkToHangup(monsterId:int,reset:Boolean = true):void
		{
			WalkChecker.doWalkToHangup(monsterId, reset);
		}
//		/**
//		 * 任务面板寻过来杀怪，先判断有没有选中，如果有则不跑到寻路点
//		 * @param monsterId
//		 * @param count
//		 * @param autoFindTask
//		 * 
//		 */		
//		public function walkToTaskAttack(monsterId:int,count:int,autoFindTask:Boolean):void
//		{
//			sceneModule.sceneInit.walkToTaskAttack(monsterId,count,autoFindTask);
//		}
		public function walkToPickup(itemId:Number,sceneX:Number,sceneY:Number,callback:Function = null,clearState:Boolean = true):void
		{
			WalkChecker.doWalkToPickup(itemId, sceneX, sceneY, callback, clearState);
		}
		public function walkToDoubleSit(serverId:int,nick:String,id:Number,x:Number,y:Number):void
		{
			WalkChecker.doWalkToDoubleSit(serverId, nick, id, x, y);
		}
		private function walkToCenterCollect(templateId:int):void
		{
			WalkChecker.doWalkToCenterCollect(templateId);
		}
		
		public function stopMoving(p:Point=null):void
		{
			GlobalData.selfPlayer.scenePath = null;
			GlobalData.selfPlayer.scenePathTarget = null;
			GlobalData.selfPlayer.scenePathCallback = null;
			var self:SelfScenePlayer = sceneModule.sceneInit.playerListController.getSelf();
			var selfInfo:SelfScenePlayerInfo = sceneInfo.playerList.self;
			if (p){
				PlayerMoveSocketHandler.send([p]);
				PlayerMoveStepSocketHandler.send(p.x, p.y, 10000);
			} 
			else {
				if (self && self.isMoving){
					PlayerMoveSocketHandler.send([new Point(selfInfo.sceneX, selfInfo.sceneY)]);
					PlayerMoveStepSocketHandler.send(selfInfo.sceneX, selfInfo.sceneY, 10000);
				}
			}
			if (selfInfo){
				selfInfo.setStand();
				selfInfo.state.setFindPath(false);
			}
		}
		
		
//		/**
//		 * 设为挂机，在挂机状态捡完物品后调用
//		 * 
//		 */		
//		public function setHangup(reset:Boolean = false):void
//		{
//			if(!MapTemplateList.getCanHangup())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotHandUp"));
//				return;
//			}
//			if(reset)
//			{
//				var small:Number = 100000;
//				var monsterList:Array = sceneInfo.mapInfo.getSceneMonsterIds();
//				if(monsterList && monsterList.length > 0)
//				{
//					for(var i:int = 0; i < monsterList.length; i++)
//					{
//						var dis:Number = monsterList[i].getDistance(sceneInfo.playerList.self.sceneX,sceneInfo.playerList.self.sceneY);
//						if(dis < small)
//						{
//							sceneInfo.hangupData.monsterList.unshift(monsterList[i].monsterId);
//							small = dis;
//						}
//						else
//						{
//							sceneInfo.hangupData.monsterList.push(monsterList[i].monsterId);
//						}
//						sceneInfo.hangupData.saveHangup.push(monsterList[i].monsterId);
//					}					
//				}
//				sceneInfo.hangupData.attackPath = MapTemplateList.getMapTemplate(sceneInfo.mapInfo.mapId).attackPath.slice();
//				if(sceneInfo.hangupData.attackIndex == sceneInfo.hangupData.attackPath.length)sceneInfo.hangupData.attackIndex = 0;
//				sceneInfo.hangupData.monsterNeedCount = -1;
//				sceneInfo.hangupData.autoFindTask = false;
//				sceneInfo.hangupData.stopComplete = false;
//				sceneModule.sceneInit.playerListController.getSelf().stopMoving();
//			}
//			sceneInfo.playerList.self.setHangupState();
//		}
		
		
		public function setHangup(reset:Boolean=false):void{
			var small:Number;
			var dis:Number;
			var hangupData:HangupData;
			var monsterList:Array;
			var skillList:Array;
			var i:int;
			var index:int;
			var distance:int;
			var selfPoint:Point;
			var m:int;
			var d:int;
			var monster:BaseSceneMonsterInfo;
			if(!MapTemplateList.getCanHangup())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotHandUp"));
				return;
			}
			if (sceneInfo.playerList.self == null)
			{
				return;
			}
			if (sceneInfo.playerList.self.getIsHangupAttack())
			{
				return;
			}
			if (reset){
				small = 100000;
				hangupData = sceneInfo.hangupData;
				monsterList = sceneInfo.mapInfo.getSceneMonsterIds();
				if (monsterList && monsterList.length > 0){
					hangupData.monsterList.length = 0;
					i = 0;
					while (i < monsterList.length) {
						dis = monsterList[i].getDistance(sceneInfo.playerList.self.sceneX, sceneInfo.playerList.self.sceneY);
						if (dis < small){
							hangupData.monsterList.unshift(monsterList[i].monsterId);
							small = dis;
						}
						else {
							hangupData.monsterList.push(monsterList[i].monsterId);
						}
						i++;
					}
				}
				if (monsterList || MapTemplateList.isGuardDuplicate()){
					hangupData.attackPath = MapTemplateList.getMapTemplate(sceneInfo.mapInfo.mapId).attackPath.slice();
					
					if (hangupData.attackIndex == hangupData.attackPath.length){
						hangupData.attackIndex = 0;
					}
					
					this.stopMoving();
				}
				if (CopyTemplateList.isTowerCopy(GlobalData.copyEnterCountList.inCopyId)){
					hangupData.attackIndex = 1;
					for each (monster in sceneInfo.monsterList.getMonsters()) {
						if (MonsterTemplateList.GUARD_MONSTER.indexOf(monster.templateId) != -1){
							hangupData.attackIndex = 0;
							break;
						}
					}
				}
//				skillList = GlobalData.skillInfo.getSkills();
//				hangupData.reSetSkillList(skillList);
				sceneInfo.playerList.self.state.setHangup(true);
			}
			sceneInfo.playerList.self.setHangupState();
		}
		
		public function petWalk(pet:BaseScenePetInfo,to:Point,stopAtDistance:Number,directly:Boolean = false):void
		{
			sceneModule.sceneInit.petWalk(pet,to,stopAtDistance,directly);
		}
		public function carWalk(car:BaseSceneCarInfo,to:Point,stopAtDistance:Number,directly:Boolean = false):void
		{
			sceneModule.sceneInit.carWalk(car,to,stopAtDistance,directly);
		}
		
		public function pickup(id:int):void
		{
			PlayerGetDropItemSocketHandler.sendGetDrop(id);
		}
		public function pickUpRound(checkHangup:Boolean = true):void
		{
			if(!sceneInfo.playerList.self)return;
			var selfPos:Point = new Point(sceneInfo.playerList.self.sceneX,sceneInfo.playerList.self.sceneY);
			var list:Array = sceneInfo.dropItemList.getAllCanPick();
			for each(var i:DropItemInfo in list)
			{
				//判断是否符合拾取设置规则
				if(checkHangup && !sceneInfo.hangupData.getDropCanPick(i))
					continue;
				if(i.getDistance(selfPos) < CommonConfig.PICKUP_RADIUS)
				{
					if(!GlobalData.bagInfo.getHasPos(1))
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.unPickUp"));
//						break;
					}
					else
					{
						pickup(i.id);
					}
					//捡一个停掉
					break;
				}
			}
		}
		
		public function startCollect(id:int,templateId:int):void
		{
			PlayerStartCollectSocketHandler.send(id,templateId);
		}
		
		public function stopcollect():void
		{
			PlayerStopCollectSocketHandler.send();
		}
		
		public function collect(id:int,templateId:int):void
		{
			PlayerCollectSocketHandler.send(id,templateId);
		}
		
		
		public function mountAvoid():void
		{
			sendNotification(SceneMediatorEvent.CHANGE_MOUNTAVOID);
		}
		public function enterDuplicate(id:int):void
		{
			
		}
		public function gotoScene(id:int):void
		{
			var mapId:int = DoorTemplateList.getDoorTemplate(id).mapId;
			var map:MapTemplateInfo = MapTemplateList.list[mapId];
			/**答题地图处理**/
			if(MapTemplateList.isQuestionMap(DoorTemplateList.getDoorTemplate(id).nextMapId))
			{
				if(GlobalData.selfPlayer.level < 30)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotEnterMap",30));
//					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,LanguageManager.getWord("ssztl.scene.cannotEnterMap",30)));
				}
				else
				{
					GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.loadingMap"));
					MapEnterSocketHandler.sendMapEnter(id);
//					MAlert.show(LanguageManager.getWord("ssztl.scene.autoChangeFightModeEnterScene"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
				}
//				function closeHandler(e:CloseEvent):void
//				{
//					if(e.detail == MAlert.OK)
//					{
//						GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.loadingMap"));
//						MapEnterSocketHandler.sendMapEnter(id);
//					}
//				}
			}
			else if(MapTemplateList.isShenMoIsland())
			{
				GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.loadingMap"));
				CopyIslandDoorEnterSocketHandler.send(id);
			}
			else if(MapTemplateList.isPassDuplicate())
			{
				//优先判断是否怪物全部被清除了
				if(sceneModule.duplicatePassInfo.passState)
				{
					GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.loadingMap"));
					MapEnterSocketHandler.sendMapEnter(id);
				}
				else
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.enterNextAttention"));
//						LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null,null);
				}
//				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,LanguageManager.getWord("ssztl.scene.unEnterMonster")));
			}
			else if(MapTemplateList.isIsOrNot() && GlobalData.quizInfo.hasBegun)
			{
				MAlert.show(
					LanguageManager.getWord("ssztl.quiz.alert") ,
					LanguageManager.getWord("ssztl.common.alertTitle"),
					MAlert.OK | MAlert.CANCEL,null,closeHandler1);
				
				function closeHandler1(e:CloseEvent):void
				{
					if(e.detail == MAlert.OK)
					{
						MapEnterSocketHandler.sendMapEnter(id);
						//关闭窗口
						ModuleEventDispatcher.dispatchQuizEvent(new QuizModuleEvent(QuizModuleEvent.QUIZ_END));
					}
				}
			}
			else
			{
				if(GlobalData.selfPlayer.level >= map.minLevel && GlobalData.selfPlayer.level <= map.maxLevel)
				{
					GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.loadingMap"));
					MapEnterSocketHandler.sendMapEnter(id);
				}
				else
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,LanguageManager.getWord("ssztl.scene.unEnterLevelNotMatch")));
				}
			}
		}
		
		public function getCanAttackPlayer(player:BaseScenePlayerInfo,showTip:Boolean = true):Boolean
		{
			if(!sceneInfo.playerList.self)return false;
			var self:SelfPlayerInfo = GlobalData.selfPlayer;
			if(sceneInfo.attackList.attackList.indexOf(player.info.userId) != -1)
			{
				return true;
			}
			if(sceneInfo.mapInfo.getIsSafeArea())return false;
			if(sceneInfo.mapInfo.isShenmoDouScene())
			{
				return player.warState != sceneInfo.playerList.self.warState;
			}
			else if(sceneInfo.mapInfo.isAcrossServer())
			{
				return true;//player.info.serverId != GlobalData.selfPlayer.serverId;
			}
			else if(GlobalData.copyEnterCountList.isPKCopy())
			{
				if(getTimer() - GlobalData.copyEnterCountList.pkEnterTime < 10000) return false;
				return true;
			}
			else
			{
				if(!GlobalData.selfPlayer.isClubEnemy(player.info.clubId))
				{
					if(self.PKMode == PKType.PEACE)
					{
						if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unattackInPeaceMode"));
						return false;
					}
					if(player.info.PKMode == PKType.PEACE)
					{
						if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unPKInPeaceMode"));
						return false;
					}
				}
				if(self.PKMode == PKType.GOODNESS && player.info.PKValue == 0)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackNotRedName"));
					return false;
				}
				if(self.PKMode == PKType.TEAM && sceneInfo.teamData.getPlayer(player.info.userId) != null)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackInSameTeam"));
					return false;
				}
				if(self.PKMode == PKType.CLUB && player.info.clubId == self.clubId)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackInSameClub"));
					return false;
				}
//				if(self.PKMode == PKType.CAMP && player.info.camp == self.camp)
//				{
//					if(showTip)QuickTips.show("对方和您处于同一个阵营，无法攻击！");
//					return false;
//				}
//				if(self.PKMode == PKType.CAMP && player.info.serverId == self.serverId)
//				{
//					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackInSameCmp"));
//					return false;
//				}
				if(self.level < 30)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackSelfLevelLow30"));
					return false;
				}
				if(player.info.level < 30)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackPlayerLevelLow30"));
					return false;
				}
			}
			return true;
		}
		
//		public function attack(role:BaseRoleInfo,type:int,skill:SkillItemInfo = null):void
//		{
//			var self:SelfScenePlayerInfo = sceneInfo.playerList.self;
//			if(MapElementType.isPlayer(type))
//			{
//				if(skill.getTemplate().templateId == 3162)
//				{
//					if(!role.getIsDead())return;
//				}
//				else
//				{
//					if(!role.getCanAttack())return;
//					if(!getCanAttackPlayer(BaseScenePlayerInfo(role),false) && skill.getTemplate().activeType == 0)return;
//				}
//			}
//			if(self.getIsReady())return;
//			if(self.getIsDeadOrDizzy())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.scene.unOperateInHitDownState"));
//				return;
//			}
//			//判断是否能打
//			if(skill == null)
//			{
//				skill = GlobalData.skillInfo.getDefaultSkill();
//			}
////			else
////			{
////				if(role.state.getDizzy() && skill.getAffectCount() == 1)
////				{
////					skill = GlobalData.skillInfo.getDefaultSkill();
////				}
////			}
//			if(skill == null)return;
//			//坐着的话，站起
//			if(self.info.isSit())
//			{
//				selfSit(false);
//			}
//			var range:int = int(skill.getTemplate().range[skill.level - 1]) - 25;
//			if(range < 75)range = 75;
//			if(Point.distance(new Point(role.sceneX,role.sceneY),new Point(self.sceneX,self.sceneY)) <= range)
//			{
//				doAttack();
//			}
//			else
//			{
//				walk(sceneInfo.getSceneId(),new Point(role.sceneX,role.sceneY),doAttack,range,false);
//			}
//			
//			function doAttack():void
//			{
//				if(skill.getCanUse() && getCanUse())
//				{
//					if(!self || !sceneModule.sceneInit.playerListController.getSelf())return;
////					//下马
////					if(self.getIsMount())
////					{
////						PlayerSetHouseSocketHandler.send(false);
////					}
//					sceneModule.sceneInit.playerListController.getSelf().stopMoving();
//					//自己先播放动画
//					var actionInfo:AttackActionInfo = new AttackActionInfo();
//					actionInfo.actorId = GlobalData.selfPlayer.userId;
//					actionInfo.targetX = role.sceneX;
//					actionInfo.targetY = role.sceneY;
//					actionInfo.actorType = MapElementType.PLAYER;
//					actionInfo.skill = skill.templateId;
//					actionInfo.level = skill.level;
//					if(skill.getTemplate().getPrepareTime(skill.level) > 0)
//					{
//						self.addAction(new PlayerWaitAttackAction(actionInfo));
//					}
//					else
//					{
//						self.addAction(new PlayerAttackAction(actionInfo));
//					}
//					skill.isInCommon = false;
//					//技能时间
//					skill.lastUseTime = GlobalData.systemDate.getSystemDate().getTime();
//					if(!skill.getTemplate().isDefault)
//					{
//						for each(var i:SkillItemInfo in GlobalData.skillInfo.getSkills())
//						{
//							if(i != skill)i.isInCommon = true;
//							i.setCommonCD();
//						}
//					}
//					PlayerAttackSocketHandler.sendAttack(role.getObjId(),type,skill.templateId,role.sceneX,role.sceneY);
//				}
//			}
//			
//			function getCanUse():Boolean
//			{
//				if(skill.getTemplate().activeType == 0)
//				{
//					if(MapElementType.isPlayer(type) && !getCanAttackPlayer(BaseScenePlayerInfo(role),false))return false;
//					return true;
//				}
//				//辅助技能
//				
//				if(GlobalData.canUseAssist && MapElementType.isPlayer(type) && skill.getTemplate().activeType == 2)return true;
//				return false;
//			}
//		}
//		
//		public function skillAttack(skill:SkillItemInfo = null):void
//		{
//			var target:BaseRoleInfo = sceneInfo.getCurrentSelect();
//			if(target == null && skill == null)return;
//			if(skill == null)
//			{
//				//默认攻击
//				if(MapElementType.attackAble(target.getObjType()))
//				{
//					attack(target,target.getObjType(),skill);
//				}
//				return;
//			}
//			if(target == null)
//			{
//				if(skill.getTemplate().unNeedTarget())
//				{
//					attack(sceneInfo.playerList.self,MapElementType.PLAYER,skill);
//				}
//				return;
//			}
//			if(skill.getTemplate().isAttack() && !MapElementType.attackAble(target.getObjType()))
//			{
//				//如果是玩家，需要再判断玩家类型
//				return;
//			}
////			if(!skill.getTemplate().isAttack() && !MapElementType.isPlayer(target.getObjType()))
////			{
////				//如果不是攻击类型，判断玩家类型是否可使用
////				return;
////			}
//			if(!skill.getTemplate().isAttack())
//			{
//				if(!MapElementType.isPlayer(target.getObjType()) || (MapElementType.isPlayer(target.getObjType()) && getCanAttackPlayer(BaseScenePlayerInfo(target),false)))
//				{
//					attack(sceneInfo.playerList.self,MapElementType.PLAYER,skill);
//					return;
//				}
//			}
//			attack(target,target.getObjType(),skill);
//			if(skill.getTemplate().isAttack())sceneInfo.playerList.self.setKillOne();
//		}
		
		public function shakeScene():void
		{
			sceneModule.sceneInit.shakeScene();
		}
		
		public function shakeScene1():void
		{
			sceneModule.sceneInit.shakeScene1();
		}
		
		public function showDoubleSitPanel():void
		{
			sendNotification(SceneMediatorEvent.SCENE_SHOWDOUBLESIT);
		}
		
		public function showLifeExpSitPanel():void
		{
			sendNotification(SceneMediatorEvent.SCENE_SHOW_LIFE_EXP_SIT);
		}
		
//		private function sitInvite(nick:String):void
//		{
//			if(sceneModule.sitInvitePanel)
//			{
//				sceneModule.sitInvitePanel.dispose();
//			}
//			sceneModule.sitInvitePanel = MAlert.show(nick + "邀请你一起打坐，是否同意",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,sitInviteClose);
//			sceneModule.sitInvitePanel.addEventListener(Event.CLOSE,sitInviteCloseHandler);
//		}
//		private function sitInviteClose(evt:CloseEvent):void
//		{
//			PlayerInviteSitRelaySocketHandler.send(evt.detail == MAlert.AGREE);
//		}
//		private function sitInviteCloseHandler(evt:Event):void
//		{
//			sceneModule.sitInvitePanel.removeEventListener(Event.CLOSE,sitInviteCloseHandler);
//		}
		
		public function showNpcPanel(npcId:int):void
		{
			var result:Array = GlobalData.taskInfo.getTaskNoSubmitByNpcId(npcId);
			var canAccepts:Array = TaskTemplateList.getCanAcceptTaskByNpcId(npcId);
			var npcInfo:NpcTemplateInfo = NpcTemplateList.getNpc(npcId);
			var i:int = 0;
			var count:int = 0;
			var submitId:int,acceptId:int;
			
			var selfInfo:SelfScenePlayerInfo = sceneInfo.playerList.self;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)return;
			
			for(i = 0; i < result[0].length; i++)
			{
//				if(result[0][i].getTemplate().condition != TaskConditionType.TRANSPORT)
//				{
					count++;
					if(submitId == 0)submitId = result[0][i].getTemplate().taskId;
//				}
			}
			for(i = 0; i < canAccepts.length; i++)
			{
				if(canAccepts[i].condition != TaskConditionType.TRANSPORT)
				{
					count++;
					if(acceptId == 0)acceptId = canAccepts[i].taskId;
				}
			}
			for(i = 0; i < result[1].length; i++)
			{
//				if(result[1][i].getTemplate().condition != TaskConditionType.TRANSPORT)
//				{
					count++;
//				}
			}
			count += NpcTemplateList.getNpc(npcId).deploys.length;
			
			if(submitId != 0 || acceptId != 0)
			{
				if(submitId != 0)showNpcTask(submitId,npcId);
				else if(acceptId != 0)showNpcTask(acceptId,npcId);
			}
			else
			{
				if(sceneModule.npcPanel == null)
				{
					sceneModule.npcPanel = new NpcPanel(this,npcInfo.name);
					GlobalAPI.layerManager.addPanel(sceneModule.npcPanel);
					sceneModule.npcPanel.addEventListener(Event.CLOSE,npcPanelCloseHandler);
				}
				else
				{
					sceneModule.npcPanel.removeEventListener(Event.CLOSE,npcPanelCloseHandler);
					sceneModule.npcPanel.dispose();
					
					sceneModule.npcPanel = new NpcPanel(this,npcInfo.name);
					GlobalAPI.layerManager.addPanel(sceneModule.npcPanel);
					sceneModule.npcPanel.addEventListener(Event.CLOSE,npcPanelCloseHandler);
				}
				sceneModule.npcPanel.npcInfo = npcInfo;
			}
		}
		
		private function npcPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.npcPanel)
			{
				sceneModule.npcPanel.removeEventListener(Event.CLOSE,npcPanelCloseHandler);
				sceneModule.npcPanel = null;
			}
		}
		
		public function showTransportPanel():void
		{
			if(sceneModule.transportPanel == null)
			{
				sceneModule.transportPanel = new TransportPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.transportPanel);
				sceneModule.transportPanel.addEventListener(Event.CLOSE,transportCloseHandler);
			}
		}
		private function transportCloseHandler(e:Event):void
		{
			if(sceneModule.transportPanel)
			{
				sceneModule.transportPanel.removeEventListener(Event.CLOSE,transportCloseHandler);
				sceneModule.transportPanel = null;
			}
		}
		
		private function showPaopao(obj:Object):void
		{
			var id:Number = obj["id"];
			var message:String = obj["message"];
			var role:BaseRole = sceneModule.sceneInit.playerListController.getPlayer(id);
			if(role == null)role = sceneModule.sceneInit.monsterListController.getMonster(id);
			if(role)
			{
				role.showPaopao(message);
			}
		}
		
		public function selfSit(value:Boolean,tip:Boolean = true):void
		{
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				return;
			}
			if(value == false)
			{
				if(sceneModule.sceneInfo.playerList.isDoubleSit())
				{
					if(tip)
					{
						if(!_doubleSitalert)
							_doubleSitalert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,stopDoubleSit);
					}
					else
					{
						sceneModule.sceneInfo.playerList.clearDoubleSit();
						doSet();
					}
				}
				else
				{
					doSet();
				}
			}
			else
			{
				doSet();
			}
			function stopDoubleSit(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					sceneModule.sceneInfo.playerList.clearDoubleSit();
					doSet();
				}
				_doubleSitalert = null;
			}
			function doSet():void
			{
				if(!sceneModule.sceneInfo.playerList.self)return;
				if(sceneModule.sceneInfo.playerList.self.info.isSit() && !value)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.exitSitState"));
					if(ExpSitPanel.getInstance().parent)
					{
						ExpSitPanel.getInstance().hide();
					}
				}
				if(value)
				{
					if(sceneInfo.mapInfo.isSpaScene())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
					}
					else if(sceneModule.sceneInfo.playerList.self.getIsCommon())
					{
						sceneModule.sceneInit.playerListController.getSelf().stopMoving();
						GlobalData.selfPlayer.setSit(true);
						PlayerSitSocketHandler.send(true);
					}
					else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.unSitableInFight"));
					}
				}
				else
				{
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					GlobalData.selfPlayer.setSit(false);
					PlayerSitSocketHandler.send(false);
				}
			}
			
		}
		
		public function showNpcTask(taskId:int,npcId:int):void
		{
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.SHOW_NPCTASKPANEL,{taskId:taskId,npcId:npcId}));
		}
		
		public function showStall(playerId:Number,playerName:String = ""):void
		{
			SetModuleUtils.addStall(playerId,playerName);
		}
		
		public function showHangup():void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWHANGUP);
		}
		
		public function toSwim(data:Object):void
		{
			var state:int = -1;
			if(sceneInfo.playerList.self)state = sceneInfo.playerList.self.warState;
			if(state == 5 && data["side"] == 1)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.selfInSpa"));
				return;
			}
			else if(state != 5 && data["side"] == 2)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.selfNotInSpa"));
				return;
			}
			SpaPondSocketHandler.send(data["index"]);
		}
		
		//打开接镖面板
		public function showAcceptTransportPanel(quality:int):void
		{
			if(sceneModule.acceptTransportPanel == null)
			{
				sceneModule.acceptTransportPanel = new AcceptTransportPanel(this,quality);
				GlobalAPI.layerManager.addPanel(sceneModule.acceptTransportPanel);
				sceneModule.acceptTransportPanel.addEventListener(Event.CLOSE,acceptTransportCloseHandler);
			}
			else
			{
				sceneModule.acceptTransportPanel.updateQuality(quality);
			}
		}
		//关闭接镖面板
		public function acceptTransportCloseHandler(evt:Event):void
		{
			sceneModule.acceptTransportPanel.removeEventListener(Event.CLOSE,acceptTransportCloseHandler);
			sceneModule.acceptTransportPanel = null;
		}
		//打开个人运镖奖励面板
		public function showTransportAwardPanel(taskTemplate:TaskTemplateInfo):void
		{
			if(sceneModule.transportAwardPanel == null)
			{
				sceneModule.transportAwardPanel = new TransportAwardPanel(taskTemplate);
				GlobalAPI.layerManager.addPanel(sceneModule.transportAwardPanel);
				sceneModule.transportAwardPanel.addEventListener(Event.CLOSE,transportAwardCloseHandler);
			}		
		}
		//关闭个人运镖奖励面板
		public function transportAwardCloseHandler(evt:Event):void
		{
			sceneModule.transportAwardPanel.removeEventListener(Event.CLOSE,transportAwardCloseHandler);
			sceneModule.transportAwardPanel = null;
		}
		
		//显示全服运镖剩余时间
		public function showServerTransprotLeftTimeView(second:Number):void
		{
			if(sceneModule.serverTransportLeftTimeView == null)
			{
				sceneModule.serverTransportLeftTimeView = new ServerTransportLeftTimeView(this);
				sceneModule.serverTransportLeftTimeView.setTime(second);
				GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.serverTransportLeftTimeView);
				sceneModule.serverTransportLeftTimeView.addEventListener(Event.CLOSE,serverTransprotLeftCloseHandler);
			}
		}
		//隐藏全服运镖剩余时间
		public function serverTransprotLeftCloseHandler(evt:Event):void
		{
			if(sceneModule.serverTransportLeftTimeView)
			{
				sceneModule.serverTransportLeftTimeView.removeEventListener(Event.CLOSE,serverTransprotLeftCloseHandler);
				sceneModule.serverTransportLeftTimeView.dispose();
				sceneModule.serverTransportLeftTimeView = null;
			}
		}
		
		//显示全服运镖面板
		public function showServerTransportPanel():void
		{
			if(sceneModule.serverTransportPanel == null)
			{
				sceneModule.serverTransportPanel = new ServerTransportPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.serverTransportPanel);
				sceneModule.serverTransportPanel.addEventListener(Event.CLOSE,serverTransportCloseHandler);
			}
		}
		
		private function serverTransportCloseHandler(evt:Event):void
		{
			sceneModule.serverTransportPanel.removeEventListener(Event.CLOSE,serverTransportCloseHandler);
			sceneModule.serverTransportPanel = null;
		}
		
		public function showFunctionGuidePanel():void
		{
			if(sceneModule.functionGuidePanel)
			{
				sceneModule.functionGuidePanel.dispose();
			}
			else
			{
				sceneModule.functionGuidePanel = new FunctionGuidePanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.functionGuidePanel);
				sceneModule.functionGuidePanel.addEventListener(Event.CLOSE,functionGuideCloseHandler);
			}
		}
		
		private function functionGuideCloseHandler(evt:Event):void
		{
			sceneModule.removeEventListener(Event.CLOSE,functionGuideCloseHandler);
			sceneModule.functionGuidePanel = null;
		}
		
		public function showFunctionDetailPanel(info:FunctionGuideItemInfo):void
		{
			if(sceneModule.functionDetailPanel)
			{
				sceneModule.functionDetailPanel.removeEventListener(Event.CLOSE,functionDetailCloseHandler);
				sceneModule.functionDetailPanel.dispose();
			}
			sceneModule.functionDetailPanel = new FunctionDetailPanel(info);
			GlobalAPI.layerManager.addPanel(sceneModule.functionDetailPanel);
			sceneModule.functionDetailPanel.addEventListener(Event.CLOSE,functionDetailCloseHandler);
		}
		
		private function functionDetailCloseHandler(evt:Event):void
		{
			sceneModule.functionDetailPanel.removeEventListener(Event.CLOSE,functionDetailCloseHandler);
			sceneModule.functionDetailPanel = null;
		}
		
		public function sendMapRound():void
		{
			MapRoundInfoSocketHandler.send();
		}
		
		public function frieworkPlay(data:Object):void
		{
			sceneModule.sceneInit.playFirework(data["id"],data["type"]);
		}
		public function rosePlay():void
		{
			sceneModule.sceneInit.rosePlay();
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
		
		public function get shenMoWarInfo():ShenMoWarInfo
		{
			return sceneModule.shenMoWarInfo;
		}
		
		public function get clubPointWarInfo():ClubPointWarInfo
		{
			return sceneModule.clubPointWarInfo;
		}
		
		public function get crystalWarInfo():CrystalWarInfo
		{
			return sceneModule.crystalWarInfo;
		}
		
		public function get perWarInfo():PerWarInfo
		{
			return sceneModule.perWarInfo;
		}
		
		public function get copyIslandInfo():CopyIslandInfo
		{
			return sceneModule.copyIslandInfo;
		}
		
		public function get duplicateMonyeInfo():DuplicateMoneyInfo
		{
			return sceneModule.duplicateMonyeInfo;
		}
		public function get duplicateGuardInfo():DuplicateGuardInfo
		{
			return sceneModule.duplicateGuardInfo;
		}		
		public function get duplicatePassInfo():DuplicatePassInfo
		{
			return sceneModule.duplicatePassInfo;
		}
		public function get duplicateChallInfo():DuplicateChallInfo
		{
			return sceneModule.duplicateChallInfo;
		}
		public function get duplicateNormalInfo():DuplicateNormalInfo
		{
			return sceneModule.duplicateNormalInfo;
		}
		public function get duplicateMayaInfo():DuplicateMayaInfo
		{
			return sceneModule.duplicateMayaInfo;
		}
		
		public function get monsterList():SceneMonsterList
		{
			return sceneModule.sceneInfo.monsterList;
		}
				
		private function dispose():void
		{
			viewComponent = null;
		}
	}
}