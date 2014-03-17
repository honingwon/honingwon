package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class MapPetRemoveHandler extends BaseSocketHandler
	{
		public function MapPetRemoveHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_PET_REMOVE;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.petList.removeScenePet(_data.readNumber());
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}