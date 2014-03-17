package sszt.club.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.club.ClubModule;
	import sszt.club.components.clubMain.pop.camp.ClubBossPanel;
	import sszt.club.components.clubMain.pop.camp.ClubCollectionPanel;
	import sszt.club.datas.camp.ClubCampInfo;
	import sszt.club.events.ClubCampInfoUpdateEvent;
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.socketHandlers.ClubCampCallRemainingTimesSockectHandler;
	import sszt.club.socketHandlers.ClubCampCallSocketHandler;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.club.camp.ClubBossTemplateInfo;
	import sszt.core.data.club.camp.ClubCampCallTemplateList;
	import sszt.core.data.club.camp.ClubCollectionTemplateInfo;
	import sszt.core.view.quickTips.QuickTips;
	
	public class ClubCampMediator extends Mediator
	{
		public static const NAME:String = "clubCampMediator";
		
		public function ClubCampMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ClubMediatorEvent.SHOW_CLUB_BOSS_PANEL,
				ClubMediatorEvent.SHOW_CLUB_COLLECTION_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ClubMediatorEvent.SHOW_CLUB_BOSS_PANEL :
					showClubBossPanel();
					break;
				case ClubMediatorEvent.SHOW_CLUB_COLLECTION_PANEL :
					showClubCollectionPanel();
					break;
			}
		}
		
		private function showClubBossPanel():void
		{
			if(!clubModule.clubBossPanel)
			{
				clubModule.clubBossPanel = new ClubBossPanel(callingBossHandler,ClubCampCallTemplateList.bossArr);
				clubModule.clubBossPanel.clubRich = clubModule.clubInfo.clubDetailInfo.clubRich;			
				if(clubModule.assetsReady)
				{
					clubModule.clubBossPanel.assetsCompleteHandler();
				}
				GlobalAPI.layerManager.addPanel(clubModule.clubBossPanel);
				clubModule.clubBossPanel.addEventListener(Event.CLOSE,closeClubBossPanelHandler);
				
				clubModule.clubCampInfo.addEventListener(ClubCampInfoUpdateEvent.CLUB_CALL_REMAINING_TIMES_UPDATE,callRemainingTimesUpdateHandler);
				clubModule.clubInfo.clubDetailInfo.addEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
				ClubCampCallRemainingTimesSockectHandler.send();
			}
		}
		
		private function closeClubBossPanelHandler(event:Event):void
		{
			clubModule.clubBossPanel.removeEventListener(Event.CLOSE,closeClubBossPanelHandler);
			clubModule.clubBossPanel = null;
			
			clubModule.clubCampInfo.removeEventListener(ClubCampInfoUpdateEvent.CALL_CLUB_BOSS_SUCCESSFULLY,callClubBossSuccessfullyHandler);
			if(!clubModule.clubCollectionPanel)
			{
				clubModule.clubCampInfo.removeEventListener(ClubCampInfoUpdateEvent.CLUB_CALL_REMAINING_TIMES_UPDATE,callRemainingTimesUpdateHandler);
				clubModule.clubInfo.clubDetailInfo.removeEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
			}
		}
		
		private function callingBossHandler(bossInfo:ClubBossTemplateInfo):void
		{
			clubModule.clubCampInfo.addEventListener(ClubCampInfoUpdateEvent.CALL_CLUB_BOSS_SUCCESSFULLY,callClubBossSuccessfullyHandler);
			ClubCampCallSocketHandler.send(bossInfo.bossId);
		}
		
		private function callClubBossSuccessfullyHandler(event:Event):void
		{
			clubModule.clubCampInfo.removeEventListener(ClubCampInfoUpdateEvent.CALL_CLUB_BOSS_SUCCESSFULLY,callClubBossSuccessfullyHandler);
			var bossId:int = clubModule.clubCampInfo.lastCalledClubBossId;
			QuickTips.show('call boss successfully');
		}
				
		
		
		private function showClubCollectionPanel():void
		{
			if(!clubModule.clubCollectionPanel)
			{
				clubModule.clubCollectionPanel = new ClubCollectionPanel(startCollectingHandler,ClubCampCallTemplateList.collectionArr);
				clubModule.clubCollectionPanel.clubRich = clubModule.clubInfo.clubDetailInfo.clubRich;
				if(clubModule.assetsReady)
				{
					clubModule.clubCollectionPanel.assetsCompleteHandler();
				}
				GlobalAPI.layerManager.addPanel(clubModule.clubCollectionPanel);
				clubModule.clubCollectionPanel.addEventListener(Event.CLOSE,closeClubCollectionPanelHandler);
				
				clubModule.clubCampInfo.addEventListener(ClubCampInfoUpdateEvent.CLUB_CALL_REMAINING_TIMES_UPDATE,callRemainingTimesUpdateHandler);
				clubModule.clubInfo.clubDetailInfo.addEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
				ClubCampCallRemainingTimesSockectHandler.send();
			}
		}
		
		private function closeClubCollectionPanelHandler(event:Event):void
		{
			clubModule.clubCollectionPanel.removeEventListener(Event.CLOSE,closeClubCollectionPanelHandler);
			clubModule.clubCollectionPanel = null;
			
			clubModule.clubCampInfo.removeEventListener(ClubCampInfoUpdateEvent.CALL_CLUB_COLLECTION_SUCCESSFULLY,callClubCollectionSuccessfullyHandler);
			if(!clubModule.clubBossPanel)
			{
				clubModule.clubCampInfo.removeEventListener(ClubCampInfoUpdateEvent.CLUB_CALL_REMAINING_TIMES_UPDATE,callRemainingTimesUpdateHandler);
				clubModule.clubInfo.clubDetailInfo.removeEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
			}
		}
		
		
		private function startCollectingHandler(collectionInfo:ClubCollectionTemplateInfo):void
		{
			clubModule.clubCampInfo.addEventListener(ClubCampInfoUpdateEvent.CALL_CLUB_COLLECTION_SUCCESSFULLY,callClubCollectionSuccessfullyHandler);
			ClubCampCallSocketHandler.send(collectionInfo.collectionId);
		}
		
		private function callClubCollectionSuccessfullyHandler(event:Event):void
		{
			clubModule.clubCampInfo.removeEventListener(ClubCampInfoUpdateEvent.CALL_CLUB_COLLECTION_SUCCESSFULLY,callClubCollectionSuccessfullyHandler);
			var collectionId:int = clubModule.clubCampInfo.lastCalledClubCollectionId;
			QuickTips.show('call collection successfully');
		}
		
		private function detailInfoUpdateHandler(event:Event):void
		{
			if(clubModule.clubBossPanel)
			{
				clubModule.clubBossPanel.clubRich = clubModule.clubInfo.clubDetailInfo.clubRich;
			}
			
			if(clubModule.clubCollectionPanel)
			{
				clubModule.clubCollectionPanel.clubRich = clubModule.clubInfo.clubDetailInfo.clubRich;
			}
		}
		
		private function callRemainingTimesUpdateHandler(event:Event):void
		{
			if(clubModule.clubBossPanel)
			{
				clubModule.clubBossPanel.remaingCallingTimes = clubModule.clubCampInfo.bossRemainingTimes + '/' + ClubCampInfo.BOSS_REMAINING_TIMES_MAX;
				
				if(clubModule.clubCampInfo.bossRemainingTimes == 0)
				{
					clubModule.clubBossPanel.disableAllButton();
				}
			}
			
			if(clubModule.clubCollectionPanel)
			{
				clubModule.clubCollectionPanel.remaingCallingTimes = clubModule.clubCampInfo.collectionRemainingTimes + '/' + ClubCampInfo.COLLECTION_REMAINING_TIMES_MAX;
				
				clubModule.clubCollectionPanel.lastCalledCollectionTime = clubModule.clubCampInfo.lastCalledCollectionTime;
					
					
				if(clubModule.clubCampInfo.collectionRemainingTimes == 0)
				{
					clubModule.clubCollectionPanel.disableAllButton();
				}
			}
		}
		
		public function get clubModule():ClubModule
		{
			return viewComponent as ClubModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}