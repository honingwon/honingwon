package sszt.scene.actions
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import sszt.core.action.BaseAction;
	import sszt.core.action.IActionManager;
	import sszt.core.data.GlobalData;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.scene.SceneModule;
	import sszt.scene.checks.AttackChecker;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.mediators.SceneMediator;
	
	/**
	 * 连续攻击
	 * @author Administrator
	 * 
	 */	
	public class SelfAttackAction extends BaseAction
	{
//		private var _target:BaseRoleInfo;
		private var _self:SelfScenePlayer;
		private var _sceneModule:SceneModule;
		private var _mediator:SceneMediator;
		private var _checkTime:int;
		
		public function SelfAttackAction(self:SelfScenePlayer,mediator:SceneMediator)
		{
			_self = self;
			_mediator = mediator;
			_sceneModule = _mediator.sceneModule;
			super(0);
		}
		
		override public function configure(...parameters):void
		{
			isFinished = false;
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			var target:BaseRoleInfo = getTarget();
			if(!(target && target.getCanAttack()))
			{
				if(_checkTime == -1)_checkTime = getTimer();
				if(_mediator.sceneInfo.playerList.self.getIsHangupAttack())
				{
					if(getTimer() - _checkTime > 2000)
					{
						_self.startHangup();
						_checkTime = -1;
					}
				}
//				isFinished = true;
				return;
			}
			_checkTime = -1;
			if(_self.getScenePlayerInfo().getIsDeadOrDizzy())return;
			var skill:SkillItemInfo = getSkill(target);
			if(skill)
			{
				if(skill.getCanUse())
				{
//					isFinished = true;
					if(_sceneModule.sceneInit.playerListController.getSelf().isMoving)return;
					AttackChecker.doAttack(target,target.getObjType(),skill);
					
//					_mediator.attack(target,target.getObjType(),skill);
//					_mediator.sceneInfo.clearSkill();
				}
			}
//			else
//			{
//				isFinished = true;
//			}
		}
		
		private function getTarget():BaseRoleInfo
		{
			return _sceneModule.sceneInfo.getCurrentSelect();
		}
		
		private function getSkill(target:BaseRoleInfo):SkillItemInfo
		{
			var selfPoint:Point = new Point(_self.sceneX,_self.sceneY);
//			if(_mediator.sceneInfo.selectSkill)
//			{
//				var t:SkillItemInfo = _mediator.sceneInfo.selectSkill;
//				_mediator.sceneInfo.selectSkill = null;
//				return t;
//			}
			var selectSkill:SkillItemInfo = _mediator.sceneInfo.getSkill();
			if(selectSkill)
			{
				if(selectSkill.getCanUse())return selectSkill;
			}
			if(_mediator.sceneInfo.playerList.self.getIsHangupAttack())
			{
//				var list:Vector.<SkillItemInfo> = _mediator.sceneInfo.hangupData.skillList;
				var list:Array = _mediator.sceneInfo.hangupData.skillList;
				if(list)
				{
					for each(var i:SkillItemInfo in list)
					{
						if(i && i.getCanUse())
						{
							if(!_mediator.sceneInfo.hangupData.localHangup)
								return i;
							else
							{
								if(target.getDistance(selfPoint) <= i.getTemplate().getRange(i.level))
									return i;
							}
						}
					}
				}
			}
			var defaultSkill:SkillItemInfo = GlobalData.skillInfo.getDefaultSkill();
			if(defaultSkill && _mediator.sceneInfo.playerList.self.getIsHangupAttack() && _mediator.sceneInfo.hangupData.localHangup)
			{
				if(target.getDistance(selfPoint) > defaultSkill.getTemplate().getRange(defaultSkill.level))
					defaultSkill = null;
			}
			return defaultSkill;
		}
	}
}