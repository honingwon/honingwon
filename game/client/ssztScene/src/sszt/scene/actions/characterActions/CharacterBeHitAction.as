package sszt.scene.actions.characterActions
{
	import sszt.core.action.BaseAction;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.scene.data.fight.AttackActionInfo;
	
	public class CharacterBeHitAction extends BaseCharacterAction
	{
		protected var _skill:SkillTemplateInfo;
		public function CharacterBeHitAction(info:AttackActionInfo)
		{
			super(info,0);
			_skill = SkillTemplateList.getSkill(info.skill);
			if(_skill && _skill.getBeAttackEffect(info.level)[1] > 0)
			{
				_playDelay = _skill.getBeAttackEffect(info.level)[1];
				_life = _playDelay + 9;
			}
		}
		
		override public function play():void
		{
			super.play();
			doBeHit();
		}
		
		protected function doBeHit():void
		{
		}
		
		protected function getAttackInfo():AttackActionInfo
		{
			return _actionInfo as AttackActionInfo;
		}
	}
}