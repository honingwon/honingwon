package sszt.skill.components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.cells.CellCaches;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.data.skill.SkillListUpdateEvent;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseSkillCell;
	import sszt.core.view.cell.BaseSkillItemCell;
	import sszt.skill.mediators.SkillMediator;
	
	public class SkillDetailView extends Sprite
	{
		private var _mediator:SkillMediator;
		private var _templateInfo:SkillTemplateInfo;
		private var _itemInfo:SkillItemInfo;
		
		private var _studyBtn:MCacheAsset3Btn;
		private var _upgradeBtn:MCacheAsset3Btn;
		
		private var _nameValue:MAssetLabel;
		private var _typeValue:MAssetLabel;
		private var _targetLabel:MAssetLabel;
		private var _targetValue:MAssetLabel;
		private var _mpUseLabel:MAssetLabel;
		private var _mpUseValue:MAssetLabel;
		private var _attackDistanceLabel:MAssetLabel;
		private var _attackDistanceValue:MAssetLabel;
		private var _skillDescriptLabel:MAssetLabel;
		private var _skillDescriptValue:MAssetLabel;
		private var _skillEffectLabel:MAssetLabel;
		private var _skillEffectValue:MAssetLabel;
		private var _upgradeEffectLabel:MAssetLabel;
		private var _upgradeEffectValue:MAssetLabel;
		
		private var _needLevelValue:MAssetLabel;
		private var _needMoneyValue:MAssetLabel;
		private var _needExpValue:MAssetLabel;
		private var _needItem:MAssetLabel;
		private var _currentMoneyValue:MAssetLabel
		private var _currentExpValue:MAssetLabel;
		
		private var _cellBg:Bitmap;
		private var _cell:BaseSkillCell;
		
		public function SkillDetailView(mediator:SkillMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_cellBg = new Bitmap(CellCaches.getCellBg());
			_cellBg.x = 18;
			_cellBg.y = 9;
			addChild(_cellBg);
			_cell = new BaseSkillCell();
			_cell.move(19,10);
			addChild(_cell);
			
			_nameValue = new MAssetLabel("",MAssetLabel.LABELTYPE7,TextFormatAlign.LEFT);
			_nameValue.move(68,27);
			addChild(_nameValue);
			_targetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillTarget"),MAssetLabel.LABELTYPE7,TextFormatAlign.LEFT);
			_targetLabel.move(13,59);
			addChild(_targetLabel);
			_targetValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_targetValue.move(76,59);
			addChild(_targetValue);
			
			_typeValue = new MAssetLabel("",MAssetLabel.LABELTYPE10,TextFormatAlign.LEFT);
			_typeValue.move(305,27);
			addChild(_typeValue);
			
			
			_mpUseLabel = new MAssetLabel(LanguageManager.getWord("ssztl.skill.mpCost"),MAssetLabel.LABELTYPE7,TextFormatAlign.LEFT);
			_mpUseLabel.move(13,81);
			addChild(_mpUseLabel);
			_mpUseValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_mpUseValue.move(76,81);
			addChild(_mpUseValue);
			
			_attackDistanceLabel = new MAssetLabel(LanguageManager.getWord("ssztl.skill.attackDistance"),MAssetLabel.LABELTYPE7,TextFormatAlign.LEFT);
			_attackDistanceLabel.move(132,81);
			addChild(_attackDistanceLabel);
			_attackDistanceValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_attackDistanceValue.move(190,81);
			addChild(_attackDistanceValue);
			
			var format:TextFormat = new TextFormat();
			format.font = LanguageManager.getWord("ssztl.common.wordType");
			format.color = 0xffffff;
			format.size = 12;
			format.letterSpacing = 0;
			format.leading = 4;
			
			_skillDescriptLabel = new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillDescript"),MAssetLabel.LABELTYPE7,TextFormatAlign.LEFT);
			_skillDescriptLabel.move(13,103);
			addChild(_skillDescriptLabel);
			_skillDescriptValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_skillDescriptValue.wordWrap = true;
			_skillDescriptValue.defaultTextFormat = format;
			_skillDescriptValue.width = 300;
			_skillDescriptValue.move(76,103);
			addChild(_skillDescriptValue);
			
			format.letterSpacing = 1.3;
			_skillEffectLabel = new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillEffect"),MAssetLabel.LABELTYPE7,TextFormatAlign.LEFT);
			_skillEffectLabel.move(13,135);
			addChild(_skillEffectLabel);
			_skillEffectValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_skillEffectValue.move(76,135);
			_skillEffectValue.wordWrap = true;
			_skillEffectValue.defaultTextFormat = format;
			_skillEffectValue.width = 300;
			addChild(_skillEffectValue);

			_upgradeEffectLabel = new MAssetLabel(LanguageManager.getWord("ssztl.skill.updateEffect"),MAssetLabel.LABELTYPE7,TextFormatAlign.LEFT);
			_upgradeEffectLabel.move(13,175);
			addChild(_upgradeEffectLabel);
			_upgradeEffectValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_upgradeEffectValue.move(76,175);
			_upgradeEffectValue.defaultTextFormat = format;
			_upgradeEffectValue.wordWrap = true;
			_upgradeEffectValue.width = 300;
			addChild(_upgradeEffectValue);
			
			_needLevelValue = new MAssetLabel("",MAssetLabel.LABELTYPE11,TextFormatAlign.LEFT);
			_needLevelValue.move(13,215);
			addChild(_needLevelValue);
			
			_needMoneyValue = new MAssetLabel("",MAssetLabel.LABELTYPE11,TextFormatAlign.LEFT);
			_needMoneyValue.move(90,215);
			addChild(_needMoneyValue);
			
			_needExpValue = new MAssetLabel("",MAssetLabel.LABELTYPE11,TextFormatAlign.LEFT);
			_needExpValue.move(207,215);
			addChild(_needExpValue);
			
			_needItem = new MAssetLabel("",MAssetLabel.LABELTYPE11,TextFormatAlign.LEFT);
			_needItem.move(13,235);
			addChild(_needItem);
			
			_currentMoneyValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_currentMoneyValue.move(90,235);
			addChild(_currentMoneyValue);
			
			_currentExpValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_currentExpValue.move(207,235);
			addChild(_currentExpValue);
		}
		
		private function initEvent():void
		{
			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
		}
		
		private function addSkillHandler(evt:SkillListUpdateEvent):void
		{
			if(_templateInfo == null)return;
			var info:SkillItemInfo = evt.data as SkillItemInfo;
			if(_templateInfo.templateId == info.templateId)
			{
				setItem(info);
			}
		}
		
		public function setTemplate(value:SkillTemplateInfo):void
		{
			clearView();
			_templateInfo = value;
			initTemplateViews(value);
		}
		
		public function setItem(value:SkillItemInfo):void
		{
			clearView();
			if(_itemInfo)
			{
				_itemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
			}
			_itemInfo = value;
			_itemInfo.addEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
			initItemViews(value);
		}
		
		private function upgradeHandler(evt:SkillItemInfoUpdateEvent):void
		{
			setCommonView(_itemInfo.getTemplate(),_itemInfo.level);
		}
		
		private function clearView():void
		{
			if(_studyBtn)
			{
				_studyBtn.visible = false;
				_studyBtn.enabled = true;
			}	
			if(_upgradeBtn)
			{
				_upgradeBtn.visible = false;
				_upgradeBtn.enabled = true;
			}
			_cell.info = null;
			
			_nameValue.setValue("");
			_typeValue.setValue("");
			_targetValue.setValue("");
			_mpUseValue.setValue("");
			_attackDistanceValue.setValue("");
			_skillDescriptValue.setValue("");
			_skillEffectValue.setValue("");
			_upgradeEffectValue.setValue("");
			_needLevelValue.setValue("");
			_needMoneyValue.setValue("");
			_needExpValue.setValue("");
			_needItem.setValue("");
			_currentMoneyValue.setValue("");
			_currentExpValue.setValue("");	
		}
		
		private function initTemplateViews(value:SkillTemplateInfo):void
		{
			if(_studyBtn == null)
			{
//				_studyBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.skill.studySkillLabel"));
				_studyBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.learn"));
				_studyBtn.addEventListener(MouseEvent.CLICK,studyClickHandler);
				_studyBtn.move(321,230);
				addChild(_studyBtn);
			}
			_studyBtn.visible = true;
			_nameValue.setValue(value.name);
			setCommonView(value);
		}
		
		private function initItemViews(value:SkillItemInfo):void
		{
			if(value.level < value.getTemplate().totalLevel)
			{
				if(_upgradeBtn == null)
				{
//					_upgradeBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.skill.upgradeSkillLabel"));
					
					_upgradeBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.upgrade"));
					_upgradeBtn.addEventListener(MouseEvent.CLICK,upgradeBtnHandler);
					_upgradeBtn.move(321,230);
					addChild(_upgradeBtn);
				}
				_upgradeBtn.visible = true;
			}
//			_nameValue.setValue(value.getTemplate().name + " Lv." + value.level);
			setCommonView(value.getTemplate(),value.level);
		}
		
		private function studyClickHandler(evt:MouseEvent):void
		{
			if(_templateInfo)
				_mediator.studyOrUpgrade(_templateInfo.templateId);
		}
		
		private function upgradeBtnHandler(evt:MouseEvent):void
		{
			if(_itemInfo)
				_mediator.studyOrUpgrade(_itemInfo.getTemplate().templateId);
		}
		
		private function setCommonView(value:SkillTemplateInfo,level:int = 0):void
		{
			var useble:Boolean = true;
			if(level>0)
			{
				_nameValue.setValue(value.name + " Lv." + level);
			}else
			{
				_nameValue.setValue(value.name);
			}
			_cell.info = value;
			
			if(value.activeType == 0)
			{
				_typeValue.setValue(LanguageManager.getWord("ssztl.skill.activeSkill"));
			}else if(value.activeType == 1)
			{
				_typeValue.setValue(LanguageManager.getWord("ssztl.skill.passiveSkill"));
			}else
			{
				_typeValue.setValue(LanguageManager.getWord("ssztl.skill.assistSkill"));
			}
			_targetValue.setValue(value.getTargetToString(level));
			_mpUseValue.setValue(value.activeUseMp[level]);
			_attackDistanceValue.setValue(value.range[level]);
			_skillDescriptValue.setValue(value.descriptText[level]);
			_skillEffectValue.setValue(value.getEffectToString(level,true));
			if(level >= value.totalLevel)
			{
				_upgradeEffectValue.setValue(LanguageManager.getWord("ssztl.skill.achieveMaxLevel"));
				_upgradeEffectValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_upgradeEffectValue.length);
				if(_upgradeBtn)
					_upgradeBtn.visible = false;
				return ;
			}
			else
			{
				_upgradeEffectValue.setValue(value.getEffectToString(level + 1, true));
			}
			
			if(level >= value.totalLevel)
			{
				_needLevelValue.visible = false;
				_needMoneyValue.visible = false;
				_needExpValue.visible = false;
				_needItem.visible = false;
				_currentExpValue.visible = false;
				_currentMoneyValue.visible = false;
			}else
			{
				_needLevelValue.visible = true;
				_needMoneyValue.visible = true;
				_needExpValue.visible = true;
				_needItem.visible = true;
				_currentExpValue.visible = true;
				_currentMoneyValue.visible = true;
			}
			_needLevelValue.setValue(LanguageManager.getWord("ssztl.common.needLevel") + "："+value.needLevel[level]);
			_needMoneyValue.setValue(LanguageManager.getWord("ssztl.skill.needCopper")+value.needCopper[level]);
			_needExpValue.setValue(LanguageManager.getWord("ssztl.skill.needLiftExp")+value.needLifeExp[level]);
			if(value.needCopper[level]==0 && value.needLifeExp[level]==0)
			{
				_needMoneyValue.setValue("");
				_needExpValue.setValue("");
			}
			else
			{
				if(GlobalData.selfPlayer.lifeExperiences >= value.needLifeExp[level])
				{
					_needExpValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff77),0,_needExpValue.length);
				}else
				{
					_needExpValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needExpValue.length);
					useble = false;
				}
				if(GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper>=value.needCopper[level])
				{
					_needMoneyValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff77),0,_needMoneyValue.length);
				}else
				{
					_needMoneyValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needMoneyValue.length);
					useble = false;
				}
			}
			if(GlobalData.selfPlayer.level>=value.needLevel[level])
			{
				_needLevelValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff77),0,_needLevelValue.length);
			}else
			{
				_needLevelValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needLevelValue.length);
				useble = false;
			}
			if(ItemTemplateList.getTemplate(value.needItemId[level]))
			{
				_needItem.setValue(ItemTemplateList.getTemplate(value.needItemId[level]).name);
				if(GlobalData.bagInfo.getItemById(value.needItemId[level-1]))
				{
					_needItem.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff77),0,_needItem.length);
				}else
				{
					_needItem.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needItem.length);
					useble = false;
				}
				
			}else
			{
				_needItem.setValue("");
			}
			
			_currentMoneyValue.setValue(LanguageManager.getWord("ssztl.common.curMoney")+GlobalData.selfPlayer.userMoney.copper);
			_currentExpValue.setValue(LanguageManager.getWord("ssztl.common.currentLiftExp")+GlobalData.selfPlayer.lifeExperiences);
			if(!useble)
			{
				if(_upgradeBtn)
					_upgradeBtn.enabled = false;
				if(_studyBtn)
					_studyBtn.enabled = false;
			}
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			_templateInfo = null;
			if(_itemInfo)
			{
				_itemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
				_itemInfo = null;
			}
			if(_studyBtn)
			{
				_studyBtn.removeEventListener(MouseEvent.CLICK,studyClickHandler);
				_studyBtn.dispose();
				_studyBtn = null;
			}
			if(_upgradeBtn)
			{
				_upgradeBtn.removeEventListener(MouseEvent.CLICK,upgradeBtnHandler);
				_upgradeBtn.dispose();
				_upgradeBtn = null;
			}
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			_nameValue = null;
			_typeValue = null;
			_targetLabel = null;
			_targetValue = null;
			_mpUseLabel = null;
			_mpUseValue = null;
			_attackDistanceLabel = null;
			_attackDistanceValue = null;
			_skillDescriptLabel = null;
			_skillDescriptValue = null;
			_skillEffectLabel = null;
			_skillEffectValue = null;
			_upgradeEffectLabel = null;
			_upgradeEffectValue = null;
			_needLevelValue = null;
			_needMoneyValue = null;
			_needExpValue = null;
			_needItem = null;
			_currentMoneyValue = null;
			_currentExpValue = null;
			_cellBg = null;
			if(parent) parent.removeChild(this);
		}
	}
}