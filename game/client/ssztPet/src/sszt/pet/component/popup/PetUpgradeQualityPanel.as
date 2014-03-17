/** 
 * @author 王鸿源
 * @E-mail: honingwon@gmail.com
 */ 
package sszt.pet.component.popup
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.pet.PetGrowupExpTemplateList;
	import sszt.core.data.pet.PetGrowupTemplate;
	import sszt.core.data.pet.PetGrowupTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.data.pet.PetQualificationExpTemplateList;
	import sszt.core.data.pet.PetQualificationTemplate;
	import sszt.core.data.pet.PetQualificationTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pet.PetQualityUpdateSocketHandler;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.pet.component.PetPanel;
	import sszt.pet.component.cells.DanCell;
	import sszt.pet.component.cells.PetCellBig;
	import sszt.pet.data.PetUpgradeQualityPanelType;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.pet.socketHandler.PetGrowUpdateSocketHandler;
	import sszt.pet.util.PetUtil;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.pet.TitleAsset;
	import ssztui.pet.TitleCZAsset;
	import ssztui.pet.TitleZZAsset;
	import ssztui.ui.BarAsset7;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressTrack2Asset;
	import ssztui.ui.RightArrowAsset;
	import ssztui.ui.SplitCompartLine;
	
	public class PetUpgradeQualityPanel extends MPanel
	{
		public static const PANEL_WIDTH:int = 272;
		public static const PANEL_HEIGHT:int = 366;
		
		private var _mediator:PetMediator;
		private var _bg:IMovieWrapper;
		private var _type:int;
		private var _currentPetInfo:PetItemInfo;
		private var _baseEvolutionCurrLevel:PetGrowupTemplate;
		private var _baseEvolutionNextLevel:PetGrowupTemplate;
		private var _evolutionLevel:int;
		private var _evolutionLevelMax:int;
		private var _baseIntelligenceCurrLevel:PetQualificationTemplate;
		private var _baseIntelligenceNextLevel:PetQualificationTemplate;
		private var _intelligenceLevel:int;
		private var _intelligenceLevelMax:int;
		private var _currentDanAmount:int;
		private var _currentDanTemplateId:int;
		private var _PetHeadCell:PetCellBig;
		
		private var _txtName:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtDanNumber:MAssetLabel;
		private var _attrValueLeft1:MAssetLabel;
		private var _attrValueLeft2:MAssetLabel;
		private var _attrValueLeft3:MAssetLabel;
		private var _attrValueRight1:MAssetLabel;
		private var _attrValueRight2:MAssetLabel;
		private var _attrValueRight3:MAssetLabel;
		
		private var _danCell:DanCell;
		
		private var _checkboxAutoBuy:CheckBox;
		private var _btnUpgrade:MCacheAssetBtn1;
		private var _progressBg:BarAsset7;
		private var _progressBar:ProgressBar;
		private var _btnUpgradeMask:MSprite;
		
		public function PetUpgradeQualityPanel(mediator:PetMediator, type:int)
		{
			_mediator = mediator;
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			
			_type = type;
			var titleBitmapData:BitmapData;
			titleBitmapData = (_type == PetUpgradeQualityPanelType.EVOLUTION) ? new TitleCZAsset() : new TitleZZAsset();
			var rec:Rectangle =  GlobalAPI.layerManager.getTopPanelRec();
			var toCenter:Boolean = false;
			if(rec == null )
			{
				toCenter = true;
			}
			super(new MCacheTitle1("", new Bitmap(titleBitmapData)), true,-1,true,toCenter, GlobalAPI.layerManager.getTopPanelRec());
			
			setData(null);
			initEvent();
			if(_type == PetUpgradeQualityPanelType.EVOLUTION)
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.PET2));
			}
			
		}
		
		override protected  function configUI():void
		{
			super.configUI();
			setContentSize(PANEL_WIDTH,PANEL_HEIGHT);
			
			var txtBgQuality:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			txtBgQuality.htmlText = (_type == PetUpgradeQualityPanelType.EVOLUTION) ? 
				'<b><font size="14">' + LanguageManager.getWord('ssztl.common.growLabel') + '：</font></b>' :
				'<b><font size="14">' + LanguageManager.getWord('ssztl.common.qualityLabel') + '：</font></b>';
			
			var attrLabelLeft1:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight1:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			if(_type == PetUpgradeQualityPanelType.EVOLUTION)
			{
				attrLabelLeft1.text = attrLabelRight1.text = LanguageManager.getWord('ssztl.pet.attack') + '：';
			}
			else
			{
				attrLabelLeft1.text = attrLabelRight1.text = LanguageManager.getWord('ssztl.pet.attrAttack') + '：';
			}
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,2,256,358)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13,7,246,255)),
				new BackgroundInfo(BackgroundType.BORDER_13, new Rectangle(15,9,242,251)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13,265,246,90)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,77,242,2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,78,242,11),new Bitmap(new SplitCompartLine())),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(204,139,40,22)),
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(16,268,119,26)),
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(137,268,119,26)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(114,268,40,23), new Bitmap(new RightArrowAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(30,130,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,17,54,54), new Bitmap(CellCaches.getCellBigBoxBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(24,19,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(65,97,182,17),new ProgressTrack2Asset()),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(85,47,48,18), txtBgQuality),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(27,97,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.common.progressLabel')+'：', MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(182,142,15,18), new MAssetLabel('×', MAssetLabel.LABEL_TYPE1, TextFieldAutoSize.LEFT) ),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(50, 185,100,18), new MAssetLabel(LanguageManager.getWord('ssztl.common.autoBuyItem'), MAssetLabel.LABEL_TYPE2, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(52,271,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.mounts.currentAttribute'), MAssetLabel.LABEL_TYPE_TITLE2, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(173,271,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.mounts.nextLevelAttribute'), MAssetLabel.LABEL_TYPE_TAG2, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,297,80,18), attrLabelLeft1),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,314,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.pet.hit')+'：',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,331,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.pet.powerAttack')+'：',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146,297,80,18), attrLabelRight1),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146,314,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.pet.hit')+'：',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146,331,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.pet.powerAttack')+'：',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT))
			]);
			addContent(_bg as DisplayObject);
			_PetHeadCell = new PetCellBig();
			_PetHeadCell.move(24,19);
			addContent(_PetHeadCell);
			
			_txtName = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtName.move(85,22);
			addContent(_txtName);
			
			_txtQuality = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtQuality.move(130,47);
			addContent(_txtQuality);

			_progressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset() as BitmapData),0,0,154,9,true,false);
			_progressBar.move(79,101);
			addContent(_progressBar);
			
			var currentDanTemplateId:int;
			if(_type == PetUpgradeQualityPanelType.EVOLUTION)
			{
				currentDanTemplateId = PetUtil.getPetGrowPillType(_currentPetInfo.grow);
			}
			else
			{
				currentDanTemplateId = PetUtil.getPetQualityPillType(_currentPetInfo.quality);
			}
			_danCell = new DanCell();
			_danCell.move(30,130);
			addContent(_danCell);
			
			_txtDanNumber = new MAssetLabel('888', MAssetLabel.LABEL_TYPE20);
			_txtDanNumber.setSize(29,16);
			_txtDanNumber.move(214,142);
			addContent(_txtDanNumber);
			
			_checkboxAutoBuy = new CheckBox();
			_checkboxAutoBuy.label = LanguageManager.getWord("ssztl.common.autoBuyItem");
			_checkboxAutoBuy.setSize(130,20);
			_checkboxAutoBuy.move(31,186);
			addContent(_checkboxAutoBuy);
			_checkboxAutoBuy.enabled = false;
			_checkboxAutoBuy.visible = false;
			
			_attrValueLeft1 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueLeft1.move(58,297);
			addContent(_attrValueLeft1);
			_attrValueLeft2 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueLeft2.move(58,314);
			addContent(_attrValueLeft2);
			_attrValueLeft3 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueLeft3.move(58,331);
			addContent(_attrValueLeft3);
			
			_attrValueRight1 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueRight1.move(182,297);
			addContent(_attrValueRight1);
			_attrValueRight2 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueRight2.move(182,314);
			addContent(_attrValueRight2);
			_attrValueRight3 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueRight3.move(182,331);
			addContent(_attrValueRight3);
			
			_btnUpgrade = new MCacheAssetBtn1(0, 3, LanguageManager.getWord('ssztl.mounts.upgrade'));
			_btnUpgrade.move(101, 212);
			addContent(_btnUpgrade);
			
			_btnUpgradeMask = new MSprite();
			_btnUpgradeMask.graphics.beginFill(0,0);
			_btnUpgradeMask.graphics.drawRect(0,0,75,30);
			_btnUpgradeMask.graphics.endFill();
			_btnUpgradeMask.move(101, 212);
			addContent(_btnUpgradeMask);
			_btnUpgradeMask.visible = false;
			_btnUpgradeMask.mouseEnabled = false;
		}
		
		private function setData(e:Event):void
		{
			if(_type == PetUpgradeQualityPanelType.EVOLUTION)
			{
				_currentDanTemplateId = PetUtil.getPetGrowPillType(_currentPetInfo.grow);
			}
			else
			{
				_currentDanTemplateId = PetUtil.getPetQualityPillType(_currentPetInfo.quality);
			}
			
			_danCell.danInfo = ItemTemplateList.getTemplate(_currentDanTemplateId);
			
			updateCurrentDanAmount();
			
			_evolutionLevel = _currentPetInfo.grow;
			_evolutionLevelMax =_currentPetInfo.upGrow;
			_intelligenceLevel = _currentPetInfo.quality;
			_intelligenceLevelMax = _currentPetInfo.upQuality;
			
			if((_evolutionLevel == _evolutionLevelMax && _type == PetUpgradeQualityPanelType.EVOLUTION) ||
				(_intelligenceLevel == _intelligenceLevelMax && _type == PetUpgradeQualityPanelType.UPGRADE_INTELLIGENCE))
			{
				_btnUpgrade.enabled = false;
				_btnUpgradeMask.visible = true;
				_btnUpgradeMask.mouseEnabled = true;
				_btnUpgradeMask.addEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
				_btnUpgradeMask.addEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			}
			else
			{
				_btnUpgrade.enabled = true;
				_btnUpgradeMask.visible = false;
				_btnUpgradeMask.mouseEnabled = false;
				_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
				_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			}
			
			_baseEvolutionCurrLevel = PetGrowupTemplateList.getGrowup(_currentPetInfo.templateId, _evolutionLevel)
			_baseEvolutionNextLevel = (_evolutionLevel != _evolutionLevelMax) ? PetGrowupTemplateList.getGrowup(_currentPetInfo.templateId, _evolutionLevel + 1) : null;
			_baseIntelligenceCurrLevel = PetQualificationTemplateList.getGrowup(_currentPetInfo.templateId, _intelligenceLevel);
			_baseIntelligenceNextLevel = (_intelligenceLevel != _intelligenceLevelMax) ? PetQualificationTemplateList.getGrowup(_currentPetInfo.templateId, _intelligenceLevel + 1) : null;
			
			_PetHeadCell.petItemInfo = _currentPetInfo;
//			_txtName.setValue(_currentPetInfo.nick + " " + LanguageManager.getWord('ssztl.common.levelValue', _currentPetInfo.level));
			_txtName.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentPetInfo.templateId).quality) +"'>" + _currentPetInfo.nick + "</font> " +
				LanguageManager.getWord('ssztl.common.levelValue',_currentPetInfo.level)
			);
			_txtQuality.htmlText = (_type == PetUpgradeQualityPanelType.EVOLUTION) ? 
				'<b><font size="14">' + _evolutionLevel + '/' + _evolutionLevelMax + '</font></b>' :
				'<b><font size="14">' + _intelligenceLevel + '/' + _intelligenceLevelMax + '</font></b>';
			_txtDanNumber.setValue(''+_currentDanAmount);
			
			if((_type == PetUpgradeQualityPanelType.EVOLUTION))
			{
				_attrValueLeft1.htmlText = _currentPetInfo.attack + "<font color='#6fb54c' >(+" + _currentPetInfo.attack2 + ")</font>";
				_attrValueLeft2.htmlText = _currentPetInfo.hit + "<font color='#6fb54c' >(+" + _currentPetInfo.hit2 + ")</font>";
				_attrValueLeft3.htmlText = _currentPetInfo.powerHit + "<font color='#6fb54c' >(+" + _currentPetInfo.powerHit2 + ")</font>";
				_attrValueRight1.htmlText = (_evolutionLevel == _evolutionLevelMax) ? '-' :
					_currentPetInfo.attack + "<font color='#6fb54c' >(+" + (_currentPetInfo.attack2 + _baseEvolutionNextLevel.attack - _baseEvolutionCurrLevel.attack) + ")</font>";
				_attrValueRight2.htmlText = (_evolutionLevel == _evolutionLevelMax) ? '-' : 
					_currentPetInfo.hit + "<font color='#6fb54c' >(+" + (_currentPetInfo.hit2 + _baseEvolutionNextLevel.hit - _baseEvolutionCurrLevel.hit) + ")</font>";
				_attrValueRight3.htmlText = (_evolutionLevel == _evolutionLevelMax) ? '-' : 
					_currentPetInfo.powerHit + "<font color='#6fb54c' >(+" + (_currentPetInfo.powerHit2 + _baseEvolutionNextLevel.powerHit - _baseEvolutionCurrLevel.powerHit) + ")</font>";
				
				if(_currentPetInfo.grow == PetsInfo.PET_GROW_MAX)
				{
					_progressBar.setValue(0,0);
				}
				else
				{
					_progressBar.setValue(
						PetGrowupExpTemplateList.getGrowUpgradeExp(_currentPetInfo.grow),
						PetGrowupExpTemplateList.getGrowUpgradeExpGained(_currentPetInfo.grow, _currentPetInfo.growExp)
					);
				}
			}
			else
			{
				_attrValueLeft1.htmlText = (_currentPetInfo.farAttack + _currentPetInfo.magicAttack + _currentPetInfo.mumpAttack) + 
					"<font color='#6fb54c' >(+" + 
					(_currentPetInfo.farAttack2 + _currentPetInfo.magicAttack2 + _currentPetInfo.mumpAttack2) + 
					")</font>";
				_attrValueLeft2.htmlText = _currentPetInfo.hit + "<font color='#6fb54c' >(+" + _currentPetInfo.hit2 + ")</font>";
				_attrValueLeft3.htmlText = _currentPetInfo.powerHit + "<font color='#6fb54c' >(+" + _currentPetInfo.powerHit2 + ")</font>";
				
				_attrValueRight1.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
					(_currentPetInfo.farAttack + _currentPetInfo.magicAttack + _currentPetInfo.mumpAttack) + 
						"<font color='#6fb54c' >(+" + 
						(_currentPetInfo.farAttack2 + _currentPetInfo.magicAttack2 + _currentPetInfo.mumpAttack2 + _baseIntelligenceNextLevel.farAttack - _baseIntelligenceCurrLevel.farAttack) + //3个模版属性值相同
						")</font>";
				_attrValueRight2.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
					_currentPetInfo.hit + "<font color='#6fb54c' >(+" + (_currentPetInfo.hit2 + _baseIntelligenceNextLevel.hit - _baseIntelligenceCurrLevel.hit) + ")</font>";
				_attrValueRight3.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
					_currentPetInfo.powerHit + "<font color='#6fb54c' >(+" + (_currentPetInfo.powerHit2 + _baseIntelligenceNextLevel.powerHit - _baseIntelligenceCurrLevel.powerHit) + ")</font>";
				if(_currentPetInfo.quality == PetsInfo.PET_QUALITY_MAX)
				{
					_progressBar.setValue(0,0);
				}
				else
				{
					_progressBar.setValue(
						PetQualificationExpTemplateList.getQualificationUpgradeExp(_currentPetInfo.quality), 
						PetQualificationExpTemplateList.getQualificationUpgradeExpGained(_currentPetInfo.quality, _currentPetInfo.qualityExp)
					);
				}
				
			}
		}
		
		private function initEvent():void
		{
			_btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_GROW_EXP,petGrowExpUpdateHandler);
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_QUALITY_EXP,petQualityExpUpdateHandler);
			_mediator.module.petsInfo.addEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnUpgrade.removeEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_GROW_EXP,petGrowExpUpdateHandler);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_QUALITY_EXP,petQualityExpUpdateHandler);
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
		}
		
		private function handleBtnUpgradeMouseOver(e:MouseEvent):void
		{
			if(_type == PetUpgradeQualityPanelType.EVOLUTION)
			{
				TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.pet.growMax'),null,new Rectangle(e.stageX,e.stageY,0,0));
			}
			else
			{
				TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.pet.qualityMax'),null,new Rectangle(e.stageX,e.stageY,0,0));
			}
		}
		
		private function handleBtnUpgradeMouseOut(e:Event):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function currentPetChangeHandler(e:PetEvent):void
		{
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_GROW_EXP,petGrowExpUpdateHandler);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_QUALITY_EXP,petQualityExpUpdateHandler);
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			
			
			setData(null);
			
		}
		
