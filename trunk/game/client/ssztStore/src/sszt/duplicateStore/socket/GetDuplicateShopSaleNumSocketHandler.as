package sszt.duplicateStore.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.duplicateStore.DuplicateStoreModule;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GetDuplicateShopSaleNumSocketHandler extends BaseSocketHandler
	{
		public function GetDuplicateShopSaleNumSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.DUPLICATE_SHOP_SALE_NUM;
		}
		
		override public function handlePackage():void
		{
			module.storePanel.updateSaleNum(_data);
			handComplete();
		}
		
		public function get module():DuplicateStoreModule
		{
			return _handlerData as DuplicateStoreModule;
		}
		
		public static function sendDiscount(ShopId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.DUPLICATE_SHOP_SALE_NUM);
			pkg.writeInt(0);//npc id 目前未使用
			pkg.writeInt(ShopId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}