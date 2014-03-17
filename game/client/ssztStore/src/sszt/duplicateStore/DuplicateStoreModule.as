package sszt.duplicateStore
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.module.BaseModule;
	import sszt.duplicateStore.component.StorePanel;
//	import sszt.duplicateStore.datas.AuctionInfo;
	import sszt.duplicateStore.datas.CheapInfo;
//	import sszt.duplicateStore.socket.ItemDiscountSocketHandler;
	import sszt.duplicateStore.socket.StoreSetSocketHandler;
	import sszt.interfaces.module.IModule;

	public class DuplicateStoreModule extends BaseModule
	{
		public var storePanel:StorePanel;
		public var facade:StoreFacade;
		public var cheapInfo:CheapInfo;
//		public var auctionInfo:AuctionInfo;
//		public var auctionPanel:AuctionPanel
			
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			cheapInfo = new CheapInfo();
//			auctionInfo = new AuctionInfo();
			StoreSetSocketHandler.add(this);
			facade = StoreFacade.getInstance(String(moduleId));        
			facade.startup(this,data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			if(storePanel)
			{
				storePanel.dispose();
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.DUPLICATESTORE;
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
//			if(auctionPanel)
//			{
//				auctionPanel.dispose();
//				auctionPanel = null;
//			}
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
		}
	}
}