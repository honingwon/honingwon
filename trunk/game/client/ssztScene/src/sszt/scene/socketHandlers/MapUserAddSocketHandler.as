package sszt.scene.socketHandlers
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.PlayerState;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.LayerManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.PackageUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.components.sceneObjs.BaseScenePet;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.utils.PathUtils;
	
	public class MapUserAddSocketHandler extends BaseSocketHandler
	{
		public function MapUserAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_USER_ADD;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			for(var i:int = 0; i < len; i++)
			{
				var id:Number = _data.readNumber();
				var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
				var figurePlayer:FigurePlayerInfo;
				var add:Boolean = false;
				if(player == null)
				{
					if(id != GlobalData.selfPlayer.userId)
					{
						figurePlayer = new FigurePlayerInfo();
						player = new BaseScenePlayerInfo(figurePlayer,new CharacterWalkActionII());
						figurePlayer.userId = id;
					}
					else
					{
						player = new SelfScenePlayerInfo(GlobalData.selfPlayer,sceneModule.sceneMediator,new CharacterWalkActionII());
						sceneModule.elementInfoContainer.setInfo(player);
						figurePlayer = player.info;
					}
					add = true;
				}
				else
				{
					figurePlayer = player.info;
				}
				player.warState = _data.readByte();
				player.totalHp = _data.readInt();
				player.currentHp = _data.readInt();
				player.totalMp = _data.readInt();
				player.currentMp = _data.readInt();
				
				//显示XXX的老公/老婆/小妾。1 2 3
				var marryRelationType:int = _data.readShort();
				var marryNick:String = _data.readUTF();
				player.marryRelationType = marryRelationType;
				player.marryNick = marryNick;
				
				var cloth:int = -1;
				//荒古显示活动装
				if(MapTemplateList.isPerWarMap())
				{
					if(player.info.sex)
						cloth = CategoryType.ZHONGQIUSHIZHANG_1;
					else cloth = CategoryType.ZHONGQIUZHIZHANG_2;
				}
				PackageUtil.readFigurePlayer(figurePlayer,_data,cloth);
				if(id == GlobalData.selfPlayer.userId)
					GlobalData.selfPlayer.updateClubInfo(figurePlayer.clubId,figurePlayer.clubName,figurePlayer.camp,figurePlayer.clubDuty);
				if(sceneModule.sceneInfo.teamData)
				{
					var teamPlayer:TeamScenePlayerInfo = sceneModule.sceneInfo.teamData.getPlayer(id);
					if(teamPlayer)
					{
						teamPlayer.sex = figurePlayer.sex;
						teamPlayer.career = figurePlayer.career;
						teamPlayer.updateStyle(figurePlayer.style);
						teamPlayer.isNearby = true;
					}
				}
				player.speed = _data.readByte() / 10;
				var transportDate:Date = _data.readDate();
				player.setInDarts(DateUtil.millsecondsToSecond(DateUtil.getTimeBetween(GlobalData.systemDate.getSystemDate(),transportDate)));
				var quality:int = _data.readByte();
				var currentX:int = _data.readShort();
				var currentY:int = _data.readShort();
//				if(currentX == 1304 && currentY == 2570)
//				{
//					SetModuleUtils.addPVP1();
//				}
				var attackState:int = _data.readByte();
				if(player.inDarts > 0)
				{
					//添加镖车
					var carInfo:BaseSceneCarInfo = sceneModule.sceneInfo.carList.getCar(id);
					if(!carInfo)
					{
						carInfo = new BaseSceneCarInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
						carInfo.setObjId(id);
						carInfo.owner = id;
//						carInfo.name = "[" + player.info.serverId + "]" + player.info.nick + "的镖车";
						carInfo.name = player.info.nick;
						carInfo.quality = quality;
					}
					carInfo.setScenePos(currentX - 80,currentY - 80);
					carInfo.speed = player.speed;
					sceneModule.sceneInfo.carList.addSceneCar(carInfo);
					carInfo.setFollower(player);
				}
				var pathIndex:int = _data.readShort();
				var pathlen:int = _data.readShort();
				if(pathlen > 0)
				{
					if(add)
					{
						player.setScenePos(currentX,currentY);
						sceneModule.sceneInfo.playerList.addPlayer(player);
					}
					var path:Array = [];
					var lastX:int;
					var lastY:int;
					for(var k:int = 0; k < pathlen; k++)
					{
						lastX = _data.readShort();
						lastY = _data.readShort();
						path.push(new Point(lastX,lastY));
					}
					if(lastX != currentX || lastY != currentY)
					{
						player.setPath(path,null);
					}
				}
				else
				{
					player.setScenePos(currentX,currentY);
					if(add)
					{
						sceneModule.sceneInfo.playerList.addPlayer(player);
					}
				}
				player.setAttackState(attackState);
				
				var buffLen:int = _data.readShort();
				for(var v:int = 0; v < buffLen; v++)
				{
					var buffId:int = _data.readInt();
					if(_data.readBoolean())
					{
						var buff:BuffItemInfo = player.getBuff(buffId);
						var buffAdd:Boolean = false;
						if(buff == null)
						{
							buff = new BuffItemInfo();
							buff.templateId = buffId;
							buffAdd = true;
						}
						if(buff.getTemplate().getIsTime())
						{
							buff.endTime = _data.readDate64();
						}
						else 
						{
							buff.remain = _data.readNumber();
						}
						buff.setPause(_data.readBoolean());
						buff.pauseTime = _data.readDate64();
						buff.totalValue = _data.readInt();
						
						if(buffAdd)
						{
							player.addBuff(buff);
						}
					}
					else
					{
//						player.removeBuff(buffId);
					}
				}
				
				var petId:Number = _data.readNumber();
				var petTemplateId:int = _data.readInt();
				var styleId:int = _data.readInt();
				var petName:String = _data.readString();
//				var titleState:int = _data.readByte();
				if(petTemplateId != 0)
				{
					petName = petName == "" ? PetTemplateList.getPet(petTemplateId).name : petName;
					var pet:BaseScenePetInfo = sceneModule.sceneInfo.petList.getPet(petId);
					if(pet == null)
					{
						if(player.info.userId == GlobalData.selfPlayer.userId)
						{
							pet = new SelfScenePetInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
							pet.owner = player.info.userId;
							
						}
						else
						{
							pet = new BaseScenePetInfo(sceneModule.sceneMediator,new CharacterWalkActionII());
						}
						
						pet.templateId = petTemplateId;
						pet.setObjId(petId);
						pet.setFollower(player);
						pet.setName(petName);
						pet.styleId = styleId;
						pet.owner = player.info.userId;
						//					pet.titleState = titleState;
						pet.setScenePos(player.sceneX - 80 + Math.random() * 160,player.sceneY - 80 + Math.random() * 160);
						pet.speed = player.speed;
						
						sceneModule.sceneInfo.petList.addScenePet(pet);
					}
				}
			}
			handComplete();
		}
		
		private var _playerInfos:Array = [];
		private var _tmp:int = 0;
		private var _movieList:Array = [];
		
		private var _effects:Array = [101,102,103,104,105,106,107,108,109,110,111,112,10001,10002,10003,10004,10005,10006,
		20001,20002,20003,20004,20005,20006,20007,20008,20009,20010,20011,20012,20013,20014,20015,20016,20017,20018,20019,
		20020,20021,20022,20023,20024,20025,20026,20027,20028,20029,20030,20031,20032,20034,20035,20036,20037,20038];
		
		private function enterFrameHandler(evt:Event):void
		{
			var movieinfo:MovieTemplateInfo = MovieTemplateList.getMovie(_effects[int(_effects.length * Math.random())]);
			if(movieinfo)
			{
				var movie:BaseLoadEffect = new BaseLoadEffect(movieinfo);
				movie.play(SourceClearType.IMMEDIAT);
				sceneModule.sceneInit.playerListController.getSelf().scene.addEffect(movie);
				movie.move(Math.random() * 1200 + 200,Math.random() * 700 + 400);
				_movieList.push(movie);
			}
			
			if(_tmp > 0)_tmp = 0;
			else 
			{
				_tmp++;
				return;
			}
			var n:BaseScenePlayerInfo = getTmpPlayer();
			_playerInfos.push(n);
			sceneModule.sceneInfo.playerList.addPlayer(n);
			if(_playerInfos.length > 80)
			{
				var nn:BaseScenePlayerInfo = _playerInfos.shift();
				sceneModule.sceneInfo.playerList.removePlayer(nn.info.userId);
			}
		}
		
		private var _hadAdd:Boolean = false;
		private var _id:Number = 100000;
		private var _cloths:Array = [117011,117005,118035,117009,119059];
		private var _weapons:Array = [111001,112001,113001,114001,115001,116001];
		private var _winds:Array = [142002,142003,142004,142005];

		private function getTmpPlayer():BaseScenePlayerInfo
		{
			_id ++;
			var figure:FigurePlayerInfo = new FigurePlayerInfo();
			figure.sex = Math.random() > 0.5;
			figure.userId = _id;
			figure.nick = "test" + _id;
			figure.career = CareerType.SANWU;
			var t:Array = GlobalData.selfPlayer.style;
			figure.updateStyle(_cloths[int(_cloths.length * Math.random())],_weapons[int(_weapons.length * Math.random())],0,_winds[int(_winds.length * Math.random())],0,0,true); 
			var player:BaseScenePlayerInfo = new BaseScenePlayerInfo(figure,new CharacterWalkActionII());
			player.setScenePos(Math.random() * 1200 + 200,Math.random() * 700 + 400);
			return player;
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}