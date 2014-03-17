package sszt.activity.socketHandlers
{
	import sszt.activity.ActivityModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ActivitySetSocketHandlers extends BaseSocketHandler
	{
		public function ActivitySetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function addSocketHandler(activityModule:ActivityModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new WelfareGetSocketHandler(activityModule));
			GlobalAPI.socketManager.addSocketHandler(new PlayerActivyCollectSocketHandler(activityModule));
			GlobalAPI.socketManager.addSocketHandler(new PlayerActiveAwardSocketHandler(activityModule));
			GlobalAPI.socketManager.addSocketHandler(new PlayerActiveInfoSocketHandler(activityModule));
			GlobalAPI.socketManager.addSocketHandler(new PlayerActiveStateSocketHandler(activityModule));
			GlobalAPI.socketManager.addSocketHandler(new BossInfoSocketHandler(activityModule));
		}
		
		public static function removeSocketHandler():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_WELF_SEARCH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ACTIVY_COLLECT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ACTIVE_AWARD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ACTIVE_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ACTIVE_REWARDS_STATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BOSS_INFO);
		}
	}
}