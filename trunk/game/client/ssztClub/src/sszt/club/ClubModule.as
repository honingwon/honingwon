package sszt.club
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.club.components.clubMain.ClubMainPanel;
	import sszt.club.components.clubMain.pop.ClubApplyPanel;
	import sszt.club.components.clubMain.pop.ClubContributePanel;
	import sszt.club.components.clubMain.pop.ClubDeviceManagePanel;
	import sszt.club.components.clubMain.pop.ClubInfoCheckPanel;
	import sszt.club.components.clubMain.pop.ClubLevelUpPanel;
	import sszt.club.components.clubMain.pop.MasterFunctionPanel;
	import sszt.club.components.clubMain.pop.camp.ClubBossPanel;
	import sszt.club.components.clubMain.pop.camp.ClubCollectionPanel;
	import sszt.club.components.clubMain.pop.lottery.ClubLotteryPanel;
	import sszt.club.components.clubMain.pop.mail.TeamMailPanel;
	import sszt.club.components.clubMain.pop.manage.ClubDismissPanel;
	import sszt.club.components.clubMain.pop.manage.ClubExitPanel;
	import sszt.club.components.clubMain.pop.manage.InvitePanel;
	import sszt.club.components.clubMain.pop.manage.war.WarPanel;
	import sszt.club.components.clubMain.pop.shop.ShopPanel;
	import sszt.club.components.clubMain.pop.store.ClubStoreAppliedItemRecordsPanel;
	import sszt.club.components.clubMain.pop.store.ClubStoreExamineAndVerifyPanel;
	import sszt.club.components.clubMain.pop.store.ClubStorePanel;
	import sszt.club.components.clubMain.pop.store.ClubStoreRecordsPanel;
	import sszt.club.components.create.ClubCreatePanel;
	import sszt.club.datas.ClubInfo;
	import sszt.club.datas.camp.ClubCampInfo;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.socketHandlers.ClubDetailSocketHandler;
	import sszt.club.socketHandlers.ClubEnterClubScenceSocketHandler;
	import sszt.club.socketHandlers.SetClubSocketHandlers;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToClubData;
	import sszt.core.data.player.PlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.club.ItemUserShopSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ClubModuleEvent;
	import sszt.interfaces.module.IModule;
	import sszt.module.ModuleEventDispatcher;

	/**
	 * 此模块加载一次，不完全dispose,只对相应的界面做dispose
	 * @author Administrator
	 * 
	 */	
	public class ClubModule extends BaseModule
	{
		public var clubFacade:ClubFacade;
		public var clubInfo:ClubInfo;
		public var clubCampInfo:ClubCampInfo;
		
		public var clubId:Number;
		
		public var clubStorePanel:ClubStorePanel;
		public var shopPanel:ShopPanel;
		public var invitePanel:InvitePanel;
		public var dismissPanel:ClubDismissPanel;
		public var exitPanel:ClubExitPanel;
		public var warPanel:WarPanel;
		public var teamMailPanel:TeamMailPanel;
		public var infoCheckPanel:ClubInfoCheckPanel;
		public var applyPanel:ClubApplyPanel;
		public var createPanel:ClubCreatePanel;
		
		public var newClubMainPanel:ClubMainPanel;
		
		public var deviceManagePanel:ClubDeviceManagePanel;
		public var newContributePanel:ClubContributePanel;
		public var masterFunctionPanel:MasterFunctionPanel;
		public var newLevelUpPanel:ClubLevelUpPanel;
		public var storeAppliedItemRecordsPanel:ClubStoreAppliedItemRecordsPanel;
		public var storeExamineAndVerifyPanel:ClubStoreExamineAndVerifyPanel;
		public var storeRecords:ClubStoreRecordsPanel;
		public var assetsReady:Boolean;
		
		public var clubBossPanel:ClubBossPanel;
		public var clubCollectionPanel:ClubCollectionPanel;
		
		public var clubLotteryPanel:ClubLotteryPanel;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			
			SetClubSocketHandlers.add(this);
			
			clubInfo = new ClubInfo();
			clubCampInfo = new ClubCampInfo();
			
			clubFacade = ClubFacade.getInstance(String(moduleId));
			clubFacade.setup(this);
			
			configure(data);
		}
		
//		override public function configure(data:Object):void
//		{
//			var toclubData:ToClubData = data as ToClubData;
//			clubId = toclubData.clubId;
//			
//			if(clubId == 0)clubId = GlobalData.selfPlayer.clubId;
//			if(toclubData.showType == 1)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CREATEPANEL);
//			else if(toclubData.showType == 2)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBLIST);
//			else if(toclubData.showType == 3)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBMAIN,clubId);
//			else if(toclubData.showType == 4)
//			{
//				if(clubId == 0)
//				{
//					QuickTips.show("没有加入帮会，不能进入帮会场景!");
//				}
//				else
//				{
//					ClubEnterClubScenceSocketHandler.sendEnter();
//				}
//			}
//			else if(toclubData.showType == 5)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUB_WAR_PANEL,1);
//			
//		}
		
		override public function configure(data:Object):void
		{
			ItemUserShopSocketHandler.send(); //玩家购买帮会物品信息
			var toclubData:ToClubData = data as ToClubData;
			clubId = toclubData.clubId;
			
			if(clubId == 0)clubId = GlobalData.selfPlayer.clubId;
			if(toclubData.showType == 1)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CREATEPANEL);
			else if(toclubData.showType == 2)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBLIST,data);
			else if(toclubData.showType == 3)
			{
				if(newClubMainPanel)
				{
					if(GlobalAPI.layerManager.getTopPanel() != newClubMainPanel)
					{
						newClubMainPanel.setToTop();
					}
					else
					{
						newClubMainPanel.dispose();
					}
				}else
				{
					clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBMAIN,data);
				}
			}
			else if(toclubData.showType == 4)
			{
				if(clubId == 0)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.club.noJionClub"));
				}
				else
				{
					ClubEnterClubScenceSocketHandler.sendEnter();
				}
			}
			else if(toclubData.showType == 5)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUB_WAR_PANEL,1);
			else if(toclubData.showType == 6)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBSHOP);
			else if(toclubData.showType == 7)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBPANEL,data);
			else if(toclubData.showType == 8)clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBSTORE,data);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			GlobalData.selfPlayer.addEventListener(PlayerInfoUpdateEvent.CLUBINFO_UPDATE,clubInfoUpdateHandler);
