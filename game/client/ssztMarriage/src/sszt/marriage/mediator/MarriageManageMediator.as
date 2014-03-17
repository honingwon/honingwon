package sszt.marriage.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.constData.MarryRelationType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.marriage.MarriageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.marriage.MarriageModule;
	import sszt.marriage.componet.MarriageManagePanel;
	import sszt.marriage.componet.item.MarriageRelationItemView;
	import sszt.marriage.data.MarriageRelationItemInfo;
	import sszt.marriage.event.MarriageMediatorEvent;
	import sszt.marriage.event.MarriageRelationEvent;
	import sszt.marriage.socketHandlers.DivorceSocketHandler;
	import sszt.marriage.socketHandlers.MarriageRelationChangeSocketHandler;
	import sszt.marriage.socketHandlers.MarriageRelationListSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class MarriageManageMediator extends Mediator
	{
		public static const NAME:String = "marriageManageMediator";
		
		public function MarriageManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				MarriageMediatorEvent.SHOW_MARRIAGE_MANAGE_PANEL,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch(notification.getName())
			{
				case MarriageMediatorEvent.SHOW_MARRIAGE_MANAGE_PANEL:
					showMarriageManagePanel();
					break;
			}
		}
		
		private function showMarriageManagePanel():void
		{
			if(!marriageModule.marriageUIStateList.marriageManagePanel)
			{
				marriageModule.marriageUIStateList.marriageManagePanel = new MarriageManagePanel();
				GlobalAPI.layerManager.addPanel(marriageModule.marriageUIStateList.marriageManagePanel);
				marriageModule.marriageUIStateList.marriageManagePanel.addEventListener(Event.CLOSE, marriageManagePanelCloseHandler);
				marriageModule.marriageRelationList.addEventListener(MarriageRelationEvent.UPDATE,marriageRelationListUpdateHandler);
				MarriageRelationListSocketHandler.send();
				if(marriageModule.assetReady) marriageModule.marriageUIStateList.marriageManagePanel.assetsCompleteHandler();
			}
		}
		
		protected function marriageManagePanelCloseHandler(event:Event):void
		{
			marriageModule.marriageUIStateList.marriageManagePanel.removeEventListener(Event.CLOSE, marriageManagePanelCloseHandler);
			marriageModule.marriageRelationList.removeEventListener(MarriageRelationEvent.UPDATE,marriageRelationListUpdateHandler);
			marriageModule.marriageUIStateList.marriageManagePanel = null;
		}
		
		protected function marriageRelationListUpdateHandler(event:Event):void
		{
			var p:MarriageManagePanel  = marriageModule.marriageUIStateList.marriageManagePanel;
			p.updateView(marriageModule.marriageRelationList.list);
			
			var marryRelationSelf:MarriageRelationItemInfo = marriageModule.marriageRelationList.getRelationById(GlobalData.selfPlayer.userId);
			var marryRelationViewSelf:MarriageRelationItemView = p.viewList[GlobalData.selfPlayer.userId];
			if(!marryRelationSelf || !marryRelationViewSelf)return;
			marryRelationViewSelf.highlight = true;
			
			var itemView:MarriageRelationItemView;
			for each(itemView in p.viewList)
			{
				if(itemView != marryRelationViewSelf)
				{
					itemView.updateBtnState(marryRelationSelf.type,divorceHandler,upgradeHandler);
				}
			}
		}
		
//		protected function divorceSuccessHandler(event:Event):void
//		{
//			var p:MarriageManagePanel  = marriageModule.marriageUIStateList.marriageManagePanel;
//			p.updateView(marriageModule.marriageRelationList.list);
//		}
//		
//		protected function marriageRelationChangeHandler(event:Event):void
//		{
//			var p:MarriageManagePanel  = marriageModule.marriageUIStateList.marriageManagePanel;
//			p.updateView(marriageModule.marriageRelationList.list);
//		}
		
		private function divorceHandler(userId:Number):void
		{
			var message:String = LanguageManager.getWord('ssztl.marriage.divorce',100);
			MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,confirmHandler);
			function confirmHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					DivorceSocketHandler.send(userId);
				}
			}
		}
		
		private function upgradeHandler(userId:Number):void
		{
			MarriageRelationChangeSocketHandler.send(userId);
		}
		
		public function get marriageInfo():MarriageInfo
		{
			return marriageModule.marriageInfo;
		}
		
		public function get marriageModule():MarriageModule
		{
			return viewComponent as MarriageModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}