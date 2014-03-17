package sszt.consign.socketHandlers
{
	import sszt.consign.ConsignModule;
	import sszt.consign.socket.BillDealSocketHandler;
	import sszt.consign.socket.BillDeleteSocketHandler;
	import sszt.consign.socket.GoldDealSockectHandler;
	import sszt.consign.socket.GoldListUpdateSocketHandler;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ConsignSetSocketHandler extends BaseSocketHandler
	{
		public function ConsignSetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function addHandlers(consignModule:ConsignModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new ConsignAddConsignHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new ConsignAddYuanBaoHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new ConsignBuyHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new ConsignDeleteConsignHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new ConsignQueryHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new ConsignQuerySelfHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new ConsignContinueHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new ConsignUpdateHandler(consignModule));
			
			GlobalAPI.socketManager.addSocketHandler(new GoldListUpdateSocketHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new GoldDealSockectHandler(consignModule));
			GlobalAPI.socketManager.addSocketHandler(new BillDealSocketHandler(consignModule));
//			GlobalAPI.socketManager.addSocketHandler(new BillDeleteSocketHandler(consignModule));
		}
		
		public static function removeHandlers():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_YUANBAO_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_DELETE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_QUERY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_BUY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_QUERY_SELF);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_YUANBAO_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_YUANBAO_DEAL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_MY_YUANBAO_DEAL);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CONSIGN_BILL_DELETE);
		}
	}
}