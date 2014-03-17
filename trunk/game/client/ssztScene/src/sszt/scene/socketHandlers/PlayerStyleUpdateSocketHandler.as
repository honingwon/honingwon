package sszt.scene.socketHandlers
{
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.scene.PlayerState;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.DateUtil;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	
	public class PlayerStyleUpdateSocketHandler extends BaseSocketHandler
	{
		public function PlayerStyleUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_STYLE_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				var cloth:int = _data.readInt();
				//荒古显示活动装
				if(MapTemplateList.isPerWarMap())
				{
					if(player.info.sex)
						cloth = CategoryType.ZHONGQIUSHIZHANG_1;
					else cloth = CategoryType.ZHONGQIUZHIZHANG_2;
				}
				player.info.updateStyle(cloth,_data.readInt(),_data.readInt(),_data.readInt(),_data.readInt(),_data.readInt(),_data.readBoolean(),_data.readBoolean(),_data.readByte() != 0,_data.readByte() != 0);
				player.speed = _data.readByte() / 10;
				var transportDate:Date = _data.readDate();
				player.setInDarts(DateUtil.millsecondsToSecond(DateUtil.getTimeBetween(GlobalData.systemDate.getSystemDate(),transportDate)));
				var quality:int = _data.readByte();
				player.totalHp = _data.readInt();
				player.totalMp = _data.readInt();
				player.setAttackState(_data.readByte());
				
				if(player.inDarts > 0)
				{
					//添加镖车
					var carInfo:BaseSceneCarInfo = sceneModule.sceneInfo.carList.getCar(id);
					if(!carInfo)
					{
						carInfo = new BaseSceneCarInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
						carInfo.setObjId(id);
						carInfo.owner = id;
						
						carInfo.name =  player.info.nick;
						carInfo.quality = quality;
						carInfo.setScenePos(player.sceneX - 80,player.sceneY - 80);
						sceneModule.sceneInfo.carList.addSceneCar(carInfo);
						carInfo.setFollower(player);
						carInfo.speed = player.speed;
					}
				}
				else
				{
					sceneModule.sceneInfo.carList.removeSceneCar(id);
				}
				
				if(sceneModule.sceneInfo.teamData)
				{
					var teamPlayer:TeamScenePlayerInfo = sceneModule.sceneInfo.teamData.getPlayer(id);
					if(teamPlayer)
					{
						teamPlayer.sex = player.info.sex;
						teamPlayer.career = player.info.career;
						teamPlayer.updateStyle(player.info.style);
					}
				}
				
				player.info.title = _data.readInt();
				player.info.isTitleHide = _data.readBoolean();
				player.info.buffTitleId = _data.readShort();
				
//				var petId:Number = _data.readNumber();
//				var styleId:int = 0;
//				var state:int = _data.readByte();
//				if(state > 0)
//				{
//					var petTemplateId:int = _data.readInt();
//					styleId = _data.readInt();
//					var petName:String = _data.readString();
//					petName = petName == "" ? ItemTemplateList.getTemplate(petTemplateId).name : petName;
//				}
//				if(petId > 0)
//				{
//					if((state & 1) > 0 )
//					{
//						var pet:BaseScenePetInfo = sceneModule.sceneInfo.petList.getPet(petId);
//						if(pet == null)
//						{
//							if(player.info.userId == GlobalData.selfPlayer.userId)
//							{
//								pet = new SelfScenePetInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
//								
//							}
//							else
//							{
//								pet = new BaseScenePetInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
//							}
//							pet.setFollower(player);
//							pet.setObjId(petId);
//							pet.setName(petName);
//							pet.templateId = petTemplateId;
//							pet.owner = player.info.userId;
//							pet.styleId = styleId;
//							pet.titleState = state;
//							pet.speed = player.speed;
//							pet.setScenePos(player.sceneX - 80 + Math.random() * 160,player.sceneY - 80 + Math.random() * 160);
//							if(id == GlobalData.selfPlayer.userId) GlobalData.petList.getPetById(petId).changeState(state);
//							sceneModule.sceneInfo.petList.addScenePet(pet);
//						}
//					}else
//					{
//						sceneModule.sceneInfo.petList.removeScenePet(petId);
//						if(id == GlobalData.selfPlayer.userId && GlobalData.petList.getPetById(petId)) GlobalData.petList.getPetById(petId).changeState(state);
//					}
//				}
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}