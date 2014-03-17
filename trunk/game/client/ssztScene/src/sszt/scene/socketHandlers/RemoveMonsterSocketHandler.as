package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class RemoveMonsterSocketHandler extends BaseSocketHandler
	{
		public function RemoveMonsterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.REMOVE_MONSTER;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			sceneModule.sceneInfo.monsterList.removeSceneMonster(id);
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}