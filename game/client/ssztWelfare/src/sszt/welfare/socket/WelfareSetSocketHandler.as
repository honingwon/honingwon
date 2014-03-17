package sszt.welfare.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class WelfareSetSocketHandler extends BaseSocketHandler
	{
		public function WelfareSetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(handlerData:Object=null):void
		{
			GlobalAPI.socketManager.addSocketHandler(new LoginRewardExchangeSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new LoginRewardLoginDaySocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new LoginRewardReceiveSocketHandler(handlerData));
			
//			GlobalAPI.socketManager.addSocketHandler(new ItemDiscountSocketHandler(handlerData));
//			GlobalAPI.socketManager.addSocketHandler(new ItemDiscountUpdateSocketHandler(handlerData));
//			GlobalAPI.socketManager.addSocketHandler(new ItemDiscountBuySocketHandler(handlerData));
			
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WELFARE_RECEIVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WELFARE_EXCHANGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WELFARE_LOGIN_DAY);

			
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_DISCOUNT);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_DISCOUNT_UPDATE);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_DISCOUNT_BUY);
		}
	}
}