package sszt.core.view.tips
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.manager.LanguageManager;

	public class SkillItemTip extends SkillTemplateTip
	{
		private var _iteminfo:SkillItemInfo;
		private var _info:SkillTemplateInfo;
		
		public function SkillItemTip()
		{
			super();
		}
		
		public function setSkillIteminfo(iteminfo:SkillItemInfo):void
		{
			if(iteminfo == null)return;
			_iteminfo = iteminfo;
			_info = _iteminfo.getTemplate();
			
			var nextLevel:int = _iteminfo.level < _iteminfo.getTemplate().totalLevel ? _iteminfo.level + 1 : -1;
			super.setSkillTemplate(_info,nextLevel);
		}
		
		override protected function addCurrentInfo():void
		{
			//技能等级
			addStringToField(LanguageManager.getWord("ssztl.common.skillLevelEx"),getTextFormatExLeading(12,0xFFFFFF,TextFormatAlign.LEFT,8));
			if(_iteminfo.level>0)
				addStringToField( _iteminfo.level.toString()+"/"+ _info.totalLevel,new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xEDDB60,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3),false);
		
			if(_info.activeUseMp[_iteminfo.level - 1]>0)
				addStringToField(getUseMp(_info.activeUseMp[_iteminfo.level - 1]),DEFAULT_TEXTFORMAT);
			if(_info.prepareTime[_iteminfo.level - 1]>0)
				addStringToField(getPrepareTime(_info.prepareTime[_iteminfo.level - 1]),DEFAULT_TEXTFORMAT);
			if(_info.coldDownTime[_iteminfo.level - 1]>0)
				addStringToField(getColddown(_info.coldDownTime[_iteminfo.level - 1]),DEFAULT_TEXTFORMAT);
			
			
			if(_info.activeType != 1 && _info.activeType != 0)
			{
				var buffId:int = _info.buffList[_iteminfo.level - 1];
				var buffInfo:BuffTemplateInfo = BuffTemplateList.getBuff(buffId);
				var time:int = 0;
				if(buffInfo)
				{
					time = buffInfo.valieTime;
				}
				if(time > 0)
				{
					addStringToField(getStraightTime(time),DEFAULT_TEXTFORMAT);
				}
			}
			
			if(_info.range[_iteminfo.level - 1]>0)
				addStringToField(getRange(_info.range[_iteminfo.level - 1]),DEFAULT_TEXTFORMAT);
			
			if (_info.activeType != 1 && _info.activeType != 3 && _info.activeType != 4)
			{
				addStringToField(_info.getTargetToString(_iteminfo.level),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			}
			
			addEffectToField(_iteminfo.level);
			
			addLineBG();
			//if(_info.descriptText && _info.descriptText[_iteminfo.level - 1] && _info.descriptText[_iteminfo.level - 1] != "" && _info.descriptText[_iteminfo.level - 1] != "undefined") addStringToField(_info.descriptText[_iteminfo.level - 1],DEFAULT_TEXTFORMAT);
		}
		
		override protected function addNextInfo():void
		{
			if(_iteminfo.level == _info.totalLevel)return;
			//下一等级
			addStringToField(LanguageManager.getWord("ssztl.common.nextLevel2"),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xEDDB60,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			if(_info.activeUseMp[_iteminfo.level]>0)
				addStringToField(getUseMp(_info.activeUseMp[_iteminfo.level]),DEFAULT_TEXTFORMAT);
			if(_info.prepareTime[_iteminfo.level]>0)
				addStringToField(getPrepareTime(_info.prepareTime[_iteminfo.level]),DEFAULT_TEXTFORMAT);
			if(_info.coldDownTime[_iteminfo.level]>0)
				addStringToField(getColddown(_info.coldDownTime[_iteminfo.level]),DEFAULT_TEXTFORMAT);

			if(_info.activeType != 1 && _info.activeType != 0)
			{
				var buffId:int = _info.buffList[_iteminfo.level];
				var buffInfo:BuffTemplateInfo = BuffTemplateList.getBuff(buffId);
				var time:int = 0;
				if(buffInfo)
				{
					time = buffInfo.valieTime;
				}
				if(time > 0)
				{
					addStringToField(getStraightTime(time),DEFAULT_TEXTFORMAT);
				}
			}

			if(_info.range[_iteminfo.level]>0)
				addStringToField(getRange(_info.range[_iteminfo.level]),DEFAULT_TEXTFORMAT);
			
			//添加目标个数显示，如 ‘单体’，’群体n个‘
			if (_info.activeType != 1 && _info.activeType != 3 && _info.activeType != 4)
			{
				addStringToField(_info.getTargetToString(_iteminfo.level),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			}
			
			addEffectToField(_iteminfo.level + 1);
			
			addStringToField("\n",DEFAULT_TEXTFORMAT,false);
			//if(_info.descriptText && _info.descriptText[_iteminfo.level - 1] && _info.descriptText[_iteminfo.level - 1] != "" && _info.descriptText[_iteminfo.level - 1] != "undefined") addStringToField(_info.descriptText[_iteminfo.level - 1],DEFAULT_TEXTFORMAT);
		}
		
		protected function addEffectToField(level:int):void
		{
			addStringToField(_info.getEffectToString(level),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
		}
		
		private function getCurrentLevel(level:int):String
		{
			return LanguageManager.getWord("ssztl.common.currentLevel")+":" + level;
		}
	}
}