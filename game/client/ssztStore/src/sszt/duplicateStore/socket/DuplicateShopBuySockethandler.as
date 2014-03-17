package sszt.duplicateStore.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.duplicateStore.DuplicateStoreModule;
	import sszt.interfaces.socket.IPackageOut;
	
	public class DuplicateShopBuySockethandler extends BaseSocketHandler
	{
		public function DuplicateShopBuySockethandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.DUPLICATE_SHOP_BUY;
		}
		
		override public function handlePackage():void
		{
			module.storePanel.updateBuyNum(_data);
			handComplete();
		}
		
		public function get module():DuplicateStoreModule
		{
			return _handlerData as DuplicateStoreModule;
		}
		
		public static function sendBuy(shopItemId:int,count:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.DUPLICATE_SHOP_BUY);
			pkg.writeInt(shopItemId);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}