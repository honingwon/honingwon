package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePetInfo;
	
	public class PetNameRelaySocketHandler extends BaseSocketHandler
	{
		public function PetNameRelaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_NAME_RELY;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var pet:BaseScenePetInfo = module.sceneInfo.petList.getPet(id);
			if(pet)
			{
				pet.setName(_data.readString());
			}
			handComplete();
		}
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}