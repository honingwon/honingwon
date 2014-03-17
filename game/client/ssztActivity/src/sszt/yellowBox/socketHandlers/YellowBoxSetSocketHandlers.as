package sszt.yellowBox.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.yellowBox.YellowBoxModule;
	
	public class YellowBoxSetSocketHandlers extends BaseSocketHandler
	{
		public function YellowBoxSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(templateModule:YellowBoxModule):void
		{
//			GlobalAPI.socketManager.addSocketHandler(new YellowBoxInfoSocketHandler(templateModule));
//			GlobalAPI.socketManager.addSocketHandler(new YellowBoxGetRewardSocketHandler(templateModule));
		}
		
		public static function remove():void
		{
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_YELLOW_INFO);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_YELLOW_GET_REWARD);
		}
	}
}