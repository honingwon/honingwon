package sszt.duplicateStore.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class StoreSetSocketHandler extends BaseSocketHandler
	{
		public function StoreSetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(handlerData:Object=null):void
		{			
			GlobalAPI.socketManager.addSocketHandler(new GetDuplicateShopSaleNumSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new DuplicateShopBuySockethandler(handlerData));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.DUPLICATE_SHOP_SALE_NUM);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.DUPLICATE_SHOP_BUY);
		}
	}
}