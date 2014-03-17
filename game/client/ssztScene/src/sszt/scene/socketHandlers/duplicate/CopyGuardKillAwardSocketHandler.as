package sszt.scene.socketHandlers.duplicate
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class CopyGuardKillAwardSocketHandler extends BaseSocketHandler
	{
		public function CopyGuardKillAwardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.COPY_GUARD_KILL_AWARD;
		}
		
		override public function handlePackage():void
		{
			sceneModule.duplicateGuardInfo.updateAward(_data.readInt(),_data.readInt());
			//			CopyTowerCountDownView.getInstance().show(_data.readInt(),_data.readInt(),_data.readInt());
			
			handComplete();
		}
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}