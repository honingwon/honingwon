package sszt.core.view.tips
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.skill.SkillItemList;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.mcache.splits.MCacheSplit2Line;

	public class SkillTemplateTip extends BaseDynamicTip
	{
		/**
		 * 默认（白色）
		 */		
		protected const DEFAULT_TEXTFORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3);
		/**
		 * 不足（红色）
		 */		
		protected const DEFECT_TEXTFORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFF0000,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3);
		
		private var _info:SkillTemplateInfo;
		private var _nextLevel:int;
		private var _lineBg:Array;
		
		public function SkillTemplateTip()
		{
			_lineBg = new Array();
			super();
		}
		
		public function setSkillTemplate(info:SkillTemplateInfo,nextLevel:int = 1):void
		{
			if(info == null)return;
			_info = info;
			_nextLevel = nextLevel;
			_text.width = 180;
			
			clear();
			
			addNameToField();
			
			//技能的类型
			addStringToField(LanguageManager.getWord("ssztl.common.typeValueEx"),getTextFormat(0xFFFFFF,TextFormatAlign.LEFT));
//			addStringToField(getActiveTypeName(_info.activeType),getTextFormat(0x35c3f7),false);
			addActiveType();
			//技能所需要的武器
			addStringToField(getActiveItemCategory(_info.activeItemCategoryId),DEFAULT_TEXTFORMAT);
			
			addCurrentInfo();
			addNextInfo();
		}
		 
		protected function addActiveType():void
		{
			addStringToField(getActiveTypeName(_info.activeType),getTextFormat(0x35c3f7),false);
		}
		
		protected function addNameToField():void
		{
			//技能名字0xFF5300
			addStringToField(_info.name,getTextFormatExLeading(14,0xEDDB60,TextFormatAlign.LEFT,11));
		}
		
		protected function addCurrentInfo():void
		{
			//技能等级
			addStringToField(LanguageManager.getWord("ssztl.common.skillLevelEx"),getTextFormatExLeading(14,0xFFFFFF,TextFormatAlign.LEFT,8));
			addStringToField(LanguageManager.getWord("ssztl.club.neverLearnSkill"),DEFECT_TEXTFORMAT,false);
			
			/*if(_info.needLevel >0 )
				addStringToField(getCurrentLevel(_info.needLevel),DEFAULT_TEXTFORMAT);
			if(_info.activeUseMp[_info.needLevel - 1]>0)
				addStringToField(getUseMp(_info.activeUseMp[_info.needLevel - 1]),DEFAULT_TEXTFORMAT);
			if(_info.prepareTime[_info.needLevel - 1]>0)
				addStringToField(getPrepareTime(_info.prepareTime[_info.needLevel - 1]),DEFAULT_TEXTFORMAT);
			if(_info.coldDownTime[_info.needLevel - 1]>0)
				addStringToField(getColddown(_info.coldDownTime[_info.needLevel - 1]),DEFAULT_TEXTFORMAT);
			if(_info.straightTime[_info.needLevel - 1]>0)
				addStringToField(getStraightTime(_info.straightTime[_info.needLevel - 1]),DEFAULT_TEXTFORMAT);
			if(_info.range[_info.needLevel - 1]>0)
				addStringToField(getRange(_info.range[_info.needLevel - 1]),DEFAULT_TEXTFORMAT);
			addStringToField(_info.getTargetToString(_info.needLevel),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xEDDB60,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			addStringToField(_info.getEffectToString(_info.needLevel),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xEDDB60,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			addStringToField("\n",DEFAULT_TEXTFORMAT,false);
			if(_info.descriptText && _info.descriptText[_info.needLevel - 1] && _info.descriptText[_info.needLevel - 1] != "" && _info.descriptText[_info.needLevel - 1] != "undefined") addStringToField(_info.descriptText[_info.needLevel - 1],DEFAULT_TEXTFORMAT);
		*/
		}
		
		private function getCurrentLevel(level:int):String
		{
			return LanguageManager.getWord("ssztl.common.currentLevel")+":" + level;
		}
		
		protected function addNextInfo():void
		{
			if(_nextLevel == -1)return;
			//下一等级
			if(_info.needLevel[_nextLevel] > 0)
			{
				addStringToField(LanguageManager.getWord("ssztl.common.nextLevel2"),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xEDDB60,null,null,null,null,null,null,null,null,null,3));
			}
			
			//下一等级存在
			if(_nextLevel == 1)
			{
				if(_info.activeUseMp[_nextLevel-1] > 0)
					addStringToField(getUseMp(_info.activeUseMp[_nextLevel-1]),DEFAULT_TEXTFORMAT);
				if(_info.prepareTime[0] > 0)
					addStringToField(getPrepareTime(_info.prepareTime[0]),DEFAULT_TEXTFORMAT);
				if(_info.coldDownTime[0] > 0)
					addStringToField(getColddown(_info.coldDownTime[0]),DEFAULT_TEXTFORMAT);
				if(_info.activeType != 1 && _info.activeType != 0)
				{
					var buffId:int = _info.buffList[0];
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
					
				//施法距离
				if(_info.range[0] > 0)
					addStringToField(getRange(_info.range[0]),DEFAULT_TEXTFORMAT);
			}
			//技能效果
			if (_info.activeType != 1)
				addStringToField(_info.getTargetToString(_nextLevel),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			addStringToField(_info.getEffectToString(_nextLevel),new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			
			addLineBG();
			//学习条件
			addStringToField(LanguageManager.getWord("ssztl.common.studyCondition"),new TextFormat(LanguageManager.getWord("ssztl.common.studyCondition"),12,0xEDDB60,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,3));
			//人物等级
			if (GlobalData.selfPlayer.level > _info.needLevel[_nextLevel-1])
				addStringToField(LanguageManager.getWord("ssztl.skill.needLevel")+"："+_info.needLevel[_nextLevel-1],DEFAULT_TEXTFORMAT);
			else
				addStringToField(LanguageManager.getWord("ssztl.skill.needLevel")+"："+_info.needLevel[_nextLevel-1],DEFECT_TEXTFORMAT);
			
			
			//前置技能
			if(_info.needSkillId[_nextLevel - 1] == 0)
			{
				var str:String = LanguageManager.getWord("ssztl.common.none");
				var needSkillLevel:String = LanguageManager.getWord("ssztl.skill.needSkillLevel");
				addStringToField(needSkillLevel+"："+str ,DEFAULT_TEXTFORMAT);
			}
			else
			{
				var needSkillLv:String = LanguageManager.getWord("ssztl.skill.needSkillLevel");
				var str_Lv:String = SkillTemplateList.getSkill( _info.needSkillId[_nextLevel - 1]).name + LanguageManager.getWord('ssztl.common.levelValue',_info.needSkillLevel[_nextLevel - 1]);
				if(GlobalData.skillInfo.getSkillByLevel(_info.needSkillId[_nextLevel-1],_info.needSkillLevel[_nextLevel-1]) != null)
				{
					addStringToField(needSkillLv +"："+str_Lv ,DEFAULT_TEXTFORMAT);
				}
				else
				{
					addStringToField(needSkillLv +"："+str_Lv ,DEFECT_TEXTFORMAT);
				}
			}	
			
	
			if(_info.needLifeExp[_nextLevel - 1] > 0)
			{
				if(GlobalData.selfPlayer.lifeExperiences >= _info.needLifeExp[_nextLevel - 1])addStringToField(getNeedLifeExp(_info.needLifeExp[_nextLevel - 1]),DEFAULT_TEXTFORMAT);
				else addStringToField(getNeedLifeExp(_info.needLifeExp[_nextLevel - 1]),DEFECT_TEXTFORMAT);
			}
			if(_info.needCopper[_nextLevel - 1] > 0)
			{
				if((GlobalData.selfPlayer.userMoney.copper + GlobalData.selfPlayer.userMoney.bindCopper) >= _info.needCopper[_nextLevel - 1])addStringToField(getNeedCopper(_info.needCopper[_nextLevel - 1]),DEFAULT_TEXTFORMAT);
				else addStringToField(getNeedCopper(_info.needCopper[_nextLevel - 1]),DEFECT_TEXTFORMAT);
			}
		}
		
		private function getActiveTypeName(activeType:int):String
		{
			switch(activeType)
			{
//				case 0:return "[主动技能]";
//				case 1:return "[被动技能]";
//				case 2:return "[辅助技能]";
				case 0:return LanguageManager.getWord("ssztl.common.activeSkill");
				case 1:
				case 4:return LanguageManager.getWord("ssztl.common.passiveSkill");
				case 2:return LanguageManager.getWord("ssztl.common.assistSkill");
				case 3:return LanguageManager.getWord("ssztl.common.assistMasterSkill");
			}
			return "";
		}
		
		private function getActiveItemCategory(categoryId:int):String
		{
			if(categoryId == 0)return "";
//			var mes:String = "需要武器：";
			var mes:String = LanguageManager.getWord("ssztl.common.needWeapon");
			switch(categoryId)
			{
//				case 1:return mes + "刀";
//				case 2:return mes + "剑";
//				case 3:return mes + "扇";
				
				case 1:return mes + LanguageManager.getWord("ssztl.common.knife");
				case 2:return mes + LanguageManager.getWord("ssztl.common.swod");
				case 3:return mes + LanguageManager.getWord("ssztl.common.fan");
			}
			return "";
		}
		
		protected function addLineBG():void
		{
			var line:MCacheSplit2Line = new MCacheSplit2Line()
			line.x = 0;
			line.y = _text.textHeight+17;
			addChild(line);
			_lineBg.push(line);
			addStringToField("\n",DEFAULT_TEXTFORMAT,false);
		}
		
		private function getLevel(level:int):String
		{
//			return "下一等级：" + level;
			return LanguageManager.getWord("ssztl.common.nextLevel2") + level;
		}
		
		private function getNeedLevel(level:int):String
		{
//			return "下一等级需要：" + level + "级";
			return LanguageManager.getWord("ssztl.common.nextLevelNeed",level);
		}
		
		private function getNeedLifeExp(lifeExp:int):String
		{
//			return "需要历练：" + lifeExp;
			return LanguageManager.getWord("ssztl.skill.needLiftExp") + lifeExp;
		}
		
		private function getNeedCopper(copper:int):String
		{
			return LanguageManager.getWord("ssztl.skill.needCopper") + copper;
		}
		
		protected function getUseMp(mp:int):String
		{
			return LanguageManager.getWord("ssztl.skill.mpCostEx") + mp;
		}
		
		protected function getPrepareTime(time:int):String
		{
//			return "咏唱时间：" + time / 1000 + "秒";
			return LanguageManager.getWord("ssztl.common.prepareTimeValue",time / 1000);
		}
		
		protected function getColddown(time:int):String
		{
//			return "冷却时间：" + time / 1000 + "秒";
			return LanguageManager.getWord("ssztl.common.coldDownTimeValue",time / 1000);
		}
		
		protected function getStraightTime(time:int):String
		{
//			return "持续时间：" + time / 1000 + "秒";
			return LanguageManager.getWord("ssztl.common.straightTimeValue",time / 1000);
		}
		
		protected function getRange(range:int):String
		{
//			return "施法距离：" + range;
			return LanguageManager.getWord("ssztl.common.playRangeValue",range);
		}
		
		protected function getTextFormat(color:uint,align:String = null):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color,null,null,null,null,null,align,null,null,null,3);
		}
		protected function getTextFormatExLeading(fonting:int,color:uint,align:String = null,leading:int = 3):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),fonting,color,null,null,null,null,null,align,null,null,null,leading);
		}
		
		override protected function clear():void
		{
			super.clear();
			if (_lineBg && _lineBg.length > 0)
			{
				for(var j:int = 0; j <_lineBg.length; j++)
				{
					var line:MCacheSplit2Line = _lineBg[j];
					if (this.contains(line)) this.removeChild(line);
					line = null;
				}
				_lineBg = [];
			}
		}
		
		
		override public function dispose():void
		{
			if (_lineBg && _lineBg.length > 0)
			{
				for(var j:int = 0; j <_lineBg.length; j++)
				{
					var line:MCacheSplit2Line = _lineBg[j];
					if (this.contains(line)) this.removeChild(line);
					line = null;
				}
				_lineBg = [];
			}
			super.dispose();
		}
	}
}