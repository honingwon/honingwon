package sszt.sevenActivity.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.sevenActivity.SevenActivityModule;
	
	public class SevenActivitySetSocketHandlers extends BaseSocketHandler
	{
		public function SevenActivitySetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(templateModule:SevenActivityModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new SevenActivityGetRewardSocketHandler(templateModule));	
			GlobalAPI.socketManager.addSocketHandler(new SevenActivityGetReward2SocketHandler(templateModule));	
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_SEVEN_GETREWARD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_SEVEN_GETREWARD2);
		}
	}
}