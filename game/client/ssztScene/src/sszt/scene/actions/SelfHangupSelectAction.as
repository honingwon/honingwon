/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-6-3 下午4:44:17 
 * 
 */ 
package sszt.scene.actions 
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.utils.CellDoubleClickHandler;
	import sszt.scene.actions.characterActions.BaseCharacterAction;
	import sszt.scene.checks.AttackChecker;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.dropItem.DropItemInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.mediators.SceneMediator;
	
	public class SelfHangupSelectAction extends BaseCharacterAction
	{
		
		private var _mediator:SceneMediator;
		private var _sceneInfo:SceneInfo;
		
		private static var doubleBuffId:int = 716501;
		private static var doubleExpId:int = 101026;
//		private var _selected:Boolean = false;
//		private var _walk:Boolean = false;
		
		private static var _moneymonster:Array = [200201,200202,200203,200204,200205,200206,200207,200208,200209,2002010];
		public function SelfHangupSelectAction(character:BaseRole,mediator:SceneMediator)
		{
			super(null,0);
			_mediator = mediator;
			_sceneInfo = _mediator.sceneInfo;
			setCharacter(character);
			
		}
		
		
		override public function configure(...parameters):void
		{
			isFinished = false;
			_character.getBaseRoleInfo().addEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,characterInfoUpdateHandler);
			_character.getBaseRoleInfo().addEventListener(BaseRoleInfoUpdateEvent.REMOVEBUFF,buffInfoUpdateHandler);
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			var doInEndPickup:Boolean;
			var item:DropItemInfo;
			var equipQualitys:Array;
			var otherQualitys:Array;
			var targets:Array;
			var currentSelected:BaseRoleInfo;
			var monster:BaseSceneMonsterInfo;
			var doorList:Array;
			var mapId:int;
			var door:DoorTemplateInfo;
			var mapTemplate:MapTemplateInfo;
			var targetId:int;
			var dis:Number;
			var id:int;
			var monsterInfo:MonsterTemplateInfo;
			var m:Number;
			if (!_sceneInfo || !_sceneInfo.playerList.self || !_sceneInfo.playerList.self.getIsHangup() )
			{
				isFinished = true;
				return;
			}
			var pickup:Boolean;
			var selfPoint:Point = new Point(_character.sceneX, _character.sceneY);
			if (GlobalData.bagInfo.getHasPos(1))
			{
				equipQualitys = _sceneInfo.hangupData.getEquipQualityPicks();
				if (equipQualitys && equipQualitys.length > 0)
				{
					item = _sceneInfo.dropItemList.getOneEquipCanPickByQuality(equipQualitys);
				}
				if (!item)
				{
					otherQualitys = _sceneInfo.hangupData.getOtherQualityPicks();
					if (otherQualitys && otherQualitys.length > 0)
					{
						item = _sceneInfo.dropItemList.getOneOtherCanPickByQuality(otherQualitys);
					}
				}
				if (item)
				{
					doInEndPickup = true;
					pickup = true;
				}
			}
			if (!pickup){
				targets = _sceneInfo.hangupData.monsterList;
				if (targets.length > 0 || MapTemplateList.isGuardDuplicate() || MapTemplateList.isMoneyDuplicate()){
					currentSelected = _sceneInfo.getCurrentSelect();
					if (currentSelected && MapElementType.isHangupMonster(currentSelected.getObjType()))
					{
						monster = currentSelected as BaseSceneMonsterInfo;
					}
					if (!monster)
					{
						if(MapTemplateList.isGuardDuplicate())
						{
							monster = _sceneInfo.monsterList.getNearlyMonster(selfPoint);	
						}
						else if(MapTemplateList.isMoneyDuplicate())// 打钱副本
						{
							monster = _sceneInfo.monsterList.getNearlyMonsterByType(_moneymonster, selfPoint);
						}
						else
						{
							monster = _sceneInfo.monsterList.getNearlyMonsterByType(targets, selfPoint);
						}
						if (monster && _sceneInfo.hangupData.attackPath.length > 0)
						{
							if (CopyTemplateList.isTowerCopy(GlobalData.copyEnterCountList.inCopyId) )
							{
								if (monster.getDistance(_sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex]) > 500){
									monster = null;
								}
							}
							else if (!CopyTemplateList.isHangupToNextLayer(GlobalData.copyEnterCountList.inCopyId) ){
								if (_sceneInfo.hangupData.attackIndex == 0){
									if (monster.getDistance(selfPoint) > 500){
										monster = null;
									}
								} 
								else {
									if (_sceneInfo.hangupData.attackIndex != _sceneInfo.hangupData.attackPath.length){
										if (monster.getDistance(_sceneInfo.hangupData.attackPath[(_sceneInfo.hangupData.attackIndex - 1)]) > 300){
											monster = null;
										}
									}
								}
							}
						}
					}
					if (monster == null)
					{
						if( !MapTemplateList.isMoneyDuplicate())
						{
							_sceneInfo.playerList.self.clearHangup();
						}
						if (CopyTemplateList.isHangupToNextLayer(GlobalData.copyEnterCountList.inCopyId)){
							doorList = DoorTemplateList.sceneDoorList[GlobalData.currentMapId];
							mapId = 0;
							for each (door in doorList) {
								if (mapId < door.nextMapId && door.nextMapId > GlobalData.currentMapId ){
									mapId = door.nextMapId;
								}
							}
							mapTemplate = MapTemplateList.getMapTemplate(mapId);
							if (mapTemplate){
								this._mediator.walk(mapId, mapTemplate.defalutPoint, AttackChecker.gotoNextLayer);
							}
						} 
						else if (CopyTemplateList.isTowerCopy(GlobalData.copyEnterCountList.inCopyId))
						{
							this._mediator.walk(_sceneInfo.mapInfo.mapId, _sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex], AttackChecker.attackMonster2);
						} 
//						else if (CopyTemplateList.isTaiYuan(GlobalData.copyEnterCountList.inCopyId))
//						{
//							this._mediator.walk(_sceneInfo.mapInfo.mapId, _sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex], AttackChecker.attackMonster3);
//						} 
						else if (_sceneInfo.hangupData.attackPath.length > 0)
						{
							if (_sceneInfo.hangupData.attackIndex < _sceneInfo.hangupData.attackPath.length)
							{
								this._mediator.walk(_sceneInfo.mapInfo.mapId, _sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex], AttackChecker.attackMonster);
							}
						}
						else {
							dis = 1000000;
							for each (id in targets) {
								monsterInfo = MonsterTemplateList.getMonster(id);
								m = Point.distance(selfPoint, new Point(monsterInfo.centerX, monsterInfo.centerY));
								if (m < dis){
									targetId = monsterInfo.monsterId;
									dis = m;
								}
							}
							if (targetId > 0){
								this._mediator.walkToHangup(targetId, false);
							}
						}
					}
					else 
					{
						_sceneInfo.setCurrentSelect(monster);
					}
				}
				else if(_sceneInfo.hangupData.attackPath.length > 0)
				{
					this._mediator.walk(_sceneInfo.mapInfo.mapId, _sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex], AttackChecker.attackMonster2);
				}
			}
