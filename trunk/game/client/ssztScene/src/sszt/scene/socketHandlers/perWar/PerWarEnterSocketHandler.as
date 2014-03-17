package sszt.scene.socketHandlers.perWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class PerWarEnterSocketHandler extends BaseSocketHandler
	{
		public function PerWarEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERWAR_ENTER_WAR;
		}
		
		override public function handlePackage():void
		{
			GlobalData.copyEnterCountList.isInCopy = true;
			handComplete();
		}
		
		public static function send(argWarSceneId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERWAR_ENTER_WAR);
			pkg.writeNumber(argWarSceneId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}