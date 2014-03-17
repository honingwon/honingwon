package sszt.scene.socketHandlers.duplicate
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class CopyPassRemainMonsterSocketHandle extends BaseSocketHandler
	{
		public function CopyPassRemainMonsterSocketHandle(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.COPY_PASS_REMAIN_MONSTER;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			var monsterId:int = _data.readInt();
			if(monsterId < 10001 || monsterId > 19999 )
			{
				sceneModule.duplicatePassInfo.updateMonsterNum(id,monsterId);
				sceneModule.duplicateChallInfo.updateMonsterNum(id,monsterId);
			}			
			handComplete();
		}
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}