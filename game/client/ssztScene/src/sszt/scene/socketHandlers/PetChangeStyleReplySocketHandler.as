package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePetInfo;
	
	public class PetChangeStyleReplySocketHandler extends BaseSocketHandler
	{
		public function PetChangeStyleReplySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_CHANGE_STYLE_REPLY;
		}
		
		override public function handlePackage():void
		{
			var petId:Number = _data.readNumber();
			var styleId:int = _data.readInt();
			var petInfo:PetItemInfo = GlobalData.petList.getPetById(petId);
			if(petInfo) petInfo.updateStyle(styleId);
			var pet:BaseScenePetInfo = module.sceneInfo.petList.getPet(petId);
			if(pet)
			{
				pet.styleId = styleId;
			}
			handComplete();
		}
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}