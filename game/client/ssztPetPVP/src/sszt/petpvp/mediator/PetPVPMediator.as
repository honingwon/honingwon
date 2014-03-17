package sszt.petpvp.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.petpvp.PetPVPLogItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.PetPVPModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.components.PetPVPBattlePanel;
	import sszt.petpvp.components.PetPVPFailurePanel;
	import sszt.petpvp.components.PetPVPMainPanel;
	import sszt.petpvp.components.PetPVPSuccessPanel;
	import sszt.petpvp.data.PetPVPChallengeResultInfo;
	import sszt.petpvp.data.PetPVPInfo;
	import sszt.petpvp.events.PetPVPInfoEvent;
	import sszt.petpvp.events.PetPVPMediatorEvent;
	import sszt.petpvp.events.PetPVPUIEvent;
	import sszt.petpvp.socketHandlers.PetPVPChallengeInfoUpdateSocketHandler;
	import sszt.petpvp.socketHandlers.PetPVPChallengeTimesUpdateSocketHandler;
	import sszt.petpvp.socketHandlers.PetPVPGetDailyRewardSocketHandler;
	import sszt.petpvp.socketHandlers.PetPVPInfoSocketHandler;
	import sszt.petpvp.socketHandlers.PetPVPStartChallengingSocketHandler;
	import sszt.petpvp.socketHandlers.PetPVPStartChallengingWithClearCDSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	
	public class PetPVPMediator extends Mediator
	{
		public static const NAME:String = "petPVPMediator";
		private var _TimesType:int;
		
		public function PetPVPMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				PetPVPMediatorEvent.PET_PVP_START,
				PetPVPMediatorEvent.PET_PVP_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case PetPVPMediatorEvent.PET_PVP_START:
					showMainPanel();
					break;
				case PetPVPMediatorEvent.PET_PVP_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function showMainPanel():void
		{
			if(module.mainPanel == null)
			{
				module.mainPanel=new PetPVPMainPanel(startChallenging,addTimesHandler,clearCDHandler,getDailyRewardHandler);
				GlobalAPI.layerManager.addPanel(module.mainPanel);
				
				module.mainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
				module.mainPanel.addEventListener(PetPVPUIEvent.PET_CELL_CHANGE,petCellChangeHandler);
				module.mainPanel.challengeListView.addEventListener(PetPVPUIEvent.CHALLENGE_PET_ITEM_VIEW_CHANGE,challengePetItemViewChangeHandler);
				
				info.addEventListener(PetPVPInfoEvent.ALL_UPDATE,allUpdateHandler);
				info.addEventListener(PetPVPInfoEvent.CHALLENGE_INFO_UPDATE,challengeInfoUpdateHandler);
				info.addEventListener(PetPVPInfoEvent.RESULT_UPDATE,challengeResultUpdateHandler);
				info.addEventListener(PetPVPInfoEvent.CHALLENGE_TIMES_UPDATE,challengeTimesUpdateHandler);
				
				info.addEventListener(PetPVPInfoEvent.MY_PETS_INFO_UPDATE,myPetsUpdateHandler);
				info.addEventListener(PetPVPInfoEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
				info.addEventListener(PetPVPInfoEvent.LOG_INFO_UPDATE,logInfoUpdateHandler);
				info.addEventListener(PetPVPInfoEvent.AWARD_STATE_UPDATE,awardStateUpdateHandler);
				
				ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.START_CHALLENGING,startChallengingFromLog);
					
				PetPVPInfoSocketHandler.send();
			}		
		}
		
		private function getDailyRewardHandler(e:Event):void
		{
			PetPVPGetDailyRewardSocketHandler.send();
		}
		
		protected function rankInfoUpdateHandler(event:Event):void
		{
			module.mainPanel.updateRankView(info.rankInfo);
		}
		
		protected function myPetsUpdateHandler(event:Event):void
		{
			//module.mainPanel.updateMyPetDetailView(info.getCurrMyPetItemInfo());
			module.mainPanel.updateMyPetCell(info.myPetsInfo);
		}
		
		private function startChallengingFromLog(e:PetPVPModuleEvent):void
		{
			var infoTemp:PetPVPLogItemInfo = e.data as PetPVPLogItemInfo;
			if(infoTemp.petId < 1)
				infoTemp.petId = info.currMyPetId;
			MAlert.show(LanguageManager.getWord("ssztl.petpvp.sureChallenging1",info.getMyPetItemInfoById(infoTemp.petId).nick),
				LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,sureFightBack);
			function sureFightBack(e:CloseEvent):void
			{
				if(e.detail == MAlert.YES)
				{
					PetPVPStartChallengingSocketHandler.send(infoTemp.petId,infoTemp.opponentPetId);
				}
			}
		}
		
		
		private function clearCDHandler(e:Event):void
		{
			_TimesType = 2;
			var message:String = LanguageManager.getWord("ssztl.petpvp.checkClearCD",10);
			MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,checkTimesHandler);
		}
		
		private function checkTimesHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{				
				PetPVPChallengeTimesUpdateSocketHandler.send(_TimesType);
			}
		}
		
		private function addTimesHandler(e:Event):void
		{
			_TimesType = 1;
			var message:String = LanguageManager.getWord("ssztl.petpvp.checkAddTimes",10);
			MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,checkTimesHandler);
		}
		
		protected function challengeTimesUpdateHandler(event:Event):void
		{
			var seconds:int = info.lastTime - GlobalData.systemDate.getSystemDate().getTime()/1000;
			if(seconds <0) seconds = 0;
			module.mainPanel.updateTimes(info.remainingTimes,info.totalTimes,seconds);
		}
		
		protected function challengeResultUpdateHandler(e:PetPVPInfoEvent):void
		{
			var result:PetPVPChallengeResultInfo = e.data as PetPVPChallengeResultInfo;
			var petPVPBattlePanel:PetPVPBattlePanel = new PetPVPBattlePanel(result);
			GlobalAPI.layerManager.addPanel(petPVPBattlePanel);
		}
		
		private function startChallenging(e:Event):void
		{
			if(info.currMyPetId > 0 && info.currOpponentPetId >0)
			{
				if(module.mainPanel.getCountDownTime()>0)
				{
					MAlert.show(LanguageManager.getWord("ssztl.petpvp.sureChallenging2",info.getCurrMyPetItemInfo().nick,info.getCurrOpponetPetItemInfo().nick),
						LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,sureChallenging2);
				}
				else
				{
					MAlert.show(LanguageManager.getWord("ssztl.petpvp.sureChallenging",info.getCurrMyPetItemInfo().nick,info.getCurrOpponetPetItemInfo().nick),
						LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,sureChallenging);
				}
			}
		}
		
		private function sureChallenging(e:CloseEvent):void
		{			
			if(e.detail == MAlert.YES)
			{
				PetPVPStartChallengingSocketHandler.send(info.currMyPetId,info.currOpponentPetId);
			}
			return;			
		}
		
		private function sureChallenging2(e:CloseEvent):void
		{			
			if(e.detail == MAlert.YES)
			{
				PetPVPStartChallengingWithClearCDSocketHandler.send(info.currMyPetId,info.currOpponentPetId);
			}
			return;			
		}
		
		protected function challengePetItemViewChangeHandler(e:PetPVPUIEvent):void
		{
			var id:Number = e.data as Number;
			info.currOpponentPetId = id;
			
			//module.mainPanel.updateOppnentPetDetailView(info.getCurrOpponetPetItemInfo());		
			if(info.currMyPetId > 0 && info.currOpponentPetId >0)
			{
				if(module.mainPanel.getCountDownTime()>0)
				{
					MAlert.show(LanguageManager.getWord("ssztl.petpvp.sureChallenging2",info.getCurrMyPetItemInfo().nick,info.getCurrOpponetPetItemInfo().nick),
						LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,sureChallenging2);
				}
				else
				{					
					MAlert.show(LanguageManager.getWord("ssztl.petpvp.sureChallenging",info.getCurrMyPetItemInfo().nick,info.getCurrOpponetPetItemInfo().nick),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,sureChallenging);
				}
//				PetPVPStartChallengingSocketHandler.send(info.currMyPetId,info.currOpponentPetId);
			}
						
			
		}
		
		protected function challengeInfoUpdateHandler(e:PetPVPInfoEvent):void
		{
			//包含我的宠物的信息，要对比当前选中宠物的id
			var petIdFromServer:Number = e.data as Number;
			if(petIdFromServer != info.currMyPetId) return;
			module.mainPanel.updateChallengeListView(info.challengeList);
//			module.mainPanel.challengeListView.switchToFirstPet();
		}
		
		protected function petCellChangeHandler(e:PetPVPUIEvent):void
		{
			var id:Number = e.data as Number;
			info.currMyPetId = id;
			PetPVPChallengeInfoUpdateSocketHandler.send(id);
			
//			if(info.isInit)
//			{
//				module.mainPanel.updateMyPetDetailView(info.getCurrMyPetItemInfo());
//			}
		}
		
		protected function logInfoUpdateHandler(event:Event):void
		{
			module.mainPanel.updateLogView(info.logInfo);
		}		
		
		protected function awardStateUpdateHandler(event:Event):void
		{
			module.mainPanel.updateAwardList(info.awardState,info.awardList);
		}
		
		protected function allUpdateHandler(event:Event):void
		{
			module.mainPanel.updateRankView(info.rankInfo);
			module.mainPanel.updateLogView(info.logInfo);
			//module.mainPanel.updateMyPetDetailView(info.getCurrMyPetItemInfo());
			module.mainPanel.updateMyPetCell(info.myPetsInfo);
			module.mainPanel.updateAwardList(info.awardState,info.awardList);
			var seconds:int = info.lastTime - GlobalData.systemDate.getSystemDate().getTime()/1000;
			if(seconds <0) seconds = 0;
			module.mainPanel.updateTimes(info.remainingTimes,info.totalTimes,seconds);			
			module.mainPanel.switchToFirstPet();
		}
		
		private function mainPanelCloseHandler(evt:Event):void
		{
			info.removeEventListener(PetPVPInfoEvent.ALL_UPDATE,allUpdateHandler);
			info.removeEventListener(PetPVPInfoEvent.CHALLENGE_INFO_UPDATE,challengeInfoUpdateHandler);
			info.removeEventListener(PetPVPInfoEvent.RESULT_UPDATE,challengeResultUpdateHandler);
			info.removeEventListener(PetPVPInfoEvent.CHALLENGE_TIMES_UPDATE,challengeTimesUpdateHandler);
			
			info.removeEventListener(PetPVPInfoEvent.MY_PETS_INFO_UPDATE,myPetsUpdateHandler);
			info.removeEventListener(PetPVPInfoEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
			info.removeEventListener(PetPVPInfoEvent.LOG_INFO_UPDATE,logInfoUpdateHandler);
			info.removeEventListener(PetPVPInfoEvent.AWARD_STATE_UPDATE,awardStateUpdateHandler);
			
			ModuleEventDispatcher.removePetPVPEventListener(PetPVPModuleEvent.START_CHALLENGING,startChallengingFromLog);
			
			module.mainPanel.removeEventListener(PetPVPUIEvent.PET_CELL_CHANGE,petCellChangeHandler);
			module.mainPanel.challengeListView.removeEventListener(PetPVPUIEvent.CHALLENGE_PET_ITEM_VIEW_CHANGE,challengePetItemViewChangeHandler);
			if(module.mainPanel)
			{
				module.mainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
				module.mainPanel = null;
				module.dispose();
			}
		}
		
		public function get info():PetPVPInfo
		{
			return module.petPVPInfo;
		}
		
		public function get module():PetPVPModule
		{
			return viewComponent as PetPVPModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}