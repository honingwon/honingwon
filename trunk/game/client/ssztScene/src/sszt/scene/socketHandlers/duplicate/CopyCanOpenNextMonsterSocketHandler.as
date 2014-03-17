package sszt.scene.socketHandlers.duplicate
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CopyCanOpenNextMonsterSocketHandler extends BaseSocketHandler
	{
		public function CopyCanOpenNextMonsterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_CAN_OPEN_NEXT_MONSTER;
		}
		
		override public function handlePackage():void
		{
			sceneModule.duplicateGuardInfo.updateCanOpenNextMonster();
			//			CopyTowerCountDownView.getInstance().show(_data.readInt(),_data.readInt(),_data.readInt());
			
			handComplete();
		}
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_OPEN_NEXT_MONSTER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}