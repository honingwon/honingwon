package sszt.core.view.tips
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.mountsSkill.MountsSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	
	public class MountsTip extends BaseDynamicTip
	{
		private var _mountsInfo:MountsItemInfo;
		private var _cell:BaseCell;
		private var _typeLabel:TextField;
		
		public function MountsTip()
		{
			super();
		}
		
		public function setMountsInfo(item:MountsItemInfo,hidePetProperty:Boolean = false):void
		{
			clear();
			_text.width = 150;
			
			_mountsInfo = item;
			addStringToField(_mountsInfo.nick, getTextFormat(CategoryType.getQualityColor(ItemTemplateList.getTemplate(_mountsInfo.templateId).quality)));
			addStringToField("(" + LanguageManager.getWord("ssztl.common.levelValue",_mountsInfo.level) + ")",getTextFormat(0xffffff), false);
			addStringToField(LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：" + _mountsInfo.stairs + '/' + 12, getTextFormat(0xffffff));
			addStringToField(LanguageManager.getWord("ssztl.common.qualityLabel")+ "：" + _mountsInfo.quality + "/" + _mountsInfo.upQuality, getTextFormat(0xffffff));
			addStringToField(LanguageManager.getWord("ssztl.common.growLabel")+ "：" + _mountsInfo.grow + '/' + _mountsInfo.upGrow, getTextFormat(0xffffff));
			addStringToField(LanguageManager.getWord("ssztl.common.refinedLabel")+ "：" + _mountsInfo.refined + '/' + _mountsInfo.level, getTextFormat(0xffffff));
			
			if(_cell == null)
			{
				_cell = new BaseCell();
				_cell.move(150,7);
				addChild(_cell);
			}
//			addPetIcon();
			
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
			//			_typeLabel.text = PetType.getTypeString(_mountsInfo.template.property1);
			
			if(!hidePetProperty)
			{
				//				if(_mountsInfo.attack > 0) addStringToField("攻 击：" + _mountsInfo.attack + "\t\t(天赋+" + _mountsInfo.attackRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.defence > 0) addStringToField("防 御：" + _mountsInfo.defence + "\t\t(天赋+" + _mountsInfo.defenceRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.hp > 0) addStringToField("生 命：" + _mountsInfo.hp + "\t\t(天赋+" + _mountsInfo.hpRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.mumpDefence > 0) addStringToField("斗 防：" + _mountsInfo.mumpDefence + "\t\t(天赋+" + _mountsInfo.mumpDefenceRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.magicDefence > 0) addStringToField("魔 防：" + _mountsInfo.magicDefence + "\t\t(天赋+" + _mountsInfo.magicDefenceRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.farDefence > 0) addStringToField("远 防：" + _mountsInfo.farDefence + "\t\t(天赋+" + _mountsInfo.farDefenceRate + "%)",getTextFormat(0x41D913));
				
				//				if(_mountsInfo.attack > 0) addStringToField(LanguageManager.getWord("ssztl.common.attack4")+":" + _mountsInfo.attack + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _mountsInfo.attackRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.defence > 0) addStringToField(LanguageManager.getWord("ssztl.common.defense4")+ ":" + _mountsInfo.defence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _mountsInfo.defenceRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.hp > 0) addStringToField(LanguageManager.getWord("ssztl.common.life5")+ ":" + _mountsInfo.hp + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _mountsInfo.hpRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.mumpDefence > 0) addStringToField(LanguageManager.getWord("ssztl.common.mumpDefence4")+ ":" + _mountsInfo.mumpDefence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _mountsInfo.mumpDefenceRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.magicDefence > 0) addStringToField(LanguageManager.getWord("ssztl.common.magicDefence4")+ ":" + _mountsInfo.magicDefence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _mountsInfo.magicDefenceRate + "%)",getTextFormat(0x41D913));
				//				if(_mountsInfo.farDefence > 0) addStringToField(LanguageManager.getWord("ssztl.common.farDefence4")+ ":" + _mountsInfo.farDefence + "\t\t("+LanguageManager.getWord("ssztl.common.gift")+"+" + _mountsInfo.farDefenceRate + "%)",getTextFormat(0x41D913));
				
				//				addStringToField("技能：",getTextFormat(0xffffff));
				addStringToField(LanguageManager.getWord("ssztl.common.skill")+"：",getTextFormat(0xffffff));
				if(_mountsInfo.skillList.length > 0)
				{
					for each(var i:SkillItemInfo in _mountsInfo.skillList)
					{
						if(i.templateId > 0){
							var mark:String = _mountsInfo.skillList.indexOf(i)==(_mountsInfo.skillList.length-1)?"":"、";
							//							addStringToField(i.level + "级"+ i.getTemplate().name,getTextFormat(0xFF5300,12));
							addStringToField(LanguageManager.getWord("ssztl.common.levelValue",i.level)+ i.getTemplate().name + mark,getTextFormat(CategoryType.getQualityColor(i.level-1),12),false);
						}
					}
				}else{
					addStringToField("未学习",getTextFormat(0x777164),false);
				}
			}
		}
		
//		private function addPetIcon():void
//		{
//			var tmp:PetTemplateInfo;
//			if(_mountsInfo.styleId == 0 || _mountsInfo.styleId == -1)
//			{
//				tmp = _mountsInfo.template;
//			}
			//			else
			//			{
			//				var item:ItemTemplateInfo = ItemTemplateList.getTemplate(_mountsInfo.styleId);
			//				if(item)
			//				{
			//					tmp = ItemTemplateList.getTemplate(item.property1);
			//					if(!tmp)tmp = _mountsInfo.template;
			//				}
			//			}
//			_cell.info = tmp;
//		}
		
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