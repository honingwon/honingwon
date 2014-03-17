package sszt.store.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.store.StoreModule;
	import sszt.store.component.AuctionPanel;
	import sszt.store.component.PayPanel;
	import sszt.store.component.RefreshableStore;
	import sszt.store.component.StorePanel;
	import sszt.store.datas.AuctionItem;
	import sszt.store.event.StoreMediatorEvent;
	import sszt.store.socket.MysteryShopAllDataSocketHandler;
	import sszt.store.socket.MysteryShopGetInfoSocketHandler;

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
			switch(data.type)
			{
				case 1:
					if(storeModule.storePanel == null)
					{
						storeModule.storePanel = new StorePanel(this,data);
						GlobalAPI.layerManager.addPanel(storeModule.storePanel);
						storeModule.storePanel.addEventListener(Event.CLOSE,storeCloseHandler);
					}
					break;
				case 2:
					if(storeModule.payPanel == null)
					{
						storeModule.payPanel = new PayPanel();
						GlobalAPI.layerManager.addPanel(storeModule.payPanel);
						storeModule.payPanel.addEventListener(Event.CLOSE,payCloseHandler);
					}
					break;
				case 3:
					if(storeModule.refreshableStore == null)
					{
						storeModule.refreshableStore = new RefreshableStore();
						GlobalAPI.layerManager.addPanel(storeModule.refreshableStore);
						storeModule.refreshableStore.addEventListener(Event.CLOSE,refreshableStoreCloseHandler);
						MysteryShopAllDataSocketHandler.send();
						MysteryShopGetInfoSocketHandler.send();
					}
					break;
				default:
					if(storeModule.storePanel == null)
					{
						storeModule.storePanel = new StorePanel(this,data);
						GlobalAPI.layerManager.addPanel(storeModule.storePanel);
						storeModule.storePanel.addEventListener(Event.CLOSE,storeCloseHandler);
					}
					break;
			}
				
		}
		
		private function storeCloseHandler(evt:Event):void
		{
			if(storeModule.storePanel)
			{
				storeModule.storePanel.removeEventListener(Event.CLOSE,storeCloseHandler);
				storeModule.storePanel = null;
//				storeModule.dispose();
			}
		}
		
		private function payCloseHandler(evt:Event):void
		{
			if(storeModule.payPanel)
			{
				storeModule.payPanel.removeEventListener(Event.CLOSE,payCloseHandler);
				storeModule.payPanel = null;
//				storeModule.dispose();
			}
		}
		
		private function refreshableStoreCloseHandler(evt:Event):void
		{
			if(storeModule.refreshableStore)
			{
				storeModule.refreshableStore.removeEventListener(Event.CLOSE,refreshableStoreCloseHandler);
				storeModule.refreshableStore = null;
			}
		}
		
		public function showAuctionPanel(item:AuctionItem):void
		{
			if(storeModule.auctionPanel)
			{
				storeModule.auctionPanel.removeEventListener(Event.CLOSE,auctionPanelCloseHandler);
				storeModule.auctionPanel.dispose();
				storeModule.auctionPanel = null;
			}
			if(storeModule.auctionPanel == null)
			{
				storeModule.auctionPanel = new AuctionPanel(this,item);
				storeModule.auctionPanel.addEventListener(Event.CLOSE,auctionPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(storeModule.auctionPanel);
			}
		}
		
		private function auctionPanelCloseHandler(evt:Event):void			
		{
			if(storeModule.auctionPanel)
			{
				storeModule.auctionPanel.removeEventListener(Event.CLOSE,auctionPanelCloseHandler);
				storeModule.auctionPanel = null;
			}
		}
		
		
		public function get storeModule():StoreModule
		{
			return viewComponent as StoreModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}