package sszt.exStore
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.module.BaseModule;
	import sszt.exStore.component.ExStorePanel;
	import sszt.exStore.datas.CheapInfo;
	import sszt.exStore.socket.StoreSetSocketHandler;
	import sszt.interfaces.module.IModule;

	public class ExStoreModule extends BaseModule
	{
		public var storePanel:ExStorePanel;
		public var facade:ExStoreFacade;
		public var cheapInfo:CheapInfo;
		public var storeData:ToStoreData;
			
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			cheapInfo = new CheapInfo();
			storeData = data as ToStoreData;
			StoreSetSocketHandler.add(this);
			facade = ExStoreFacade.getInstance(String(moduleId));        
			facade.startup(this,data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			var tempStore:ToStoreData = data as ToStoreData
			if(tempStore.type == storeData.type)
			{
				dispose();
			}
			else
			{
				storePanel.setShopType(tempStore.type); 
				storePanel.setIndex(tempStore.tabIndex);
				storeData = tempStore;
			}
			
//			if(storePanel)
//			{
//				storePanel.dispose();
//			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.Exchange;
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
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			if(cheapInfo)
			{
				cheapInfo = null;
			}
			storeData = null;
			super.dispose();
		}
	}
}