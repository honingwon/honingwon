package sszt.scene.socketHandlers
{
	import flash.geom.Point;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;

	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class MapPetInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function MapPetInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_PET_INFO_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var pet:BaseScenePetInfo = sceneModule.sceneInfo.petList.getPet(id);
			var templateId:int = _data.readInt();
			var styleId:int = _data.readInt();
			var owner:Number = _data.readNumber();
			var petOwner:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(owner);
			if(petOwner)
			{
				if(pet == null)
				{
					if(owner == GlobalData.selfPlayer.userId)
					{
						pet = new SelfScenePetInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
					
					}
					else
					{
						pet = new BaseScenePetInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
					}
					pet.setFollower(petOwner);
					pet.setObjId(id);
					pet.setName(_data.readString());
					pet.templateId = templateId;
					pet.styleId = styleId;
					pet.owner = owner;
					pet.speed = petOwner.speed;
					pet.setScenePos(petOwner.sceneX - 80 + Math.random() * 160,petOwner.sceneY - 80 + Math.random() * 160);
					sceneModule.sceneInfo.petList.addScenePet(pet);
				}
				else if(pet.styleId != styleId)
				{
					pet.styleId = styleId;
				}
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}