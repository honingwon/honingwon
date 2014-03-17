package sszt.swordsman.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.swordsman.SwordsmanModule;
	
	public class SwordsmanSetSocketHandlers extends BaseSocketHandler
	{
		public function SwordsmanSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(swordsmanModule:SwordsmanModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new TaskAcceptSocketHandler(swordsmanModule));	
			GlobalAPI.socketManager.addSocketHandler(new TaskPublishSocketHandler(swordsmanModule));	
			GlobalAPI.socketManager.addSocketHandler(new TokenPubliskListSocketHandler(swordsmanModule));	
			GlobalAPI.socketManager.addSocketHandler(new TokenTrustFinish(swordsmanModule));	
				
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TOKEN_TASK_ACCEPT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TOKEN_TASK_PUBLISH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TOKEN_PUBLISH_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TOKEN_TRUST_FINISH);
		}
	}
}