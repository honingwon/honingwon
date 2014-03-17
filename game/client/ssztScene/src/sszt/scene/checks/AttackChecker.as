/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-12-27 上午10:58:00 
 * 
 */ 
package sszt.scene.checks
{
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.PK.PKType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pet.PetAttackSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.actions.characterActions.PetAttackAction;
	import sszt.scene.actions.characterActions.PlayerAttackAction;
	import sszt.scene.actions.characterActions.PlayerWaitAttackAction;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.fight.AttackActionInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerAttackSocketHandler;

	public class AttackChecker
	{
		private static var _mediator:SceneMediator;
		private static var _sceneInfo:SceneInfo;
		
		
		public function AttackChecker()
		{
		}
		
		public static function setup(mediator:SceneMediator) : void
		{
			_mediator = mediator;
			_sceneInfo = _mediator.sceneInfo;
		}
		
		
		public static function doAttack(role:BaseRoleInfo, type:int, skill:SkillItemInfo = null, targetPos:Point = null) : void
		{
			var self:SelfScenePlayerInfo;
			var targetX:int;
			var targetY:int;
			var targetId:Number;
			var template:SkillTemplateInfo;
			self = _sceneInfo.playerList.self;
			if(self.getIsReady())return;
			
			if (targetPos)
			{
				targetX = targetPos.x;
				targetY = targetPos.y;
			}
			else
			{
				if (!role)
				{
					role = _sceneInfo.getCurrentSelect();
				}
				if (role)
				{
					targetX = role.sceneX;
					targetY = role.sceneY;
					if (role is BaseSceneMonsterInfo)
					{
						if (role.currentHp >= 1000000000)
						{
							if (self.getIsHangup())
							{
								_sceneInfo.setCurrentSelect(null);
							}
							return;
						}
						type = (role as BaseSceneMonsterInfo).getObjType();
					}
					else
					{
						type = role.getObjType();
					}
					
				}
			}
			targetId = role != null ? role.getObjId() : 0;
			
			if (skill == null)
			{
				skill = GlobalData.skillInfo.getDefaultSkill();
			}
			if (skill == null){
				return;
			}
			template = skill.getTemplate();
			if (template.isAttack() && !role && !targetPos && !template.unNeedTarget()){
				return;
			}
			
			if (template.unNeedTarget())
			{
				targetX = self.sceneX;
				targetY = self.sceneY;
				type = MapElementType.PLAYER;
			}
			
			if (role && template.isAttack())
			{
				if (!role.getCanAttack())
				{
					return;
				}
				if (MapElementType.isPlayer(type)){
					if (template.isActive()){
						if (role){
							if (!checkPlayerCanBeAttack(BaseScenePlayerInfo(role), true))
							{
								if (self.getIsHangup())
								{
									_sceneInfo.setCurrentSelect(null);
								}
								return;
							}
						}
						
					}
				}
			}
			
			
			
			
//			if (skill == null)
//			{
//				skill = GlobalData.skillInfo.getDefaultSkill();
//			}
//			if(skill == null)return;
//			template = skill.getTemplate();
//			if (template.isAttack())
//			{
//				template.isAttack();
//			}
//			
//			if (template.unNeedTarget())
//			{
//				targetX = self.sceneX;
//				targetY = self.sceneY;
//				type = MapElementType.PLAYER;
//			}
//	
//			if(MapElementType.isPlayer(type))
//			{
//				if(!role.getCanAttack())return;
//				if(!checkPlayerCanBeAttack(BaseScenePlayerInfo(role),false) && skill.getTemplate().activeType == 0)return;
//			}
//			
//			if(self.getIsDeadOrDizzy())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.scene.unOperateInHitDownState"));
//				return;
//			}
			
			
			//坐着的话，站起
			if(self.info.isSit())
			{
				_mediator.selfSit(false);
			}
			
			var range:int = int(skill.getTemplate().range[skill.level - 1]) - 25;
			if(range < 75)range = 75;
			_sceneInfo.clearSkill();
			if(template.isAssist() && Point.distance(new Point(targetX, targetY), new Point(self.sceneX, self.sceneY)) < range)
			{
				attack();
			}
			else
			{
				_mediator.walk(_sceneInfo.getSceneId(),new Point(targetX, targetY),attack,range,false);
			}
			
			function attack():void
			{
				if(skill.getCanUse() && getCanUse())
				{
					if(!self || !_mediator.sceneModule.sceneInit.playerListController.getSelf())return;
					//					//下马
					//					if(self.getIsMount())
					//					{
					//						PlayerSetHouseSocketHandler.send(false);
					//					}
					_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
					//自己先播放动画
					var actionInfo:AttackActionInfo = new AttackActionInfo();
					actionInfo.actorId = GlobalData.selfPlayer.userId;
					actionInfo.targetX = targetX;
					actionInfo.targetY = targetY;
					actionInfo.actorType = MapElementType.PLAYER;
					actionInfo.skill = skill.templateId;
					actionInfo.level = skill.level;
					if(skill.getTemplate().getPrepareTime(skill.level) > 0)
					{
						self.addAction(new PlayerWaitAttackAction(actionInfo));
					}
					else
					{
						self.addAction(new PlayerAttackAction(actionInfo));
					}
					skill.isInCommon = false;
					//技能时间
					skill.lastUseTime = GlobalData.systemDate.getSystemDate().getTime();
					if(!skill.getTemplate().isDefault)
					{
						for each(var i:SkillItemInfo in GlobalData.skillInfo.getSkills())
						{
							if(i != skill)i.isInCommon = true;
							i.setCommonCD();
						}
					}
					PlayerAttackSocketHandler.sendAttack(targetId,type,skill.templateId,targetX,targetY);
				}
			}
			
			function getCanUse():Boolean
			{
				if(skill.getTemplate().activeType == 0)
				{
					if(MapElementType.isPlayer(type) && !checkPlayerCanBeAttack(BaseScenePlayerInfo(role),false))return false;
					return true;
				}
				//辅助技能
				
				if(GlobalData.canUseAssist && MapElementType.isPlayer(type) && skill.getTemplate().activeType == 2)return true;
				return false;
			}
		}
		
		
		public static function petDoAttack(role:BaseRoleInfo, type:int, skill:PetSkillInfo = null) : void
		{
			var fightPet:PetItemInfo;
			var self:BaseScenePetInfo;
			var targetId:Number;
			var targetX:int;
			var targetY:int;
			var template:SkillTemplateInfo;
			var type:int = type;
			
			if (role == null) return;
			fightPet = GlobalData.petList.getFightPet();
			if (!fightPet) return;
			self = _sceneInfo.petList.self;
			if (!self) return;
			var owner:BaseScenePlayerInfo = _sceneInfo.playerList.getPlayer(self.owner);
			if (!owner)
			{
				return;
			}
			targetId = role.getObjId();
			targetX = role.sceneX;
			targetY = role.sceneY;
			if (skill == null)
			{
				skill = fightPet.defaultSkill;
			}
			if (!skill) return;
			template = skill.getTemplate();
			if (template.isAttack())
			{
				template.isAttack();
			}
//			if (!MapTemplateList.canAttack(GlobalData.currentMapId))
//			{
//				return;
//			}
			if (!role.getCanAttack()) return;
//			if (role is BaseSceneMonsterInfo)
//			{
//				type = (role as BaseSceneMonsterInfo).template.server_monster_type;
//			}
			if (MapElementType.isPlayer(type))
			{
				if (role && !checkPlayerCanBeAttack(BaseScenePlayerInfo(role), false))
				{
					return;
				}
				
			}
			var range:int = int(template.range[(skill.level - 1)]);
			if (Point.distance(new Point(targetX, targetY), new Point(owner.sceneX, owner.sceneY)) <= range)
			{
				attack();
			}
			
			function attack() : void
			{
				if (!fightPet) return;
				//				if (!MapElementType.isPlayer(type))
				//				{
				//					if (template.isAssist())
				//					{
				//						return;
				//					}
				//				}
				
				var actionInfo:AttackActionInfo = AttackActionInfo.getAttackActionInfo();
				actionInfo.actorId = GlobalData.selfPlayer.userId;
				actionInfo.targetX = targetX;
				actionInfo.targetY = targetY;
				actionInfo.actorType = MapElementType.PET;
				actionInfo.skill = skill.templateId;
				actionInfo.level = skill.level;
				actionInfo.actionType = 1;
				self.addAction(new PetAttackAction(actionInfo));
				skill.isInCommon = false;
				skill.lastUseTime =  GlobalData.systemDate.getSystemDate().getTime();
				
				fightPet.setSkillCDExcept(skill);
				
				
				PetAttackSocketHandler.sendAttack(targetId, type, skill.templateId, targetX, targetY);
			}
		}
		
		
		public static function checkPlayerCanBeAttack(player:BaseScenePlayerInfo,showTip:Boolean = true):Boolean
		{
			if(!_sceneInfo.playerList.self)return false;
			var self:SelfPlayerInfo = GlobalData.selfPlayer;
			if(_sceneInfo.attackList.attackList.indexOf(player.info.userId) != -1)
			{
				return true;
			}
			if(_sceneInfo.mapInfo.getIsSafeArea())return false;
			if(_sceneInfo.mapInfo.isShenmoDouScene())
			{
				return player.warState != _sceneInfo.playerList.self.warState;
			}
			else if(_sceneInfo.mapInfo.isAcrossServer())
			{
				return true;// player.info.serverId != GlobalData.selfPlayer.serverId;
			}
			else if(GlobalData.copyEnterCountList.isPKCopy())
			{
				if(getTimer() - GlobalData.copyEnterCountList.pkEnterTime < 10000) return false;
				return true;
			}
			else
			{
				if(!GlobalData.selfPlayer.isClubEnemy(player.info.clubId))
				{
					if(self.PKMode == PKType.PEACE)
					{
						if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unattackInPeaceMode"));
						return false;
					}
					if(player.info.PKMode == PKType.PEACE)
					{
						if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unPKInPeaceMode"));
						return false;
					}
				}
				if(self.PKMode == PKType.GOODNESS && player.info.PKValue <= 10)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackNotRedName"));
					return false;
				}
				if(self.PKMode == PKType.TEAM && _sceneInfo.teamData.getPlayer(player.info.userId) != null)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackInSameTeam"));
					return false;
				}
				if(self.PKMode == PKType.CLUB && player.info.clubId == self.clubId)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackInSameClub"));
					return false;
				}
				//				if(self.PKMode == PKType.CAMP && player.info.camp == self.camp)
				//				{
				//					if(showTip)QuickTips.show("对方和您处于同一个阵营，无法攻击！");
				//					return false;
				//				}
				if(self.PKMode == PKType.CAMP && player.info.camp == self.camp)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackInSameCmp"));
					return false;
				}
				if(self.level < 30)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackSelfLevelLow30"));
					return false;
				}
				if(player.info.level < 30)
				{
					if(showTip)QuickTips.show(LanguageManager.getWord("ssztl.scene.unAttackPlayerLevelLow30"));
					return false;
				}
			}
			return true;
		}
		
		
		public static function gotoNextLayer():void{
			var count:int;
			var hasMonster:Boolean;
			var monster:BaseSceneMonsterInfo;
			var timeoutIndex:uint;
			var addMonsterHandler:Function;
			if (!_sceneInfo)
			{
				return;
			}
			if (_sceneInfo.playerList.self){
				count = 0;
				hasMonster = false;
				for each (monster in _sceneInfo.monsterList.getMonsters()) {
					if (monster){
						hasMonster = true;
						break;
					}
				}
				if (hasMonster){
					_mediator.setHangup(true);
				}
				else {
					addMonsterHandler = function (evt:SceneMonsterListUpdateEvent):void{
						timeoutFunction();
					}
					var timeoutFunction:Function = function ():void{
						if (timeoutIndex > 0){
							clearTimeout(timeoutIndex);
						}
						_sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER, addMonsterHandler);
						_mediator.setHangup(true);
					}
					_sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER, addMonsterHandler, false, 0, true);
					timeoutIndex = setTimeout(timeoutFunction, 3000);
				}
			}
		}
		
		
		public static function attackMonster():void{
			if (_sceneInfo.playerList.self){
				_sceneInfo.hangupData.attackIndex++;
				_sceneInfo.playerList.self.setHangupState();
			}
		}
		public static function attackMonster2():void{
			if (_sceneInfo.playerList.self){
				_sceneInfo.playerList.self.setHangupState();
			}
		}
		
		public static function attackMonster3():void{
			if (_sceneInfo.playerList.self)
			{
				if (_sceneInfo.hangupData.attackIndex < 4){
					_sceneInfo.hangupData.attackIndex++;
				}
				_sceneInfo.playerList.self.setHangupState();
			}
		}

		
		
	}
}