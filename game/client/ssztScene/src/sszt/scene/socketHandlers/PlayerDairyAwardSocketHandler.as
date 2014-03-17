package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.gift.GetGitAnimation;
	import sszt.scene.components.gift.GiftView;
	
	public class PlayerDairyAwardSocketHandler extends BaseSocketHandler
	{
		public function PlayerDairyAwardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_DAILY_AWARD;
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readByte();
			var success:Boolean = _data.readBoolean();
			if(success)
			{
				sceneModule.onlineRewardInfo.rewardGot(id);
				PlayerDairyAwardListSocketHandler.send();
			}
			
			handComplete();
		}
		
		//0 1-15
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_DAILY_AWARD);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}