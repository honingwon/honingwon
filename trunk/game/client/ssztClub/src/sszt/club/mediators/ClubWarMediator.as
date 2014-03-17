package sszt.club.mediators
{
	import flash.events.Event;
	
	import sszt.club.ClubModule;
	import sszt.club.components.clubMain.pop.manage.war.WarPanel;
	import sszt.club.datas.ClubInfo;
	import sszt.club.datas.war.ClubWarItemInfo;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.socketHandlers.ClubWarDealQueryListSockethandler;
	import sszt.club.socketHandlers.ClubWarDeclearQueryListSockethandler;
	import sszt.club.socketHandlers.ClubWarEnemyQueryListSockethandler;
	import sszt.core.data.GlobalAPI;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ClubWarMediator extends Mediator
	{
		public static const NAME:String = "clubWarMediator"
		public function ClubWarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
							ClubMediatorEvent.SHOW_CLUB_WAR_PANEL,
							ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE
						];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ClubMediatorEvent.SHOW_CLUB_WAR_PANEL:
					showWarPanel(notification.getBody() as int);
					break;
				case ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function showWarPanel(argIndex:int):void
		{
			if(clubModule.warPanel == null)
			{
				clubModule.warPanel = new WarPanel(this,argIndex);
				clubModule.warPanel.addEventListener(Event.CLOSE,warPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.warPanel);
			}
			else
			{
				clubModule.warPanel.currentIndex = -1;
				clubModule.warPanel.setIndex(argIndex);
			}
		}
		
		private function warPanelCloseHandler(e:Event):void
		{
			if(clubModule.warPanel)
			{
				clubModule.warPanel.removeEventListener(Event.CLOSE,warPanelCloseHandler);
				clubModule.warPanel = null;
			}
		}
		
		
		public function getWarDeclearInfo(page:int,pageCount:int = 11,name:String = ""):void
		{
			ClubWarDeclearQueryListSockethandler.sendQuery(page,pageCount,name);
			
//			var tmpList:Array = [];
//			var tmpItemInfo:ClubWarItemInfo;
//			var total:int = 1;
//			var len:int = 8;
//			for(var i:int = 0;i < len;i++)
//			{
//				tmpItemInfo = new ClubWarItemInfo();
//				tmpItemInfo.clubListId = i;
//				tmpItemInfo.clubName ="草泥马帮会"
//				tmpItemInfo.masterName = "草泥马";
//				tmpItemInfo.level = 1;
//				tmpItemInfo.clubCurrentNum = 1;
//				tmpItemInfo.clubTotalNum = 10;
//				tmpItemInfo.warState = 0;
//				tmpList.push(tmpItemInfo);
//			}
//			if(clubModule.clubInfo.clubWarInfo)
//			{
//				clubModule.clubInfo.clubWarInfo.declearListTotalNum = total;
//				clubModule.clubInfo.clubWarInfo.setWarDeclearList(tmpList);
//			}
		}
		
		public function getWarDealInfo(page:int,pageCount:int = 11,name:String = ""):void
		{
			ClubWarDealQueryListSockethandler.sendQuery(page,pageCount,name);
//			var tmpList:Array = [];
//			var tmpItemInfo:ClubWarItemInfo;
//			var total:int = 1;
//			var len:int = 8;
//			for(var i:int = 0;i < len;i++)
//			{
//				tmpItemInfo = new ClubWarItemInfo();
//				tmpItemInfo.clubListId = i;
//				tmpItemInfo.clubName ="JB帮会"
//				tmpItemInfo.masterName = "JB";
//				tmpItemInfo.level = 1;
//				tmpItemInfo.clubCurrentNum = 1;
//				tmpItemInfo.clubTotalNum = 10;
//				tmpItemInfo.warState = 0;
//				tmpList.push(tmpItemInfo);
//			}
//			if(clubModule.clubInfo.clubWarInfo)
//			{
//				clubModule.clubInfo.clubWarInfo.dealListTotalNum = total;
//				clubModule.clubInfo.clubWarInfo.setWarDealList(tmpList);
//			}
		}
		
		public function getWarEnemyInfo(page:int,pageCount:int = 11,name:String = ""):void
		{
			ClubWarEnemyQueryListSockethandler.sendQuery(page,pageCount,name);
			
//			var tmpList:Array = [];
//			var tmpItemInfo:ClubWarItemInfo;
//			var total:int = 1;
//			var len:int = 8;
//			for(var i:int = 0;i < len;i++)
//			{
//				tmpItemInfo = new ClubWarItemInfo();
//				tmpItemInfo.clubListId = i;
//				tmpItemInfo.clubName ="爽YY帮会"
//				tmpItemInfo.masterName = "YY";
//				tmpItemInfo.level = 1;
//				tmpItemInfo.clubCurrentNum = 1;
//				tmpItemInfo.clubTotalNum = 10;
//				tmpItemInfo.warState = 0;
//				tmpList.push(tmpItemInfo);
//			}
//			if(clubModule.clubInfo.clubWarInfo)
//			{
//				clubModule.clubInfo.clubWarInfo.enemyListTotalNum = total;
//				clubModule.clubInfo.clubWarInfo.setWarEnemyList(tmpList);
//			}
		}
		
		private function get clubModule():ClubModule
		{
			return viewComponent as ClubModule;
		}
		
		public function get clubInfo():ClubInfo
		{
			return clubModule.clubInfo;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}