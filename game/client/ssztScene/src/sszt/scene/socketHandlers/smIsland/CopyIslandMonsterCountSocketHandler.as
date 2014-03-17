package sszt.scene.socketHandlers.smIsland
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.copyIsland.CIMaininfo;
	
	public class CopyIslandMonsterCountSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandMonsterCountSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_MONSTERCOUNT;
		}
		
		override public function handlePackage():void
		{
			var mainInfo:CIMaininfo = sceneModule.copyIslandInfo.cIMainInfo;
			if(!mainInfo)return;
			if(mainInfo.stage < mainInfo.maxStage)return;
			mainInfo.leftMonsterCount = _data.readInt();
			mainInfo.allMonsterCount = _data.readInt();
			mainInfo.updateMonsterCount();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_MONSTERCOUNT);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}