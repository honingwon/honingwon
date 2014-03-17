package sszt.scene.socketHandlers
{
	import flash.events.ProgressEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.player.BasePlayerInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.PlayerState;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.characterActions.BaseCharacterAction;
	import sszt.scene.actions.characterActions.MonsterAttackAction;
	import sszt.scene.actions.characterActions.MonsterBehitAction;
	import sszt.scene.actions.characterActions.PetAttackAction;
	import sszt.scene.actions.characterActions.PlayerAttackAction;
	import sszt.scene.actions.characterActions.PlayerBehitAction;
	import sszt.scene.components.sceneObjs.BaseScenePet;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.fight.AttackActionInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TargetAttackedUpdateSocketHandler extends BaseSocketHandler
	{
		public function TargetAttackedUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TARGET_ATTACKED_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var actorType:int = _data.readByte();
			var actorId:Number = _data.readNumber();
			var skill:int = _data.readInt();
			var level:int = _data.readByte();
			var targetX:int = _data.readInt();
			var targetY:int = _data.readInt();
			var attackState:uint = _data.readUnsignedInt();
			var actionInfoLen:int = _data.readInt();
			var action:AttackActionInfo;
			var selected:BaseRoleInfo = sceneModule.sceneInfo.getCurrentSelect();
			var monster:BaseSceneMonsterInfo;
			var targetState:uint;
			var tmpPet:BaseScenePetInfo;
			var playerObj:BaseScenePlayer;
			var petObj:BaseScenePet;
			var stateChange:Boolean = true;
			for(var i:int = 0; i < actionInfoLen; ++i)
			{
				action = new AttackActionInfo();
				action.actorId = actorId;
				action.targetX = targetX;
				action.targetY = targetY;
				action.actorType = actorType;
				action.skill = skill;
				action.level = level;
				action.targetId = _data.readNumber();
				action.targetType = _data.readByte();
				
				
				var player:BaseRoleInfo = sceneModule.sceneInfo.getRoleInfo(action.targetType,action.targetId);
				
				
				var len:int = _data.readByte();
				
				for(var k:int = 0; k < len; ++k)
				{
					action.hp = _data.readInt();
					action.mp = _data.readInt();
					if (player)
					{
						action.dhp.push(action.hp - player.currentHp);
						action.dmp.push(action.mp - player.currentMp);
						player.currentHp = action.hp;
						player.currentMp = action.mp;
					}
				}
				action.attackResultType = _data.readShort();
				if (action.targetId == actorId){
					stateChange = false;
				}
				
				targetState = _data.readUnsignedInt();
				
				if(player)
				{
					if (MapElementType.isPlayer(player.getObjType()) && player.getObjId() == GlobalData.selfPlayer.userId)
					{
						if (selected == null && SkillTemplateList.getSkill(skill).isAttack())
						{
							if (MapElementType.isMonster(actorType)){
								monster = sceneInfo.monsterList.getMonster(actorId);
								if (monster)
								{
									this.sceneInfo.setCurrentSelect(this.sceneInfo.getRoleInfo(actorType, actorId));
								}
							} 
							else 
							{
								if (MapElementType.isPet(actorType))
								{
									tmpPet = this.sceneInfo.petList.getPet(actorId);
									if (tmpPet)
									{
										this.sceneInfo.setCurrentSelect(tmpPet.getOwner());
									}
								} 
								else 
								{
									this.sceneInfo.setCurrentSelect(this.sceneInfo.getRoleInfo(actorType, actorId));
									
								}
							}
						} 
						else 
						{
							if (this.sceneInfo.playerList.self.getIsCommon() && SkillTemplateList.getSkill(skill).isAttack())
							{
								if (MapElementType.isPet(actorType) && this.sceneInfo.petList.getPet(actorId))
								{
									this.sceneInfo.setCurrentSelect(this.sceneInfo.petList.getPet(actorId).getOwner());
								} 
								else 
								{
									this.sceneInfo.setCurrentSelect(this.sceneInfo.getRoleInfo(actorType, actorId));
								}
							}
						}
						this.sceneModule.facade.sendNotification(SceneMediatorEvent.SELF_BEHIT);
						playerObj = this.sceneModule.sceneInit.playerListController.getPlayer(actorId);
						if (playerObj){
							playerObj.setFigureVisible(true);
						}
						petObj = this.sceneModule.sceneInit.petListController.getPetByOwner(actorId);
						if (petObj)
						{
							petObj.setFigureVisible(true);
						}
					}
					
				}
				
				
				
				var ac:BaseCharacterAction = getAction(action.targetType,action,false);
				if(player && ac)
				{
					action.actorName = player.getName();
//					trace("==="+targetState);
					player.setAttackState(targetState);
					player.addAction(ac);
					if(sceneModule.sceneInfo.teamData.getPlayer(action.targetId) != null)
					{
						sceneModule.sceneInfo.teamData.getPlayer(action.targetId).currentHp = player.currentHp;
						sceneModule.sceneInfo.teamData.getPlayer(action.targetId).currentMp = player.currentMp;
					}
					
					var buffLen:int = _data.readShort();
					for(var j:int = 0; j < buffLen; j++)
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
							player.removeBuff(buffId);
						}
					}
					if(MapElementType.isPlayer(player.getObjType()) && player.getObjId() == GlobalData.selfPlayer.userId)
					{
						if(selected == null && SkillTemplateList.getSkill(skill).activeSide == 0)
						{
							sceneModule.sceneInfo.setCurrentSelect(sceneModule.sceneInfo.getRoleInfo(actorType,actorId));
						}
						sceneModule.facade.sendNotification(SceneMediatorEvent.SELF_BEHIT);
					}
				}
				else 
				{
//					if(player)
//					{
//						player.currentHp = action.hp;
//						player.currentMp = action.mp;
//					}
					var buffLen1:int = _data.readShort();
					for(k = 0; k < buffLen1; k++)
					{
						_data.readInt();
						if(_data.readBoolean())
						{
							_data.readNumber();
							_data.readBoolean();
							_data.readDate64();
							_data.readInt();
						}
					}
				}
			}
			var attackAction:AttackActionInfo = new AttackActionInfo();
			attackAction.actorId = actorId;
			attackAction.targetX = targetX;
			attackAction.targetY = targetY;
			attackAction.actorType = actorType;
			attackAction.skill = skill;
			attackAction.level = level;
			var actor:BaseRoleInfo = sceneModule.sceneInfo.getRoleInfo(actorType,actorId);
			if(actor)
			{
//				if (stateChange){
//					trace(attackState);
//					actor.setAttackState(attackState);
//				}
				
				attackAction.actorName = actor.getName();
				actor.setAttackState(2);
				if(actor == sceneModule.sceneInfo.playerList.self)
				{
					if(SkillTemplateList.getSkill(attackAction.skill).getPrepareTime(attackAction.level) > 0)
					{
						var ac2:BaseCharacterAction = getAction(actorType,attackAction,true);
						actor.addAction(ac2);
					}
					if(!actor.getIsReady())
					{
						if(SkillTemplateList.getSkill(attackAction.skill).isAttack())
						{
							sceneModule.facade.sendNotification(SceneMediatorEvent.SELF_HIT);
						}
					}
				}
				else
				{
					var ac1:BaseCharacterAction = getAction(actorType,attackAction,true);
					actor.addAction(ac1);
				}
			}
			
			if(selected && selected.currentHp <= 0)
			{
				if(sceneModule.sceneInfo.playerList.self.getIsKillOne())
				{
					sceneModule.sceneInfo.playerList.self.clearHangup();
				}
			}
			
			handComplete();
		}
		
		public function getAction(type:int,info:AttackActionInfo,isAttack:Boolean):BaseCharacterAction
		{
			if(isAttack)
			{
				if(MapElementType.isMonster(type))
				{
					return new MonsterAttackAction(info);
				}
				else if(MapElementType.isPlayer(type))
				{
					return new PlayerAttackAction(info);
				}
				else if(MapElementType.isPet(type))
				{
					return new PetAttackAction(info);
				}
			}
			else
			{
				if(MapElementType.isMonster(type))
				{
					return new MonsterBehitAction(info);
				}
				else if(MapElementType.isPlayer(type))
				{
					return new PlayerBehitAction(info);
				}
			}
			return null;
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public function get sceneInfo():SceneInfo{
			return this.sceneModule.sceneInfo;
		}
		
	}
}