package sszt.firstRecharge.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.firstRecharge.FirstRechargeModule;
	
	public class FirstRechargeSetSocketHandlers extends BaseSocketHandler
	{
		public function FirstRechargeSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(templateModule:FirstRechargeModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new FirstRechargeInfoSocketHandler(templateModule));	
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEMP_1);
		}
	}
}