//			if (_sceneInfo.getCurrentSelect())
//			{
//				if(!_selected)
//				{
//					if(!_walk)
//					{
//						return;
//					}
//					if(_sceneInfo.getCurrentSelect().getDistance(_sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex]) < _sceneInfo.getCurrentSelect().getDistance(selfPoint))
//					{
//						if (CopyTemplateList.isTowerCopy(GlobalData.copyEnterCountList.inCopyId))
//						{
//							
//						}
//						else
//						{
//							_sceneInfo.hangupData.attackIndex++;
//						}
//					}
//					_selected = true;
//					_mediator.stopMoving();
//					_sceneInfo.playerList.self.clearHangup();
//					_sceneInfo.playerList.self.setHangupState();
//				}
//			}
//			else
//			{
//				_selected = false;
//			}
			if (doInEndPickup && item){
				this._mediator.sceneInfo.playerList.self.setHangupPickup();
				this._mediator.walkToPickup(item.id, item.sceneX, item.sceneY, this._mediator.setHangup, false);
			}
		}
		
		
		private function characterInfoUpdateHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			if(!_sceneInfo || !_sceneInfo.playerList.self.getIsHangup())return;
			//吃药，补MP
			var item:ItemInfo;
			if(_sceneInfo.hangupData.autoAddHp && _character.getBaseRoleInfo().getHpPercent() < _sceneInfo.hangupData.autoAddHpValue)
			{
				item = GlobalData.bagInfo.getCanUseHpItem(_sceneInfo.hangupData.addHpAdd);
				if(item)
				{
					CellDoubleClickHandler.useItem(item);
				}
			}
			if(_sceneInfo.hangupData.autoAddMp && _character.getBaseRoleInfo().getMpPercent() < _sceneInfo.hangupData.autoAddMpValue)
			{
				item = GlobalData.bagInfo.getCanUseMpItem(_sceneInfo.hangupData.addMpAdd);
				if(item)
				{
					CellDoubleClickHandler.useItem(item);
				}
			}
		}

		private function buffInfoUpdateHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			//判断是否移除的是 1.5倍经验的buff
			if((evt.data as BuffItemInfo).templateId != doubleBuffId || !_sceneInfo || !_sceneInfo.playerList.self.getIsHangup())return;
			//			var item:ItemInfo;
			if(_sceneInfo.hangupData.autoDoubleExp)
			{
				var list:Array = GlobalData.bagInfo.getItemById(doubleExpId);//获取1.5倍经验加成符 并使用
				
				if(list.length > 0)
				{
					CellDoubleClickHandler.useItem(list[0]);
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_character.getBaseRoleInfo().removeEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,characterInfoUpdateHandler);
			_character.getBaseRoleInfo().removeEventListener(BaseRoleInfoUpdateEvent.REMOVEBUFF,buffInfoUpdateHandler);
		}
		
	}
}
