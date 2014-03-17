package sszt.core.view.tips
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;

	public class PetTip extends BaseDynamicTip
	{
		private var _petInfo:PetItemInfo;
		private var _cell:BaseCell;
		private var _typeLabel:TextField;
		
		public function PetTip()
		{
			super();
		}
		
		public function setPetInfo(item:PetItemInfo,hidePetProperty:Boolean = false):void
		{
			clear();
			_text.width = 150;
			
			_petInfo = item;
			addStringToField(_petInfo.nick, getTextFormat(CategoryType.getQualityColor(ItemTemplateList.getTemplate(_petInfo.templateId).quality)));
			addStringToField("(" + LanguageManager.getWord("ssztl.common.levelValue",_petInfo.level) + ")",getTextFormat(0xffffff), false);
			addStringToField(LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：" + _petInfo._stairs + '/' + 12, getTextFormat(0xffffff));
			addStringToField(LanguageManager.getWord("ssztl.common.qualityLabel")+ "：" + _petInfo.quality + "/" + _petInfo.upQuality, getTextFormat(0xffffff));
			addStringToField(LanguageManager.getWord("ssztl.common.growLabel")+ "：" + _petInfo.grow + '/' + _petInfo.upGrow, getTextFormat(0xffffff));
			
			if(_cell == null)
			{
				_cell = new BaseCell();
				_cell.move(150,7);
				addChild(_cell);
			}
			addPetIcon();
			
			if(_typeLabel == null)
			{
				_typeLabel = new TextField();
				_typeLabel.textColor = 0xffffff;
				_typeLabel.x = 146;
				_typeLabel.y = 25;
				_typeLabel.width = 40;
				_typeLabel.height = 25;
				_typeLabel.mouseEnabled = _typeLabel.mouseWheelEnabled = false;
				_typeLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
				var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
				_typeLabel.defaultTextFormat = t;
				_typeLabel.setTextFormat(t);
				addChild(_typeLabel);
			}
//			_typeLabel.text = PetType.getTypeString(_petInfo.template.property1);
			
			if(!hidePetProperty)
			{
//				if(_petInfo.attack > 0) addStringToField("攻 击：" + _petInfo.attack + "\t\t(天赋+" + _petInfo.attackRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.defence > 0) addStringToField("防 御：" + _petInfo.defence + "\t\t(天赋+" + _petInfo.defenceRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.hp > 0) addStringToField("生 命：" + _petInfo.hp + "\t\t(天赋+" + _petInfo.hpRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.mumpDefence > 0) addStringToField("斗 防：" + _petInfo.mumpDefence + "\t\t(天赋+" + _petInfo.mumpDefenceRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.magicDefence > 0) addStringToField("魔 防：" + _petInfo.magicDefence + "\t\t(天赋+" + _petInfo.magicDefenceRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.farDefence > 0) addStringToField("远 防：" + _petInfo.farDefence + "\t\t(天赋+" + _petInfo.farDefenceRate + "%)",getTextFormat(0x41D913));
				
//				if(_petInfo.attack > 0) addStringToField(LanguageManager.getWord("ssztl.common.attack4")+":" + _petInfo.attack + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _petInfo.attackRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.defence > 0) addStringToField(LanguageManager.getWord("ssztl.common.defense4")+ ":" + _petInfo.defence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _petInfo.defenceRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.hp > 0) addStringToField(LanguageManager.getWord("ssztl.common.life5")+ ":" + _petInfo.hp + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _petInfo.hpRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.mumpDefence > 0) addStringToField(LanguageManager.getWord("ssztl.common.mumpDefence4")+ ":" + _petInfo.mumpDefence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _petInfo.mumpDefenceRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.magicDefence > 0) addStringToField(LanguageManager.getWord("ssztl.common.magicDefence4")+ ":" + _petInfo.magicDefence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _petInfo.magicDefenceRate + "%)",getTextFormat(0x41D913));
//				if(_petInfo.farDefence > 0) addStringToField(LanguageManager.getWord("ssztl.common.farDefence4")+ ":" + _petInfo.farDefence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _petInfo.farDefenceRate + "%)",getTextFormat(0x41D913));
				
//				addStringToField("技能：",getTextFormat(0xffffff));
				addStringToField(LanguageManager.getWord("ssztl.common.skill")+"：",getTextFormat(0xffffff));
				if(_petInfo.skillList.length > 0)
				{
					for each(var i:PetSkillInfo in _petInfo.skillList)
					{
						if(i.templateId > 0){
							var mark:String = _petInfo.skillList.indexOf(i)==(_petInfo.skillList.length-1)?"":"、";
//							addStringToField(i.level + "级"+ i.getTemplate().name,getTextFormat(0xFF5300,12));
							addStringToField(LanguageManager.getWord("ssztl.common.levelValue",i.level)+ i.getTemplate().name + mark,getTextFormat(CategoryType.getQualityColor(i.level-1),12),false);
						}
					}
				}else{
					addStringToField("未学习",getTextFormat(0x777164),false);
				}
			}
		}
		
		private function addPetIcon():void
		{
			var tmp:PetTemplateInfo;
			if(_petInfo.styleId == 0 || _petInfo.styleId == -1)
			{
				tmp = _petInfo.template;
			}
//			else
//			{
//				var item:ItemTemplateInfo = ItemTemplateList.getTemplate(_petInfo.styleId);
//				if(item)
//				{
//					tmp = ItemTemplateList.getTemplate(item.property1);
//					if(!tmp)tmp = _petInfo.template;
//				}
//			}
			_cell.info = tmp;
		}
		
		protected function getTextFormat(color:uint,size:int = 12):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),size,color,null,null,null,null,null,null,null,null,null,4);
		}
		
		override protected function clear():void
		{
			super.clear();
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			_typeLabel = null;
		}
	}
}