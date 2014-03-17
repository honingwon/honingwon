package sszt.club.mediators
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.club.ClubModule;
	import sszt.club.components.clubMain.ClubMainPanel;
	import sszt.club.components.clubMain.pop.ClubApplyPanel;
	import sszt.club.components.clubMain.pop.ClubContributePanel;
	import sszt.club.components.clubMain.pop.ClubDeviceManagePanel;
	import sszt.club.components.clubMain.pop.ClubInfoCheckPanel;
	import sszt.club.components.clubMain.pop.ClubLevelUpPanel;
	import sszt.club.components.clubMain.pop.MasterFunctionPanel;
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
	import sszt.club.datas.ClubInfo;
	import sszt.club.datas.list.ClubListItemInfo;
	import sszt.club.datas.war.ClubWarItemInfo;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.socketHandlers.ClubClearTryinSocketHandler;
	import sszt.club.socketHandlers.ClubDetailSocketHandler;
	import sszt.club.socketHandlers.ClubDutyChangeSocketHandler;
	import sszt.club.socketHandlers.ClubGetPaySocketHandler;
	import sszt.club.socketHandlers.ClubGetWealSocketHandler;
	import sszt.club.socketHandlers.ClubKickOutSocketHandler;
	import sszt.club.socketHandlers.ClubMonsterUpdateSocketHandler;
	import sszt.club.socketHandlers.ClubMonsterUpgradeSocketHandler;
	import sszt.club.socketHandlers.ClubQueryListSocketHandler;
	import sszt.club.socketHandlers.ClubQueryMemberSocketHandler;
	import sszt.club.socketHandlers.ClubQueryTryinSocketHandler;
	import sszt.club.socketHandlers.ClubTaskUsableSocketHandler;
	import sszt.club.socketHandlers.ClubTryInResponseSocketHandler;
	import sszt.club.socketHandlers.ClubWarDealQueryListSockethandler;
	import sszt.club.socketHandlers.ClubWarDeclearQueryListSockethandler;
	import sszt.club.socketHandlers.ClubWarEnemyQueryListSockethandler;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToClubData;
	import sszt.core.socketHandlers.club.ClubMemberListSocketHandler;
	import sszt.core.socketHandlers.club.ClubTransferSocketHandler;
	import sszt.core.socketHandlers.task.TaskAcceptSocketHandler;
	import sszt.core.socketHandlers.task.TaskSubmitSocketHandler;
	
	public class ClubMediator extends Mediator
	{
		public static const NAME:String = "clubMediator";
		
		public function ClubMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ClubMediatorEvent.SHOW_CLUBMAIN,
				ClubMediatorEvent.SHOW_CLUBLIST,
				ClubMediatorEvent.SHOW_CLUBSHOP,
				ClubMediatorEvent.SHOW_CLUBPANEL,
//				ClubMediatorEvent.CLUB_KICK,
				ClubMediatorEvent.CLUB_TRANSFER,
				ClubMediatorEvent.SHOW_CLUBSTORE,
				ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE
			];
		}
		
//		override public function handleNotification(notification:INotification):void
//		{
//			switch(notification.getName())
//			{
//				case ClubMediatorEvent.SHOW_CLUBMAIN:
//					showMainPanel(int(notification.getBody()));
//					break;
//				case ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE:
//					dispose();
//					break;
//			}
//		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ClubMediatorEvent.SHOW_CLUBMAIN:
					var data:ToClubData = notification.getBody() as ToClubData;
					showMainPanel(data.clubId,data.index);
					break;
				case ClubMediatorEvent.SHOW_CLUBLIST:
					data = notification.getBody() as ToClubData;
					showMainPanel(data.clubId,data.index);
					break;
				case ClubMediatorEvent.SHOW_CLUBSHOP:
					showShopPanel();
					break;
				case ClubMediatorEvent.SHOW_CLUBPANEL:
					var data1:ToClubData = notification.getBody() as ToClubData;
					showChoosePanel(data1);
					break;
