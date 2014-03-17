package sszt.store
{
	import mx.graphics.Stroke;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.itemDiscount.CheapInfo;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.store.component.AuctionPanel;
	import sszt.store.component.PayPanel;
	import sszt.store.component.RefreshableStore;
	import sszt.store.component.StorePanel;
	import sszt.store.datas.AuctionInfo;
	import sszt.store.event.StoreMediatorEvent;
	import sszt.store.socket.StoreSetSocketHandler;

	public class StoreModule extends BaseModule
	{
		public var storePanel:StorePanel;
		public var facade:StoreFacade;
		public var cheapInfo:CheapInfo;
		public var auctionInfo:AuctionInfo;
		public var auctionPanel:AuctionPanel;
		public var payPanel:PayPanel;
		public var refreshableStore:RefreshableStore;
			
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			cheapInfo = new CheapInfo();
			auctionInfo = new AuctionInfo();
			StoreSetSocketHandler.add(this);
			facade = StoreFacade.getInstance(String(moduleId));
			facade.startup(this,data);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			var toStoreData:ToStoreData = data as ToStoreData;
			
			if(storePanel && data.type == 1)
			{
				storePanel.dispose();
				storePanel = null;
			}
			else if(payPanel && data.type == 2)
			{
				payPanel.dispose();
				payPanel = null;
			}
			else if(refreshableStore && data.type == 3)
			{
				refreshableStore.dispose();
				refreshableStore = null;
			}
			else
			{
				facade.sendNotification(StoreMediatorEvent.STORE_START,data);
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.STORE;
		}
		
		
		override public function assetsCompleteHandler():void
		{
			if(storePanel)
			{
				storePanel.assetsCompleteHandler();
			}
		}
		
		override public function dispose():void
		{
			StoreSetSocketHandler.remove();
			if(storePanel)
			{
				storePanel.dispose();
				storePanel = null;
			}
			if(auctionPanel)
			{
				auctionPanel.dispose();
				auctionPanel = null;
			}
			if(payPanel)
			{
				payPanel.dispose();
				payPanel = null;
			}
			
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			super.dispose();
			if(cheapInfo)
			{
				cheapInfo = null;
			}
			if(auctionInfo)
			{
				auctionInfo = null;
			}
		}
	}
}