package sszt.common.wareHouse.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class WareHouseSetSocket extends BaseSocketHandler
	{
		public function WareHouseSetSocket(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(handlerData:Object=null):void
		{
			GlobalAPI.socketManager.addSocketHandler(new WareHouseUpdateSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new WareHouseBankSocketHandler(handlerData));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.DEPOT_ITEM_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BANK_UPDATE);
		}
	}
}