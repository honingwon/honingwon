package sszt.scene.data
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.module.changeInfos.ToSceneData;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.quickIcon.QuickIconInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.scene.IMapData;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.collects.CollectItemList;
	import sszt.scene.data.dropItem.DropItemList;
	import sszt.scene.data.events.EventList;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.tradeDirect.TradeDirectInfo;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	
	public class SceneInfo extends EventDispatcher implements IMapData
	{
		public var monsterList:SceneMonsterList;
		/**当前场景玩家数据列表*/
		public var playerList:ScenePlayerList;
		public var petList:ScenePetList;
		public var teamData:TeamPlayerList;
		public var nearData:NearData;
		public var hangupData:HangupData;
		public var dropItemList:DropItemList;
		public var eventList:EventList;
		public var collectList:CollectItemList;
		public var carList:SceneCarList;
		/**地图数据信息*/
		public var mapDatas:MapDatas;
		/**场景地图信息*/
		public var mapInfo:SceneMapInfo;
		public var bornX:int;
		public var bornY:int;
		public var mapThumbnail:BitmapData;
//		public var mapCheckBoxData:Vector.<Boolean> = Vector.<Boolean>([true,true,true]);
		public var mapCheckBoxData:Array = [true,true,true];
		public var tradeDirectInfo:TradeDirectInfo;
		public var attackList:SceneAttackList;
		
		/**
		 * 当前选中的技能
		 */		
//		public var selectSkill:SkillItemInfo;
		private var _selectSkills:Array = [];
		
		private var _currentSelect:BaseRoleInfo;
		
		public function SceneInfo(toSceneData:ToSceneData)
		{
			mapDatas = new MapDatas();
			mapInfo = new SceneMapInfo(toSceneData.id);
			mapInfo.setMapId(toSceneData.id);
			bornX = toSceneData.bornX;
			bornY = toSceneData.bornY;
			playerList = new ScenePlayerList();
			GlobalAPI.tickManager.addTick(playerList);
			monsterList = new SceneMonsterList();
			GlobalAPI.tickManager.addTick(monsterList);
			petList = new ScenePetList();
			GlobalAPI.tickManager.addTick(petList);
			dropItemList = new DropItemList(this);
			teamData = new TeamPlayerList();
			eventList = new EventList();
			nearData = new NearData();
			hangupData = new HangupData();
			collectList = new CollectItemList();
			GlobalAPI.tickManager.addTick(collectList);
			carList = new SceneCarList();
			GlobalAPI.tickManager.addTick(carList);
			tradeDirectInfo = new TradeDirectInfo();
			attackList = new SceneAttackList();
			initEvent();
		}
		
		public function configureMapData(toSceneData:ToSceneData):void
		{
			mapInfo.setMapId(toSceneData.id);
			bornX = toSceneData.bornX;
			bornY = toSceneData.bornY;
			dispatchEvent(new SceneInfoUpdateEvent(SceneInfoUpdateEvent.MAP_ENTER));
		}
		
		private function initEvent():void
		{
			playerList.addEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			monsterList.addEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER,removeMonsterHandler);
		}
		
		private function removeEvent():void
		{
			playerList.removeEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			monsterList.removeEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER,removeMonsterHandler);
		}
		
		public function setMapThumbnail(data:BitmapData):void
		{
			mapThumbnail = data;
			dispatchEvent(new SceneInfoUpdateEvent(SceneInfoUpdateEvent.SETNAIL_COMPLETE));
		}
		
		public function getSceneId():int
		{
			if(mapInfo)
				return mapInfo.mapId;
			return 0;
		}
		
		public function getCurrentSelect():BaseRoleInfo
		{
			return _currentSelect;
		}
		public function setCurrentSelect(value:BaseRoleInfo):void
		{
			if(_currentSelect == value)return;
			if(value && value.getObjType() == MapElementType.PLAYER && value.getObjId() == GlobalData.selfPlayer.userId)return;
			if(_currentSelect)
			{
				_currentSelect.selected = false;
			}
			_currentSelect = value;
			if(_currentSelect)
				_currentSelect.selected = true;
			dispatchEvent(new SceneInfoUpdateEvent(SceneInfoUpdateEvent.SELECT_CHANGE));
		}
		
		private function removePlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			if(_currentSelect)
			{
				if(MapElementType.isPlayer(_currentSelect.getObjType()) && _currentSelect.getObjId() == BaseScenePlayerInfo(evt.data).getObjId())
				{
					setCurrentSelect(null);
				}
			}
		}
		private function removeMonsterHandler(evt:SceneMonsterListUpdateEvent):void
		{
			if(_currentSelect)
			{
				if(MapElementType.isMonster(_currentSelect.getObjType()) && _currentSelect.getObjId() == BaseSceneMonsterInfo(evt.data).getObjId())
				{
					setCurrentSelect(null);
				}
			}
			if (CopyTemplateList.isTowerCopy(GlobalData.copyEnterCountList.inCopyId))
			{
				var monster:BaseSceneMonsterInfo = null;
				hangupData.attackIndex = 1;
				for each (monster in monsterList.getMonsters()) {
					if (MonsterTemplateList.GUARD_MONSTER.indexOf(monster.templateId) != -1){
						hangupData.attackIndex = 0;
						break;
					}
				}
			}
		}
		
		public function addSkill(skill:SkillItemInfo):void
		{
			if(_selectSkills.indexOf(skill) != -1)_selectSkills.splice(_selectSkills.indexOf(skill),1);
			_selectSkills.unshift(skill);
		}
		public function getSkill():SkillItemInfo
		{
			return _selectSkills[0];
		}
		public function clearSkill():void
		{
			_selectSkills.shift();
		}
		
		public function bigmapSelectedChange(mapId:int) : void
		{
			dispatchEvent(new SceneInfoUpdateEvent(SceneInfoUpdateEvent.BIGMAP_SELECT_CHANGE, mapId));
		}
		
		
		public function dispatchRender():void
		{
			dispatchEvent(new SceneInfoUpdateEvent(SceneInfoUpdateEvent.RENDER));
		}
		
		public function getRoleInfo(type:int,id:Number):BaseRoleInfo
		{
			if(MapElementType.isMonster(type))
			{
				return monsterList.getMonster(id);
			}
			else if(MapElementType.isPlayer(type))
			{
				return playerList.getPlayer(id);
			}
			else if(MapElementType.isPet(type))
			{
				return petList.getPet(id);
			}
			return null;
		}
		
		public function getWidth():int
		{
			return mapInfo.width;
		}
		public function getHeight():int
		{
			return mapInfo.height;
		}
		
		public function changeScene():void
		{
			setCurrentSelect(null);
			if(monsterList)monsterList.clear();
			if(playerList)playerList.clear();
			if(nearData)nearData.clearData();
			if(dropItemList)dropItemList.clear();
			if(mapInfo)mapInfo.clear();
			if(mapThumbnail)mapThumbnail = null;
			if(hangupData)hangupData.clear();
			if(petList)petList.clear();
			if(collectList)collectList.clear();
			if(carList)carList.clear();
			if(teamData)teamData.setNearBy(false);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CHANGE_SCENE));
		}
	}
}