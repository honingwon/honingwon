package sszt.scene.socketHandlers.acrossServer
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class AcroSerBossEnterSocketHandler extends BaseSocketHandler
	{
		public function AcroSerBossEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACROSS_SERVER_BOSS_ENTER;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(argMonsterMapId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACROSS_SERVER_BOSS_ENTER);
			pkg.writeInt(argMonsterMapId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}