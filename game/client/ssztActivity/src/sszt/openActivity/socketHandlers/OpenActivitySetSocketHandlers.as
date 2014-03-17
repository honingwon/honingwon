package sszt.openActivity.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.openActivity.OpenActivityModule;
	
	public class OpenActivitySetSocketHandlers extends BaseSocketHandler
	{
		public function OpenActivitySetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(tempModule:OpenActivityModule):void
		{
//			GlobalAPI.socketManager.addSocketHandler(new OpenActivityInfoSocketHandler(tempModule));
//			GlobalAPI.socketManager.addSocketHandler(new OpenActivityGetAwardSocketHandler(tempModule));	
		}
		
		public static function remove():void
		{
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ACTIVE_OPEN_SERVER);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ACTIVE_OPEN_SERVER_AWARD);
		}
	}
}