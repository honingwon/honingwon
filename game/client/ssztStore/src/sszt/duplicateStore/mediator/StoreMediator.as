package sszt.duplicateStore.mediator
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.duplicateStore.DuplicateStoreModule;
//	import sszt.duplicateStore.component.AuctionPanel;
	import sszt.duplicateStore.component.StorePanel;
//	import sszt.duplicateStore.datas.AuctionItem;
	import sszt.duplicateStore.event.StoreMediatorEvent;
//	import sszt.duplicateStore.socket.ShopAuctionListUpdateSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class StoreMediator extends Mediator
	{
		public static const NAME:String="storeMediator";
		
		public function StoreMediator(viewComponent:Object = null)
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
				storeModule.storePanel = new StorePanel(this,data);
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
		
		public function get storeModule():DuplicateStoreModule
		{
			return viewComponent as DuplicateStoreModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}