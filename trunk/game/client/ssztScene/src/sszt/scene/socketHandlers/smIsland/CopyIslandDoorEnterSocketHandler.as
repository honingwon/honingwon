package sszt.scene.socketHandlers.smIsland
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CopyIslandDoorEnterSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandDoorEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_DOOR_ENTER;
		}
		
		override public function handlePackage():void
		{
			var result:int = _data.readInt();
			if(result == 1)
			{
				GlobalAPI.waitingLoading.hide();
				return;
			}
			else if(result == 2)
			{
				GlobalAPI.waitingLoading.hide();
				QuickTips.show(LanguageManager.getWord("ssztl.scene.noKillAllCurFloorMonster"));
				return;
			}
			handComplete();
		}
		
		public static function send(argNextDoorId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_DOOR_ENTER);
			pkg.writeInt(argNextDoorId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}