//				case ClubMediatorEvent.CLUB_KICK:
//					kick(notification.getBody() as Number);
//					break;
				case ClubMediatorEvent.CLUB_TRANSFER:
					transfer(notification.getBody() as Number);
					break;
				case ClubMediatorEvent.SHOW_CLUBSTORE:
					showStorePanel();
					break;
				case ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function kick(id:Number):void
		{
			ClubKickOutSocketHandler.send(id);
		}
		
		public function transfer(id:Number):void
		{
			ClubTransferSocketHandler.send(id);
		}
		public function clubDutyChange(id:Number,duty:int):void
		{
			ClubDutyChangeSocketHandler.send(id,duty);
		}
		
		private function showMainPanel(clubId:Number,argIndex:int):void
		{
			clubModule.clubId = clubId;
//			if(clubModule.clubMainPanel == null)
//			{				
//				clubModule.clubMainPanel = new ClubMainPanel(this,clubId,argIndex);
//				clubModule.clubMainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(clubModule.clubMainPanel);
//			}
//			else
//			{
//				clubModule.clubMainPanel.clubId = clubModule.clubId;
//				clubModule.clubMainPanel.setIndexFromOut(argIndex);
//				clubModule.clubMainPanel.setBtns();
//				getDetailInfo();	
//			}
			
			if(clubModule.newClubMainPanel == null)
			{				
				clubModule.newClubMainPanel = new ClubMainPanel(this, clubId, argIndex);
				clubModule.newClubMainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.newClubMainPanel);
			}
			else
			{
				clubModule.newClubMainPanel.clubId = clubModule.clubId;
				clubModule.newClubMainPanel.setIndexFromOut(argIndex);
				clubModule.newClubMainPanel.setBtns();
				clubModule.newClubMainPanel.setIndex(1);
//				getDetailInfo();	
			}
		}
		
		private function mainPanelCloseHandler(evt:Event):void
		{
//			if(clubModule.clubMainPanel)
//			{
//				clubModule.clubMainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
//				clubModule.clubMainPanel = null;
//			}
			
			if(clubModule.newClubMainPanel)
			{
				clubModule.newClubMainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
				clubModule.newClubMainPanel = null;
			}
		}
		
		public function getDetailInfo():void
		{
			ClubDetailSocketHandler.send(clubModule.clubId);
		}
		
		public function getWorkInfo():void
		{
			ClubTaskUsableSocketHandler.send();
		}
		
		public function acceptClubTask(id:int):void
		{
			TaskAcceptSocketHandler.sendAccept(id);
		}
		
		public function getWeal():void
		{
			ClubGetWealSocketHandler.send();
		}
		public function getPay():void
		{
			ClubGetPaySocketHandler.send();
		}
		public function getMemberData(clubId:Number):void
		{
			ClubQueryMemberSocketHandler.send(clubId);
		}
		public function getTryinData(page:int,pageCount:int):void
		{
			ClubQueryTryinSocketHandler.send(page,pageCount);
		}
		public function clearTryinList():void
		{
			ClubClearTryinSocketHandler.send();
		}
		public function acceptTryin(id:Number,page:int,pageSize:int):void
		{
			ClubTryInResponseSocketHandler.send(id,true,page,pageSize);
		}
		public function refuseTryIn(id:Number,page:int,pageSize:int):void
		{
			ClubTryInResponseSocketHandler.send(id,false,page,pageSize);
		}
				
		public function showStorePanel():void
		{
			if(clubModule.clubStorePanel == null)
			{
				clubModule.clubStorePanel = new ClubStorePanel(this);
				if(clubModule.assetsReady)
				{
					clubModule.clubStorePanel.assetsCompleteHandler();
				}
				clubModule.clubStorePanel.addEventListener(Event.CLOSE,storePanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.clubStorePanel);
			}
			else
			{
				clubModule.clubStorePanel.setToTop();
			}
		}
		private function storePanelCloseHandler(e:Event):void
		{
			if(clubModule.clubStorePanel)
			{
				clubModule.clubStorePanel.removeEventListener(Event.CLOSE,storePanelCloseHandler);
				clubModule.clubStorePanel = null;
			}
		}
		
		public function showChoosePanel(toData:ToClubData):void
		{
			if(GlobalData.selfPlayer.clubId == 0)
			{
				facade.sendNotification(ClubMediatorEvent.SHOW_CLUBLIST);
			}
			else
			{
				showMainPanel(toData.clubId,toData.index);
			}
		}
		
		
		public function showShopPanel():void
		{
			if(clubModule.shopPanel == null)
			{
				clubModule.shopPanel = new ShopPanel(this);
				clubModule.shopPanel.addEventListener(Event.CLOSE,shopCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.shopPanel);
				
				if(clubModule.assetsReady)
				{
					clubModule.shopPanel.assetsCompleteHandler();
				}
			}
			else
			{
				clubModule.shopPanel.removeEventListener(Event.CLOSE,shopCloseHandler);
				clubModule.shopPanel.dispose();
				clubModule.shopPanel = null;
			}
		}
		private function shopCloseHandler(evt:Event):void
		{
			if(clubModule.shopPanel)
			{
				clubModule.shopPanel.removeEventListener(Event.CLOSE,shopCloseHandler);
				clubModule.shopPanel = null;
			}
		}
		
		public function showInvitePanel():void
		{
			if(clubModule.invitePanel == null)
			{
				clubModule.invitePanel = new InvitePanel(this);
				clubModule.invitePanel.addEventListener(Event.CLOSE,inviteCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.invitePanel);
			}
			else
			{
				clubModule.invitePanel.setToTop();
			}
		}
		private function inviteCloseHandler(evt:Event):void
		{
			if(clubModule.invitePanel)
			{
				clubModule.invitePanel.removeEventListener(Event.CLOSE,inviteCloseHandler);
				clubModule.invitePanel = null;
			}
		}
		
		public function showDismissPanel():void
		{
			if(clubModule.dismissPanel == null)
			{
				clubModule.dismissPanel = new ClubDismissPanel(this);
				clubModule.dismissPanel.addEventListener(Event.CLOSE,dismissCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.dismissPanel);
			}
			else
			{
				clubModule.dismissPanel.setToTop();
			}
		}
		private function dismissCloseHandler(e:Event):void
		{
			if(clubModule.dismissPanel)
			{
				clubModule.dismissPanel.removeEventListener(Event.CLOSE,dismissCloseHandler);
				clubModule.dismissPanel = null;
			}
		}
		
		public function showExitPanel():void
		{
			if(clubModule.exitPanel == null)
			{
				clubModule.exitPanel = new ClubExitPanel(this);
				clubModule.exitPanel.addEventListener(Event.CLOSE,exitCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.exitPanel);
			}
			else
			{
				clubModule.exitPanel.setToTop();
			}
		}
		private function exitCloseHandler(e:Event):void
		{
			if(clubModule.exitPanel)
			{
				clubModule.exitPanel.removeEventListener(Event.CLOSE,exitCloseHandler);
				clubModule.exitPanel = null;
			}
		}
		
		public function showInfoCheckPanel(info:ClubListItemInfo,rank:int):void
		{
			if(clubModule.infoCheckPanel == null)
			{
				clubModule.infoCheckPanel = new ClubInfoCheckPanel(info,rank);
				clubModule.infoCheckPanel.addEventListener(Event.CLOSE,infoCheckPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.infoCheckPanel);
			}
		}
		
		private function infoCheckPanelCloseHandler(e:Event):void
		{
			if(clubModule.infoCheckPanel)
			{
				clubModule.infoCheckPanel.removeEventListener(Event.CLOSE,infoCheckPanelCloseHandler);
				clubModule.infoCheckPanel = null;
			}
		}
		
		public function showApplyPanel():void
		{
			if(clubModule.applyPanel == null)
			{
				clubModule.applyPanel = new ClubApplyPanel(this);
				clubModule.applyPanel.addEventListener(Event.CLOSE,applyPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.applyPanel);
			}
		}
		
		private function applyPanelCloseHandler(e:Event):void
		{
			if(clubModule.applyPanel)
			{
				clubModule.applyPanel.removeEventListener(Event.CLOSE,applyPanelCloseHandler);
				clubModule.applyPanel = null;
			}
		}
		
		
