package sszt.scene.actions
{
	import flash.utils.getTimer;
	
	import sszt.core.action.BaseAction;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.scene.SceneModule;
	import sszt.scene.checks.AttackChecker;
	import sszt.scene.components.sceneObjs.SelfScenePet;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;

	
	public class SelfPetAttackAction extends BaseAction
	{
		private var _self:SelfScenePet;
		private var _mediator:SceneMediator;
		private var _sceneModule:SceneModule;
		private var _checkTime:int = -1;
		private var _startDelay:int;
		private var _owner:BaseScenePlayerInfo;
		private var _startTime:Number;
		private static const START_DELAY:int = 14;
		
		public function SelfPetAttackAction(self:SelfScenePet, mediator:SceneMediator)
		{
			this._self = self;
			this._owner = this._self.getScenePetInfo().getOwner();
			this._mediator = mediator;
			this._sceneModule = this._mediator.sceneModule;
		}
		
		override public function configure(...parameters) : void
		{
			this._startDelay = 0;
			this._startTime = 0;
			GlobalAPI.tickManager.addTick(this);
		}
		
		override public function update(times:int, dt:Number = 0.04) : void
		{
			this._startDelay = this._startDelay + times;
			if (this._startDelay < START_DELAY) return;
			if (!this._self) return;
			if (!this._owner) return;
			if (getTimer() - this._startTime < 800) return;
			this._startTime = getTimer();
			var target:BaseRoleInfo = this._sceneModule.sceneInfo.getCurrentSelect();
			var petSkillInfo:PetSkillInfo = this.getSkill(target);
			if (target && petSkillInfo)
			{
				AttackChecker.petDoAttack(target, target.getObjType(), petSkillInfo);
			}
		} 
		
		private function getSkill(target:BaseRoleInfo) : PetSkillInfo
		{
			var petSkillInfo:PetSkillInfo = null;
			var petItemInfo:PetItemInfo = GlobalData.petList.getFightPet();
			if (!petItemInfo)
			{
				return null;
			}
			var skillList:Array = petItemInfo.hangupSkillList;
			if(!skillList || skillList.length ==0 )return null;
			for(var i:int = 0; i< skillList.length ; ++i)
			{
				if (skillList[i] && skillList[i].getCanUseSkill(this._owner, target))
				{
					petSkillInfo = skillList.splice(i, 1)[0];
					skillList.push(petSkillInfo);
					return petSkillInfo;
				}
			}
			return null;
		} 
		
		public function stop() : void
		{
			this._startDelay = 0;
			GlobalAPI.tickManager.removeTick(this);
		} 
		
		override public function dispose() : void
		{
			this.stop();
			this._self = null;
			this._owner = null;
			this._mediator = null;
			this._sceneModule = null;
			super.dispose();
		}
		
	}
}
