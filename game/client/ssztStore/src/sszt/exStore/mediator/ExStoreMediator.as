package sszt.exStore.mediator
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.exStore.ExStoreModule;
	import sszt.exStore.component.ExStorePanel;
	import sszt.exStore.event.StoreMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class ExStoreMediator extends Mediator
	{
		public static const NAME:String="ExStoreMediator";
		
		public function ExStoreMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [StoreMediatorEvent.STORE_START,
				StoreMediatorEvent.STORE_DISPOSE
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case StoreMediatorEvent.STORE_START:
					var obj:ToStoreData =notification.getBody() as ToStoreData;
					initStore(obj);
					break;
				case StoreMediatorEvent.STORE_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function initStore(data:ToStoreData):void
		{
			if(storeModule.storePanel == null)
			{
				storeModule.storePanel = new ExStorePanel(this,data);
				GlobalAPI.layerManager.addPanel(storeModule.storePanel);
				storeModule.storePanel.addEventListener(Event.CLOSE,storeCloseHandler);
			}
		}
		
		private function storeCloseHandler(evt:Event):void
		{
			if(storeModule.storePanel)
			{
				storeModule.storePanel.removeEventListener(Event.CLOSE,storeCloseHandler);
				storeModule.storePanel = null;
				storeModule.dispose();
			}
		}
		
//		public function showAuctionPanel(item:AuctionItem):void
//		{
//			if(storeModule.auctionPanel)
//			{
//				storeModule.auctionPanel.removeEventListener(Event.CLOSE,auctionPanelCloseHandler);
//				storeModule.auctionPanel.dispose();
//				storeModule.auctionPanel = null;
//			}
//			if(storeModule.auctionPanel == null)
//			{
//				storeModule.auctionPanel = new AuctionPanel(this,item);
//				storeModule.auctionPanel.addEventListener(Event.CLOSE,auctionPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(storeModule.auctionPanel);
//			}
//		}
		
//		private function auctionPanelCloseHandler(evt:Event):void			
//		{
//			if(storeModule.auctionPanel)
//			{
//				storeModule.auctionPanel.removeEventListener(Event.CLOSE,auctionPanelCloseHandler);
//				storeModule.auctionPanel = null;
//			}
//		}
		
		public function getAuctionData():void
		{
//			ShopAuctionListUpdateSocketHandler.send();
		}
		
		public function get storeModule():ExStoreModule
		{
			return viewComponent as ExStoreModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}