package sszt.store.socket
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
			GlobalAPI.socketManager.addSocketHandler(new MysteryShopAllDataSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new MysteryShopGetInfoSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new MysteryShopRefSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new MysteryShopBuySocketHandler(handlerData));
			
//			GlobalAPI.socketManager.addSocketHandler(new ShopAuctionListUpdateSocketHandler(handlerData));
//			GlobalAPI.socketManager.addSocketHandler(new ShopAuctionSocketHandler(handlerData));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MYSTERY_SHOP_NEAR_MSG);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MYSTERY_SHOP_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MYSTERY_SHOP_REFRESH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MYSTERY_SHOP_BUY);
			
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHOP_AUCTION_LIST_UPDATE);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHOP_AUCTION);
		}
	}
}