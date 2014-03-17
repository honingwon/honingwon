package sszt.core.view.tips
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.mounts.mountsSkill.MountsSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	
	public class MountsSkillItemTip extends SkillItemTip
	{
		private var _mountsSkillInfo:MountsSkillInfo;
		private var _skillName:String;
		private var _skillLevel:int;
		
		public function MountsSkillItemTip()
		{
			super();
		}
		
		public function setMountsSkillIteminfo(mountsSkillInfo:MountsSkillInfo):void
		{
			if(mountsSkillInfo == null)return;
			_mountsSkillInfo = mountsSkillInfo;
			_skillLevel = _mountsSkillInfo.level;
			_skillName = _mountsSkillInfo.getTemplate().name;
			
			super.setSkillIteminfo(_mountsSkillInfo as SkillItemInfo);
		}
		
		override protected function addEffectToField(level:int):void
		{
			addStringToField(_mountsSkillInfo.getEffectToString(level),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
		}
		
		override protected function addNameToField():void
		{
			var skillNamePre:String;
			switch(_skillLevel)
			{
				case 1 :
					skillNamePre = LanguageManager.getWord('ssztl.common.primary');
					break;
				case 2 :
					skillNamePre = LanguageManager.getWord('ssztl.common.intermediate');
					break;
				case 3 :
					skillNamePre = LanguageManager.getWord('ssztl.common.advanced');
					break;
				case 4 :
					skillNamePre = LanguageManager.getWord('ssztl.common.superfine');
					break;
				case 5 :
					skillNamePre = LanguageManager.getWord('ssztl.common.topLevel');
					break;
			}
			
			//技能名字0xFF5300
			addStringToField(skillNamePre + _skillName , getTextFormatExLeading(14,0xEDDB60,TextFormatAlign.LEFT,11));
		}
	}
}