//		private function gameSizeChangeHandler(e:CommonModuleEvent):void
//		{
//			setPosition();
//		}		
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.PET2)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addContent);
			}
		}
		
		
		private function petGrowExpUpdateHandler(event:Event):void
		{
			_progressBar.setValue(
				PetGrowupExpTemplateList.getGrowUpgradeExp(_currentPetInfo.grow),
				PetGrowupExpTemplateList.getGrowUpgradeExpGained(_currentPetInfo.grow, _currentPetInfo.growExp)
			);
		}
		
		private function petQualityExpUpdateHandler(event:Event):void
		{
			_progressBar.setValue(
				PetQualificationExpTemplateList.getQualificationUpgradeExp(_currentPetInfo.quality), 
				PetQualificationExpTemplateList.getQualificationUpgradeExpGained(_currentPetInfo.quality, _currentPetInfo.qualityExp)
			);
		}
		
		private function bagInfoUpdateHandler(event:Event):void
		{
			updateCurrentDanAmount();
			
			_txtDanNumber.setValue(''+_currentDanAmount);
			
		}
		
		private function updateCurrentDanAmount():void
		{
			_currentDanAmount = GlobalData.bagInfo.getItemCountById(_currentDanTemplateId);
		}
		
		private function btnUpgradeClickHandler(event:MouseEvent):void
		{
			if(_currentDanAmount == 0)
			{
				if(_checkboxAutoBuy.selected)
				{
					//					ShopTemplateList.getShop(1).getItem().price;
					//					MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
					//					function chargeAlertHandler(evt:CloseEvent):void
					//					{
					//						if(evt.detail == MAlert.OK)
					//						{
					//							JSUtils.gotoFill();
					//						}
					//					}					
				}
				else
				{
					if(
						_currentDanTemplateId == CategoryType.PET_GROW_PILL4 || _currentDanTemplateId == CategoryType.PET_GROW_PILL5 ||
						_currentDanTemplateId == CategoryType.PET_QUALITY_PILL4 || _currentDanTemplateId == CategoryType.PET_QUALITY_PILL5
					)
					{
						QuickTips.show(LanguageManager.getWord('ssztl.common.hasNotEnoughpItem'));
					}
					else
					{
						BuyPanel.getInstance().show([_currentDanTemplateId], new ToStoreData(1));
					}
				}
			}
			else
			{
				if(_checkboxAutoBuy.selected)
				{
					// - -!
				}
				else
				{
					if(_type == PetUpgradeQualityPanelType.EVOLUTION)
					{
						PetGrowUpdateSocketHandler.send(_currentPetInfo.id);
					}
					else
					{
						PetQualityUpdateSocketHandler.send(_currentPetInfo.id);
					}
				}
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_currentPetInfo)
			{
				_currentPetInfo = null;
			}
			if(_txtName)
			{
				_txtName = null;
			}
			if(_txtQuality)
			{
				_txtQuality = null;
			}
			if(_txtDanNumber)
			{
				_txtDanNumber = null;
			}
			if(_danCell)
			{
				_danCell.dispose();
				_danCell = null;
			}
			if(_PetHeadCell)
			{
				_PetHeadCell.dispose();
				_PetHeadCell = null;
			}
			if(_checkboxAutoBuy)
			{
				_checkboxAutoBuy = null;
			}
			if(_attrValueLeft1)
			{
				_attrValueLeft1 = null;
			}
			if(_attrValueLeft2)
			{
				_attrValueLeft2 = null;
			}
			if(_attrValueLeft3)
			{
				_attrValueLeft3 = null;
			}
			if(_attrValueRight1)
			{
				_attrValueRight1 = null;
			}
			if(_attrValueRight2)
			{
				_attrValueRight2 = null;
			}
			if(_attrValueRight3)
			{
				_attrValueRight3 = null;
			}
			if(_btnUpgrade)
			{
				_btnUpgrade.dispose();
				_btnUpgrade = null;
			}
		}
	}
}