//		public function showWarPanel():void
//		{
//			if(clubModule.warPanel == null)
//			{
//				clubModule.warPanel = new WarPanel(this);
//				clubModule.warPanel.addEventListener(Event.CLOSE,warPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(clubModule.warPanel);
//			}
//		}
//		
//		private function warPanelCloseHandler(e:Event):void
//		{
//			if(clubModule.warPanel)
//			{
//				clubModule.warPanel.removeEventListener(Event.CLOSE,warPanelCloseHandler);
//				clubModule.warPanel = null;
//			}
//		}
		public function showLotteryPanel():void
		{
			if(clubModule.clubLotteryPanel == null)
			{
				clubModule.clubLotteryPanel = new ClubLotteryPanel(this);
				if(clubModule.assetsReady)
				{
					clubModule.clubLotteryPanel.assetsCompleteHandler();
				}
				clubModule.clubLotteryPanel.addEventListener(Event.CLOSE,lotteryPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.clubLotteryPanel);
			}else
			{
				clubModule.clubLotteryPanel.dispose();
				lotteryPanelCloseHandler(null);
			}
		}
		private function lotteryPanelCloseHandler(evt:Event):void
		{
			if(clubModule.clubLotteryPanel)
			{
				clubModule.clubLotteryPanel.removeEventListener(Event.CLOSE,lotteryPanelCloseHandler);
				clubModule.clubLotteryPanel = null;
			}
		}
		
		public function showTeamMailPanel():void
		{
			if(clubModule.teamMailPanel == null)
			{
				clubModule.teamMailPanel = new TeamMailPanel(this);
				if(clubModule.assetsReady)
				{
					clubModule.teamMailPanel.assetsCompleteHandler();
				}
				clubModule.teamMailPanel.addEventListener(Event.CLOSE,teamMailPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.teamMailPanel);
			}
		}
		
		private function teamMailPanelCloseHandler(evt:Event):void
		{
			if(clubModule.teamMailPanel)
			{
				clubModule.teamMailPanel.removeEventListener(Event.CLOSE,teamMailPanelCloseHandler);
				clubModule.teamMailPanel = null;
			}
		}
		
		public function showDeviceMangePanel():void
		{
			if(clubModule.deviceManagePanel == null)
			{
				clubModule.deviceManagePanel = new ClubDeviceManagePanel(this);
				clubModule.deviceManagePanel.addEventListener(Event.CLOSE,devicePanelCLoseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.deviceManagePanel);
			}
		}
		
		private function devicePanelCLoseHandler(evt:Event):void
		{
			if(clubModule.deviceManagePanel)
			{
				clubModule.deviceManagePanel.removeEventListener(Event.CLOSE,devicePanelCLoseHandler);
				clubModule.deviceManagePanel = null;
			}
		}
		
		public function showNewContributePanel():void
		{
			if(clubModule.newContributePanel == null)
			{
				clubModule.newContributePanel = new ClubContributePanel(this);
				clubModule.newContributePanel.addEventListener(Event.CLOSE,newContributePanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.newContributePanel);
			}
			else
			{
				clubModule.newContributePanel.setToTop();
			}
		}
		private function newContributePanelCloseHandler(e:Event):void
		{
			if(clubModule.newContributePanel)
			{
				clubModule.newContributePanel.removeEventListener(Event.CLOSE,newContributePanelCloseHandler);
				clubModule.newContributePanel = null;
			}
		}
		
		public function showMasterFunction(pos:Point):void
		{
			if(clubModule.masterFunctionPanel == null)
			{
				clubModule.masterFunctionPanel = new MasterFunctionPanel(this,pos);
				clubModule.masterFunctionPanel.addEventListener(Event.CLOSE,masterPanelCloseHandler);
				GlobalAPI.layerManager.getTipLayer().addChild(clubModule.masterFunctionPanel);
			}
		}
		
		private function masterPanelCloseHandler(evt:Event):void
		{
			if(clubModule.masterFunctionPanel)
			{
				clubModule.masterFunctionPanel.removeEventListener(Event.CLOSE,masterPanelCloseHandler);
				clubModule.masterFunctionPanel = null;
			}
		}
		
		public function showNewLevelUpPanel():void
		{
			if(clubModule.newLevelUpPanel == null)
			{
				clubModule.newLevelUpPanel = new ClubLevelUpPanel(this);
				clubModule.newLevelUpPanel.addEventListener(Event.CLOSE,newLevelUpPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.newLevelUpPanel);
			}
		}
		
		private function newLevelUpPanelCloseHandler(evt:Event):void
		{
			if(clubModule.newLevelUpPanel)
			{
				clubModule.newLevelUpPanel.removeEventListener(Event.CLOSE,newLevelUpPanelCloseHandler);
				clubModule.newLevelUpPanel = null;
			}
		}
		
		public function showStoreAppliedItemRecordsPanel():void
		{
			if(clubModule.storeAppliedItemRecordsPanel == null)
			{
				clubModule.storeAppliedItemRecordsPanel = new ClubStoreAppliedItemRecordsPanel(this);
				clubModule.storeAppliedItemRecordsPanel.addEventListener(Event.CLOSE, storeAppliedItemRecordsPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.storeAppliedItemRecordsPanel);
			}
			else
			{
				clubModule.storeAppliedItemRecordsPanel.setToTop();
			}
		}
		
		private function storeAppliedItemRecordsPanelCloseHandler(evt:Event):void
		{
			if(clubModule.storeAppliedItemRecordsPanel)
			{
				clubModule.storeAppliedItemRecordsPanel.removeEventListener(Event.CLOSE,storeAppliedItemRecordsPanelCloseHandler);
				clubModule.storeAppliedItemRecordsPanel = null;
			}
		}
		
		public function showStoreExamineAndVerifyPanel():void
		{
			if(clubModule.storeExamineAndVerifyPanel == null)
			{
				clubModule.storeExamineAndVerifyPanel = new ClubStoreExamineAndVerifyPanel(this);
				clubModule.storeExamineAndVerifyPanel.addEventListener(Event.CLOSE, storeExamineAndVerifyPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.storeExamineAndVerifyPanel);
			}
			else
			{
				clubModule.storeExamineAndVerifyPanel.setToTop();
			}
		}
		
		private function storeExamineAndVerifyPanelCloseHandler(evt:Event):void
		{
			if(clubModule.storeExamineAndVerifyPanel)
			{
				clubModule.storeExamineAndVerifyPanel.removeEventListener(Event.CLOSE,storeExamineAndVerifyPanelCloseHandler);
				clubModule.storeExamineAndVerifyPanel = null;
			}
		}
		
		public function showStoreRecordsPanel():void
		{
			if(clubModule.storeRecords == null)
			{
				clubModule.storeRecords = new ClubStoreRecordsPanel(this);
				clubModule.storeRecords.addEventListener(Event.CLOSE, storeRecordsPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.storeRecords);
			}
			else
			{
				clubModule.storeRecords.setToTop();
			}
		}
		
		private function storeRecordsPanelCloseHandler(evt:Event):void
		{
			if(clubModule.storeRecords)
			{
				clubModule.storeRecords.removeEventListener(Event.CLOSE,storeRecordsPanelCloseHandler);
				clubModule.storeRecords = null;
			}
		}
		
		public function sendMonsterInfo():void
		{
			ClubMonsterUpdateSocketHandler.send();
		}
		
		public function sendMonsterUpgrade():void
		{
			ClubMonsterUpgradeSocketHandler.send();
		}
		
		public function get clubModule():ClubModule
		{
			return viewComponent as ClubModule;
		}
		public function get clubInfo():ClubInfo
		{
			return clubModule.clubInfo;
		}
		
		public function getMemberInfo():void
		{
			ClubMemberListSocketHandler.send();
		}
		
		
		
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}