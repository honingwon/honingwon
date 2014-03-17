package sszt.scene.actions.characterActions
{
	import sszt.core.action.BaseAction;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.interfaces.character.ICharacter;
	import sszt.scene.data.fight.AttackActionInfo;
	
	public class CharacterAttackAction extends BaseCharacterAction
	{
		
		protected var _skill:SkillTemplateInfo;
		
		public function CharacterAttackAction(info:AttackActionInfo)
		{
			super(info,0);
			_skill = SkillTemplateList.getSkill(info.skill);
			if(_skill && _skill.getActionEffect()[0] > 0)
			{
				_playDelay = _skill.getActionEffect()[1];
			}
			else if(_skill)
			{
				_playDelay = _skill.getAttackEffect(info.level)[1];
			}
			
		}
		
		override public function play():void
		{
			super.play();
			doAttack();
		}
		
		public function doAttack():void
		{
		}
		
		override public function dispose():void
		{
			
			_skill = null;
			super.dispose();
		}
	}
}