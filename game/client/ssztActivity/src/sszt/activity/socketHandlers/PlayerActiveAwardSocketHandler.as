package sszt.activity.socketHandlers
{
	import sszt.activity.ActivityModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class PlayerActiveAwardSocketHandler extends BaseSocketHandler
	{
		public function PlayerActiveAwardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ACTIVE_AWARD;
		}
		
		override public function handlePackage():void
		{
			var isSuccess:Boolean = _data.readBoolean();
			if(isSuccess)
			{
				module.activityInfo.getRewardsSuccess();
			}
			GlobalData.selfPlayer.activeRewardCanGet = false;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.UPDATE_ACTIVE_INFO));
			handComplete();
		}
		
		private function get module():ActivityModule
		{
			return _handlerData as ActivityModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_ACTIVE_AWARD);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}