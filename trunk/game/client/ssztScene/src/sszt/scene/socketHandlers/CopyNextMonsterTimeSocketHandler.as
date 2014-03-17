package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;

//	import sszt.scene.components.copyGroup.sec.CopyTowerCountDownView;
	
	public class CopyNextMonsterTimeSocketHandler extends BaseSocketHandler
	{
		public function CopyNextMonsterTimeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_NEXT_MONSTER_TIME;
		}
		
		override public function handlePackage():void
		{
			var missionNum:int = _data.readInt();
			var totalMission:int = _data.readInt();
			var nextTime:int = _data.readInt();
			sceneModule.duplicateGuardInfo.updateMission(missionNum,nextTime);
//			CopyTowerCountDownView.getInstance().show(_data.readInt(),_data.readInt(),_data.readInt());
			
			handComplete();
		}
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}