package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class PlayerLifeExpSitSocketHandler extends BaseSocketHandler
	{
		public function PlayerLifeExpSitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_LIFE_EXP_SIT;
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(sit:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_LIFE_EXP_SIT);
			pkg.writeByte(sit);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}