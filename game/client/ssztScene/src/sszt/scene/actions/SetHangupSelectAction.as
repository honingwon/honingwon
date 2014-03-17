package sszt.scene.actions
{
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.utils.CellDoubleClickHandler;
	import sszt.scene.actions.characterActions.BaseCharacterAction;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.dropItem.DropItemInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.mediators.SceneMediator;
	
	public class SetHangupSelectAction extends BaseCharacterAction
	{
		private var _targetTemplateId:int;
		private var _sceneInfo:SceneInfo;
		private var _mediator:SceneMediator;
		private var _hasDispose:Boolean;
		private var doubleBuffId:int = 716501;
		private var doubleExpId:int = 101026;
		
		public function SetHangupSelectAction(character:BaseRole,mediator:SceneMediator)
		{
			_mediator = mediator;
			super(null,0);
			setCharacter(character);
			_character.getBaseRoleInfo().addEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,characterInfoUpdateHandler);
			_character.getBaseRoleInfo().addEventListener(BaseRoleInfoUpdateEvent.REMOVEBUFF,buffInfoUpdateHandler);
		}
		
		override public function configure(...parameters):void
		{
			_hadDoPlay = false;
			isFinished = false;
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			super.play();
			_sceneInfo = getSceneInfo();
			if(!_sceneInfo.playerList.self.getIsHangup())
			{
				isFinished = true;
				return;
			}
			var doInEndPickup:Boolean;
			//检测是否原地挂机
			var selfPoint:Point = new Point(_sceneInfo.playerList.self.sceneX,_sceneInfo.playerList.self.sceneY);
			var stopTick:Boolean = true;
			//检测是否需要捡东西，挂机
			var item:DropItemInfo;
			var pickup:Boolean = false;
			
			if(_mediator.sceneInfo.hangupData.autoDoubleExp)
			{
				var buff:BuffItemInfo = GlobalData.selfScenePlayerInfo.getBuff(doubleBuffId);
				if(buff == null)
				{
					var list:Array = GlobalData.bagInfo.getItemById(doubleExpId);//获取1.5倍经验加成符 并使用					
					if(list.length > 0)
					{
						CellDoubleClickHandler.useItem(list[0]);
					}
				}
			}
				
			if(GlobalData.bagInfo.getHasPos(1))
			{
				var equipQualitys:Array = _sceneInfo.hangupData.getEquipQualityPicks();
				if(equipQualitys && equipQualitys.length > 0)
				{
					item = _sceneInfo.dropItemList.getOneEquipCanPickByQuality(equipQualitys);
					if(item && _mediator.sceneInfo.hangupData.localHangup && item.getDistance(selfPoint) > CommonConfig.PICKUP_RADIUS)
					{
						item = null;
					}
				}
				if(!item)
				{
					var otherQualitys:Array = _sceneInfo.hangupData.getOtherQualityPicks();
					if(otherQualitys && otherQualitys.length > 0)
					{
						item = _sceneInfo.dropItemList.getOneOtherCanPickByQuality(otherQualitys);
						if(item && _mediator.sceneInfo.hangupData.localHangup && item.getDistance(selfPoint) > CommonConfig.PICKUP_RADIUS)
						{
							item = null;
						}
					}
				}
				if(item)
				{
					if(!_mediator.sceneInfo.hangupData.localHangup)
					{
						doInEndPickup = true;
						pickup = true;
					}
					else
					{
						_mediator.pickup(item.id);
						//原地捡道具，一直捡到全部捡完，然后执行打怪
						stopTick = false;
					}
				}
			}
			if(!pickup)
			{
				var targets:Array = _sceneInfo.hangupData.monsterList;
				if(MapTemplateList.isGuardDuplicate())//守护副本挂机
				{
					var currentSelected2:BaseRoleInfo = _sceneInfo.getCurrentSelect();
					var monster2:BaseSceneMonsterInfo;
					if(currentSelected2)
					{
						if(currentSelected2.getObjType() == MapElementType.MONSTER && targets.indexOf((currentSelected2 as BaseSceneMonsterInfo).templateId) != -1)
							monster2 = currentSelected2 as BaseSceneMonsterInfo;
						else
							_sceneInfo.setCurrentSelect(null);
					}
					if(!monster2)
					{
						monster2 = _sceneInfo.monsterList.getNearlyMonster(new Point(_character.sceneX,_character.sceneY));	
						if(monster2 && _sceneInfo.hangupData.attackPath.length > 0)
						{
							if(_sceneInfo.hangupData.attackIndex == 0)
							{
								if(monster2.getDistance(new Point(_character.sceneX,_character.sceneY)) > 400)monster2 = null;
							}
							else if(_sceneInfo.hangupData.attackIndex != _sceneInfo.hangupData.attackPath.length)
							{
								if(monster2.getDistance(_sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex - 1]) > 400)monster2 = null;
							}
							
						}
					}
					if(monster2 == null)
					{
						var num:int =  _sceneInfo.monsterList.getGuarderNum();							
						if(num > 4)
							_sceneInfo.hangupData.attackIndex = 0;
						else if(num == 0)
							_sceneInfo.hangupData.attackIndex = 2;
						else 
							_sceneInfo.hangupData.attackIndex = 1;
						if(_sceneInfo.hangupData.attackIndex < _sceneInfo.hangupData.attackPath.length)
						{
							_mediator.walk(_sceneInfo.mapInfo.mapId,_sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex],attackMonster3);
							function attackMonster3():void
							{									
								if(_sceneInfo.playerList.self)
								{										
									_sceneInfo.playerList.self.setHangupState();
								}
							}
						}
					}
					else if(_mediator.sceneInfo.hangupData.autoFight)
					{
						//打怪
						_sceneInfo.setCurrentSelect(monster2);
					}
				}
				else if(targets.length > 0)
				{
					var currentSelected:BaseRoleInfo = _sceneInfo.getCurrentSelect();
					var monster:BaseSceneMonsterInfo;
					if(currentSelected)
					{
						if(currentSelected.getObjType() == MapElementType.MONSTER && targets.indexOf((currentSelected as BaseSceneMonsterInfo).templateId) != -1)
							monster = currentSelected as BaseSceneMonsterInfo;
						else
							_sceneInfo.setCurrentSelect(null);
					}
					if(!monster)
					{
						monster = _sceneInfo.monsterList.getNearlyMonsterByType(targets,new Point(_character.sceneX,_character.sceneY));
//						if(monster && _sceneInfo.hangupData.attackPath.length > 0)
//						{
////							if(_sceneInfo.hangupData.attackIndex == 0)
////							{
////								if(monster.getDistance(new Point(_character.sceneX,_character.sceneY)) > 300)monster = null;
////							}
////							else if(_sceneInfo.hangupData.attackIndex != _sceneInfo.hangupData.attackPath.length)
////							{
////								if(monster.getDistance(_sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex - 1]) > 300)monster = null;
////							}
//						}
					}
					if(monster && _mediator.sceneInfo.hangupData.localHangup && monster.getDistance(selfPoint) > getLongestSkill())
					{
						stopTick = false;
						monster = null;
					}
					if(monster == null)
					{
						//寻路找怪(发事件)
						//先把挂机状态去掉，等到跑到终点再将状态改回来，避免在跑路过程中添加新怪而出现半路就选中怪
						if(!_sceneInfo.hangupData.localHangup)
						{
//							if(MapTemplateList.isTraining())return;
							_sceneInfo.playerList.self.clearHangup();
							if(MapTemplateList.isShenMoIsland())
							{
								if(_mediator.sceneModule.copyIslandInfo.cIMainInfo)
								{
									var mapId:int = GlobalData.currentMapId + 1;
									if(MapTemplateList.getMapTemplate(mapId))
									{
										var p:Point = MapTemplateList.getMapTemplate(mapId).defalutPoint;
										_mediator.walk(mapId,p,attackMonster1);
									}									
									function attackMonster1():void
									{
										if(_sceneInfo.playerList.self)
										{
											_mediator.setHangup(true);
										}
									}
								}
							}
							else if(_sceneInfo.hangupData.attackPath.length > 0)
							{
								if(_sceneInfo.hangupData.attackIndex < _sceneInfo.hangupData.attackPath.length)
								{
									_mediator.walk(_sceneInfo.mapInfo.mapId,_sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex],attackMonster);
									
									function attackMonster():void
									{
										if(_sceneInfo.mapInfo.getIsCopy())
										{
											var p:Point = _sceneInfo.hangupData.attackPath[_sceneInfo.hangupData.attackIndex];
											var doors:Array = DoorTemplateList.sceneDoorList[_sceneInfo.mapInfo.mapId];
											for each(var door:DoorTemplateInfo in doors)
											{												
												if(p.x == door.sceneX && p.y == door.sceneY)
												{
//													_mediator.gotoScene(door.templateId);
													var nextp:Point = MapTemplateList.getMapTemplate(door.nextMapId).defalutPoint;
													_mediator.walk(door.nextMapId,nextp,attackMonster2);
													_sceneInfo.hangupData.attackIndex = _sceneInfo.hangupData.attackPath.length;
													break;
												}													
											}
										}
										function attackMonster2():void
										{
											if(_sceneInfo.playerList.self)
											{
												_mediator.setHangup(true);
											}
										}
										if(_sceneInfo.playerList.self)
										{
											_sceneInfo.hangupData.attackIndex += 1;
											_sceneInfo.playerList.self.setHangupState();
										}
									}
								}
							}
							else
							{
								this._mediator.walkToHangup(targets[0], false);
//								_mediator.walkToHangup(targets[0],_mediator.sceneInfo.hangupData.monsterNeedCount,_mediator.sceneInfo.hangupData.autoFindTask);
							}
						}
					}
					else if(_mediator.sceneInfo.hangupData.autoFight)//添加自动打怪功能
					{
						//打怪
						_sceneInfo.setCurrentSelect(monster);
					}
				}
				else if(MapTemplateList.isMoneyDuplicate())// 打钱副本
				{
					var currentSelected1:BaseRoleInfo = _sceneInfo.getCurrentSelect();
					var monster1:BaseSceneMonsterInfo;
					if(currentSelected1 && currentSelected1.getObjType() == MapElementType.MONSTER && targets.indexOf((currentSelected1 as BaseSceneMonsterInfo).templateId) != -1)
					{
						monster1 = currentSelected1 as BaseSceneMonsterInfo;
					}
					if(!monster1)
					{
						monster1 = _sceneInfo.monsterList.getNearlyMonsterByType([200201,200202,200203,200204,200205,200206,200207,200208,200209,2002010],new Point(_character.sceneX,_character.sceneY));						
					}
					if(monster1 && _mediator.sceneInfo.hangupData.autoFight)
					{
						//打怪
						_sceneInfo.setCurrentSelect(monster1);
					}
				}
			}
			
			if(stopTick)
			{
				isFinished = true;
			}
			//在最后调，因为setHangup可能马上执行到回调，先把isFinished设为false,然后继续执行本函数又被设为true,使得挂机停止
			//在捡物品叠加时会出现
			if(doInEndPickup && item)
			{
				_mediator.sceneInfo.playerList.self.setHangupPickup();
				_mediator.walkToPickup(item.id,item.sceneX,item.sceneY,_mediator.setHangup,false);
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
		
		public function getLongestSkill():int
		{
			var result:int = 0;
			if(_mediator.sceneInfo.playerList.self.getIsHangupAttack())
			{
				var list:Array = _mediator.sceneInfo.hangupData.skillList;
				if(list)
				{
					for each(var i:SkillItemInfo in list)
					{
						if(i && i.getCanUse())
						{
							var radius:int = i.getTemplate().getRange(i.level);
							if(radius > result)
								result = radius;
						}
					}
				}
			}
			return result;
		}
		
		public function getSceneInfo():SceneInfo
		{
			return _character.scene.mapData as SceneInfo;
		}
		
		override public function managerClear():void
		{
		}
		
		override public function dispose():void
		{
			if(_hasDispose)return;
			_hasDispose = true;
			_character.getBaseRoleInfo().removeEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,characterInfoUpdateHandler);
			_character.getBaseRoleInfo().removeEventListener(BaseRoleInfoUpdateEvent.REMOVEBUFF,buffInfoUpdateHandler);
			super.dispose();
		}
	}
}