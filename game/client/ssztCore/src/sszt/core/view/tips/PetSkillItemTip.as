package sszt.core.view.tips
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;

	public class PetSkillItemTip extends SkillItemTip
	{
		private var _petSkillInfo:PetSkillInfo;
		private var _skillName:String;
		private var _skillLevel:int;
		
		public function PetSkillItemTip()
		{
			super();
		}
		
		public function setPetSkillIteminfo(petSkillInfo:PetSkillInfo):void
		{
			if(petSkillInfo == null)return;
			_petSkillInfo = petSkillInfo;
			_skillLevel = _petSkillInfo.level;
			_skillName = _petSkillInfo.getTemplate().name;
			
			super.setSkillIteminfo(_petSkillInfo as SkillItemInfo);
		}
		
		override protected function addEffectToField(level:int):void
		{
			addStringToField(_petSkillInfo.getEffectToString(level),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
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
		
		override protected function addActiveType():void
		{
			addStringToField(getActiveTypeName(_petSkillInfo.getTemplate().activeType),getTextFormat(0x35c3f7),false);
		}
		
		private function getActiveTypeName(activeType:int):String
		{
			switch(activeType)
			{
				case 0:return LanguageManager.getWord("ssztl.common.activeSkill");
				case 3:return LanguageManager.getWord("ssztl.common.assistMasterSkill");
				case 4:return LanguageManager.getWord("ssztl.common.passiveSkill");
			}
			return "";
		}
	}
}