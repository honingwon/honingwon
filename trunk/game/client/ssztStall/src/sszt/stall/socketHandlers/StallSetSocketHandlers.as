package sszt.stall.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.stall.StallModule;
	import sszt.stall.compoments.emptyCell.StallShopBegSaleCellEmpty;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopBuySocketHandler;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopDataSocketHandler;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopMessageSocketHandler;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopSaleSocketHandler;
	
	public class StallSetSocketHandlers extends BaseSocketHandler
	{
		public function StallSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function addStall(stallModule:StallModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new StallPauseSocketHandler(stallModule));
			GlobalAPI.socketManager.addSocketHandler(new StallOKSocketHandler(stallModule));
			GlobalAPI.socketManager.addSocketHandler(new StallUpdateSocketHandler(stallModule));
			GlobalAPI.socketManager.addSocketHandler(new StallMessageUpdateSocketHandler(stallModule));
			GlobalAPI.socketManager.addSocketHandler(new StallDealUpdateSocketHandler(stallModule));
			
		}
		
		public static function addStallShop(stallModule:StallModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new StallShopDataSocketHandler(stallModule));
			GlobalAPI.socketManager.addSocketHandler(new StallShopBuySocketHandler(stallModule));
			GlobalAPI.socketManager.addSocketHandler(new StallShopSaleSocketHandler(stallModule));
			GlobalAPI.socketManager.addSocketHandler(new StallShopMessageSocketHandler(stallModule));
		}
		
		public static function removeStallShop():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_QUERY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_ITEM_BUY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_ITEM_SALE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_MESSAGE);
		}
		
		public static function removeStall():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_CREATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_CANCEL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_MESSAGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_LOG);
		}
	}
}