//			ModuleEventDispatcher.addClubEventListener(ClubModuleEvent.CLUB_KICK,kickHandler);
			ModuleEventDispatcher.addClubEventListener(ClubModuleEvent.CLUB_TRANSFER,transferHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			GlobalData.selfPlayer.removeEventListener(PlayerInfoUpdateEvent.CLUBINFO_UPDATE,clubInfoUpdateHandler);
//			ModuleEventDispatcher.removeClubEventListener(ClubModuleEvent.CLUB_KICK,kickHandler);
			ModuleEventDispatcher.removeClubEventListener(ClubModuleEvent.CLUB_TRANSFER,transferHandler);
		}
		
//		private function kickHandler(evt:ClubModuleEvent):void
//		{
//			clubFacade.sendNotification(ClubMediatorEvent.CLUB_KICK,evt.data);
//		}
		
		private function transferHandler(evt:ClubModuleEvent):void
		{
			clubFacade.sendNotification(ClubMediatorEvent.CLUB_TRANSFER,evt.data);
		}
		
		private function clubInfoUpdateHandler(e:PlayerInfoUpdateEvent):void
		{
			if(!ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty))
			{
				if(invitePanel)
				{
					invitePanel.dispose();
					invitePanel = null;
				}
				if(dismissPanel)
				{
					dismissPanel.dispose();
					dismissPanel = null;
				}
				if(teamMailPanel)
				{
					teamMailPanel.dispose();
					teamMailPanel = null;
				}
				if(newClubMainPanel)
				{
					newClubMainPanel.dispose();
					newClubMainPanel = null;
				}
			}
		}
		
		override public function assetsCompleteHandler():void
		{
			assetsReady = true;
			//若面板打开后，assets还未加载完成，那么为了保证面板资源加载，在assets加载完成后，进行面板打开与否的检测。
			//若面板打开，则进行相应资源加载。
			if(newClubMainPanel)
			{
				newClubMainPanel.assetsCompleteHandler();
			}
			if(teamMailPanel)
			{
				teamMailPanel.assetsCompleteHandler();
			}
			if(clubStorePanel)
			{
				clubStorePanel.assetsCompleteHandler();
			}
			if(shopPanel)
			{
				shopPanel.assetsCompleteHandler();
			}
			if(clubBossPanel)
			{
				clubBossPanel.assetsCompleteHandler();
			}
			if(clubCollectionPanel)
			{
				clubCollectionPanel.assetsCompleteHandler();
			}
			if(clubLotteryPanel)
			{
				clubLotteryPanel.assetsCompleteHandler();
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.CLUB;
		}
		
		public function disposePanels():void
		{
			if(createPanel)
			{
				createPanel.dispose();
				createPanel = null;
			}
			if(clubStorePanel)
			{
				clubStorePanel.dispose();
				clubStorePanel = null;
			}
			if(shopPanel)
			{
				shopPanel.dispose();
				shopPanel = null;
			}
			if(invitePanel)
			{
				invitePanel.dispose();
				invitePanel = null;
			}
			if(dismissPanel)
			{
				dismissPanel.dispose();
				dismissPanel = null;
			}
			if(exitPanel)
			{
				exitPanel.dispose();
				exitPanel = null;
			}
			if(teamMailPanel)
			{
				teamMailPanel.dispose();
				teamMailPanel = null;
			}
			if(infoCheckPanel)
			{
				infoCheckPanel.dispose();
				infoCheckPanel = null;
			}			
			if(applyPanel)
			{
				applyPanel.dispose();
				applyPanel = null;
			}			
			if(newClubMainPanel)
			{
				newClubMainPanel.dispose();
				newClubMainPanel = null;
			}
			if(deviceManagePanel)
			{
				deviceManagePanel.dispose();
				deviceManagePanel = null;
			}
			if(newContributePanel)
			{
				newContributePanel.dispose();
				newContributePanel = null;
			}
			if(masterFunctionPanel)
			{
				masterFunctionPanel.dispose();
				masterFunctionPanel = null;
			}
			if(newLevelUpPanel)
			{
				newLevelUpPanel.dispose();
				newLevelUpPanel = null;
			}
			if(storeAppliedItemRecordsPanel)
			{
				storeAppliedItemRecordsPanel.dispose();
				storeAppliedItemRecordsPanel = null;
			}
			if(storeExamineAndVerifyPanel)
			{
				storeExamineAndVerifyPanel.dispose();
				storeExamineAndVerifyPanel = null;
			}
			if(storeRecords)
			{
				storeRecords.dispose();
				storeRecords = null;
			}
		}
		
		override public function dispose():void
		{
			SetClubSocketHandlers.remove();
			disposePanels();
			if(clubFacade)
			{
				clubFacade.dispose();
				clubFacade = null;
			}
			clubInfo = null;
			super.dispose();
		}
	}
}