package sszt.scene.socketHandlers.smIsland
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CopyIslandLeaveSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_LEAVE;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.scenePath = null;
			GlobalData.selfPlayer.scenePathTarget = null;
			GlobalData.selfPlayer.scenePathCallback = null;
			if(sceneModule.sceneInit.playerListController.getSelf())sceneModule.sceneInit.playerListController.getSelf().stopMoving();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_LEAVE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}