package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class MapMonsterRemoveSocketHandler extends BaseSocketHandler
	{
		public function MapMonsterRemoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_MONSTER_REMOVE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				//sceneModule.sceneInfo.monsterList.removeSceneMonsterByTemplateId(_data.readInt());
				sceneModule.sceneInfo.monsterList.removeSceneMonster(_data.readInt());
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}