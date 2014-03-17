package sszt.scene.socketHandlers.smIsland
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.copyIsland.CIMaininfo;
	
	public class CopyIslandReliveSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandReliveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_RELIVE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(argCopyId:int,argStage:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_RELIVE);
			pkg.writeInt(argCopyId);
			pkg.writeInt(argStage);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}