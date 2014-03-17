/** 
 * @author 王鸿源
 * @E-mail: honingwon@gmail.com
 */ 
package sszt.mounts.component.popup
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
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.mounts.MountsDiamondTemplateList;
	import sszt.core.data.mounts.MountsGrowupTemplate;
	import sszt.core.data.mounts.MountsGrowupTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsItemInfoUpdateEvent;
	import sszt.core.data.mounts.MountsQualificationTemplate;
	import sszt.core.data.mounts.MountsQualificationTemplateList;
	import sszt.core.data.mounts.MountsStarTemplateList;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.mounts.component.DanCellType;
	import sszt.mounts.component.MountsLeftPanel;
	import sszt.mounts.component.MountsPanel;
	import sszt.mounts.component.UpgradeQualityPanelType;
	import sszt.mounts.component.cells.DanCell;
	import sszt.mounts.component.cells.MountsCell1;
	import sszt.mounts.event.MountsEvent;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.mounts.socketHandler.MountsGrowUpdateSocketHandler;
	import sszt.mounts.socketHandler.MountsQualityUpdateSocketHandler;
	import sszt.mounts.socketHandler.MountsStatisUpdateSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.TitleCZAsset;
	import ssztui.pet.TitleZZAsset;
	import ssztui.ui.RightArrowAsset;
	
	public class UpgradeQualityPanel extends MPanel
	{
		public static const PANEL_WIDTH:int = 272;
		public static const PANEL_HEIGHT:int = 383;
		
		private var _mediator:MountsMediator;
		private var _bg:IMovieWrapper;
		private var _type:int;
		private var _currentMountInfo:MountsItemInfo;
		private var _baseEvolutionNextLevel:MountsGrowupTemplate;
		private var _evolutionLevel:int;
		private var _evolutionLevelMax:int;
		private var _baseIntelligenceNextLevel:MountsQualificationTemplate;
		private var _intelligenceLevel:int;
		private var _intelligenceLevelMax:int;
		private var _danAmount:int;
		private var _fuAmount:int;
		
		private var _txtName:MAssetLabel;
		private var _txtLevel:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtDanNumber:MAssetLabel;
		private var _txtFu:MAssetLabel;
		private var _txtCost:MAssetLabel;
		private var _attrValueLeft1:MAssetLabel;
		private var _attrValueLeft2:MAssetLabel;
		private var _attrValueLeft3:MAssetLabel;
		private var _attrValueLeft4:MAssetLabel;
		private var _attrValueRight1:MAssetLabel;
		private var _attrValueRight2:MAssetLabel;
		private var _attrValueRight3:MAssetLabel;
		private var _attrValueRight4:MAssetLabel;
		private var _txtSuccessProbability:MAssetLabel;
		private var _mountsCell:MountsCell1;
		
		private var _danCell:DanCell;
		
		private var _checkboxUseFu:CheckBox;
		private var _checkboxAutoBuy:CheckBox;
		private var _btnUpgrade:MCacheAssetBtn1;
		private var _btnUpgradeMask:MSprite;
		
		public function UpgradeQualityPanel(mediator:MountsMediator, type:int)
		{
			DanCell.initDict();
			_type = type;
			var titleBitmapData:BitmapData;
			titleBitmapData = (_type == UpgradeQualityPanelType.EVOLUTION) ? new TitleCZAsset() : new TitleZZAsset();
			var rec:Rectangle =  GlobalAPI.layerManager.getTopPanelRec();
			var toCenter:Boolean = false;
			if(rec == null )
			{
				toCenter = true;
			}
			
			super(new MCacheTitle1("",new Bitmap(titleBitmapData)), true, -1,true,toCenter, GlobalAPI.layerManager.getTopPanelRec());
			_mediator = mediator;
			_currentMountInfo = _mediator.module.mountsInfo.currentMounts;
			setData(null);
			initEvent();
			if(_type == UpgradeQualityPanelType.EVOLUTION)
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.MOUNTS1));
			}
			
		}
		
		
		override protected  function configUI():void
		{
			super.configUI();
			setContentSize(272, 383);
			
			var txtBgQuality:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			txtBgQuality.htmlText = (_type == UpgradeQualityPanelType.EVOLUTION) ? 
				'<b><font size="14">' + LanguageManager.getWord('ssztl.common.growLabel') + '：</font></b>' :
				'<b><font size="14">' + LanguageManager.getWord('ssztl.common.qualityLabel') + '：</font></b>';
			var attrLabelLeft1:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft2:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft3:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft4:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight1:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight2:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight3:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight4:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			if(_type == UpgradeQualityPanelType.EVOLUTION)
			{
				attrLabelLeft1.text = attrLabelRight1.text = LanguageManager.getWord('ssztl.common.life') + '：';
				attrLabelLeft2.text = attrLabelRight2.text = LanguageManager.getWord('ssztl.common.magic') + '：';
				attrLabelLeft3.text = attrLabelRight3.text = LanguageManager.getWord('ssztl.common.attack') + '：';
				attrLabelLeft4.text = attrLabelRight4.text = LanguageManager.getWord('ssztl.club.defense') + '：';
			}
			else
			{
				attrLabelLeft1.text = attrLabelRight1.text = LanguageManager.getWord('ssztl.mounts.attack') + '：';
				attrLabelLeft2.text = attrLabelRight2.text = LanguageManager.getWord('ssztl.common.magicDefence2') + '：';
				attrLabelLeft3.text = attrLabelRight3.text = LanguageManager.getWord('ssztl.common.farDefence2') + '：';
				attrLabelLeft4.text = attrLabelRight4.text = LanguageManager.getWord('ssztl.common.mumpDefence2') + '：';
			}
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 2, 256, 375)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 7, 246, 255)),
				new BackgroundInfo(BackgroundType.BORDER_13, new Rectangle(15, 9, 242, 69)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 265, 246, 107)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,17,54,54), new Bitmap(CellCaches.getCellBigBoxBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(24,19,50,50), new Bitmap(CellCaches.getCellBigBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(30, 116, 38, 38), new Bitmap(CellCaches.getCellBg()) ),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(174, 123, 49, 22)),
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(17,269,119,26)),
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(137,269,119,26)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(66, 237, 18, 18), new Bitmap(MoneyIconCaches.copperAsset) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(114, 269, 40, 23), new Bitmap( new RightArrowAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(87, 46, 48, 18), txtBgQuality ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(156, 127, 15, 18), new MAssetLabel('×', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(50, 185, 100, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.autoBuyItem'), MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(31, 238, 50, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.fare'), MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(52, 273, 80, 18), new MAssetLabel(LanguageManager.getWord('ssztl.mounts.currentAttribute'), MAssetLabel.LABEL_TYPE_TITLE2, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(173, 273, 80, 18), new MAssetLabel(LanguageManager.getWord('ssztl.mounts.nextLevelAttribute'), MAssetLabel.LABEL_TYPE_TAG2, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 298, 80, 18), attrLabelLeft1),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 315, 80, 18), attrLabelLeft2),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 332, 80, 18), attrLabelLeft3),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 349, 80, 18), attrLabelLeft4),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 298, 80, 18), attrLabelRight1),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 315, 80, 18), attrLabelRight2),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 332, 80, 18), attrLabelRight3),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 349, 80, 18), attrLabelRight4)
			]);
			addContent(_bg as DisplayObject);
			
			_mountsCell = new MountsCell1();
			_mountsCell.move(24,19);
			addContent(_mountsCell);
			
			_txtName = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtName.move(85,22);
			addContent(_txtName);
			
			_txtLevel = new MAssetLabel('', MAssetLabel.LABEL_TYPE2, TextFieldAutoSize.LEFT);
			_txtLevel.move(128, 23);
//			addContent(_txtLevel);
			
			_txtQuality = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtQuality.move(128, 46);
			addContent(_txtQuality);
			
			_txtSuccessProbability = new MAssetLabel('', MAssetLabel.LABEL_TYPE7);
			_txtSuccessProbability.move(136,86);
			addContent(_txtSuccessProbability);
			
			_danCell = (_type == UpgradeQualityPanelType.EVOLUTION) ? new DanCell(DanCellType.EVOLUTION) :
				new DanCell(DanCellType.INTELLIGENCE);
			_danCell.move(30, 116);
			addContent(_danCell);
			
			_txtDanNumber = new MAssetLabel('888', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtDanNumber.move(193, 125);
			addContent(_txtDanNumber);
			
			_checkboxUseFu = new CheckBox();
			_checkboxUseFu.setSize(16,16);
			_checkboxUseFu.move(31,162);
			addContent(_checkboxUseFu);
			_checkboxAutoBuy = new CheckBox();
			_checkboxAutoBuy.setSize(16,16);
			_checkboxAutoBuy.move(31,186);
			addContent(_checkboxAutoBuy);
			_checkboxAutoBuy.enabled = false;
			_checkboxAutoBuy.visible = false;
			
			_txtFu = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtFu.move(50, 161);
			addContent(_txtFu);
			
			_txtCost = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtCost.move(83, 238);
			addContent(_txtCost);
			
			_attrValueLeft1 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueLeft1.move(58, 298);
			addContent(_attrValueLeft1);
			_attrValueLeft2 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueLeft2.move(58, 315);
			addContent(_attrValueLeft2);
			_attrValueLeft3 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueLeft3.move(58, 332);
			addContent(_attrValueLeft3);
			_attrValueLeft4 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueLeft4.move(58, 349);
			addContent(_attrValueLeft4);
			
			_attrValueRight1 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueRight1.move(182, 298);
			addContent(_attrValueRight1);
			_attrValueRight2 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueRight2.move(182, 315);
			addContent(_attrValueRight2);
			_attrValueRight3 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueRight3.move(182, 332);
			addContent(_attrValueRight3);
			_attrValueRight4 = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_attrValueRight4.move(182, 349);
			addContent(_attrValueRight4);
			
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
			updateDanAndFuAmount();
			
			_evolutionLevel = _currentMountInfo.grow;
			_evolutionLevelMax =_currentMountInfo.upGrow;
			_intelligenceLevel = _currentMountInfo.quality;
			_intelligenceLevelMax = _currentMountInfo.upQuality;
			
			if((_evolutionLevel == _evolutionLevelMax && _type == UpgradeQualityPanelType.EVOLUTION) ||
				(_intelligenceLevel == _intelligenceLevelMax && _type == UpgradeQualityPanelType.UPGRADE_INTELLIGENCE))
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
			
			_baseEvolutionNextLevel = (_evolutionLevel != _evolutionLevelMax) ? MountsGrowupTemplateList.getGrowup(_currentMountInfo.templateId, _evolutionLevel + 1) : null;
			
			_baseIntelligenceNextLevel = (_intelligenceLevel != _intelligenceLevelMax) ? MountsQualificationTemplateList.getGrowup(_currentMountInfo.templateId, _intelligenceLevel + 1) : null;
			
//			_txtName.setValue(_currentMountInfo.nick);
			_txtName.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentMountInfo.templateId).quality) +"'>" + _currentMountInfo.nick + "</font> " +
				_currentMountInfo.level.toString() + LanguageManager.getWord("ssztl.common.levelLabel")
			);
			_txtLevel.setValue(LanguageManager.getWord('ssztl.common.levelValue', _currentMountInfo.level));
			_txtQuality.htmlText = (_type == UpgradeQualityPanelType.EVOLUTION) ? 
			'<b><font size="14">' + _evolutionLevel + '/' + _evolutionLevelMax + '</font></b>' :
			'<b><font size="14">' + _intelligenceLevel + '/' + _intelligenceLevelMax + '</font></b>';
			
			_mountsCell.mountsInfo = _currentMountInfo;
			
			//百分比
			var evolutionRate:int;
			var intelligenceRate:int;
			if(_evolutionLevel < 10)
			{
				evolutionRate = 100;
			}
			else if(_evolutionLevel < 20)
			{
				evolutionRate = 80;
			}
			else if(_evolutionLevel < 30)
			{
				evolutionRate = 70;
			}
			else if(_evolutionLevel < 40)
			{
				evolutionRate = 60;
			}
			else if(_evolutionLevel < 50)
			{
				evolutionRate = 40;
			}
			else if(_evolutionLevel < 60)
			{
				evolutionRate = 30;
			}
			else if(_evolutionLevel < 70)
			{
				evolutionRate = 20;
			}
			else if(_evolutionLevel < 80)
			{
				evolutionRate = 10;
			}
			else if(_evolutionLevel < 90)
			{
				evolutionRate = 5;
			}
			else
			{
				evolutionRate = 2;
			}
			
			if(_intelligenceLevel < 10)
			{
				intelligenceRate = 100;
			}
			else if(_intelligenceLevel < 20)
			{
				intelligenceRate = 80;
			}
			else if(_intelligenceLevel < 30)
			{
				intelligenceRate = 70;
			}
			else if(_intelligenceLevel < 40)
			{
				intelligenceRate = 60;
			}
			else if(_intelligenceLevel < 50)
			{
				intelligenceRate = 40;
			}
			else if(_intelligenceLevel < 60)
			{
				intelligenceRate = 30;
			}
			else if(_intelligenceLevel < 70)
			{
				intelligenceRate = 20;
			}
			else if(_intelligenceLevel < 80)
			{
				intelligenceRate = 10;
			}
			else if(_intelligenceLevel < 90)
			{
				intelligenceRate = 5;
			}
			else
			{
				intelligenceRate = 2;
			}
			
			if(_type == UpgradeQualityPanelType.EVOLUTION)
			{
				_txtSuccessProbability.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + evolutionRate + '%' + '</font></b>';
			}
			else
			{
				_txtSuccessProbability.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + intelligenceRate + '%' + '</font></b>';
			}
			
			
			
			_txtFu.text = (_type == UpgradeQualityPanelType.EVOLUTION) ? 
				LanguageManager.getWord('ssztl.mounts.fu1FirstValue', '' + _fuAmount) :
				LanguageManager.getWord('ssztl.mounts.fu2FirstValue', '' + _fuAmount);
			_txtCost.setValue(getCost());
			_txtDanNumber.setValue(''+_danAmount);
			
			var templateId:Number = _currentMountInfo.templateId;
			var nextGrowup:Number = _currentMountInfo.grow + 1;
			var nextQuality:Number = _currentMountInfo.quality + 1;
			if((_type == UpgradeQualityPanelType.EVOLUTION))
			{
				_attrValueLeft1.htmlText = _currentMountInfo.hp + "<font color='#6fb54c' >(+" + _currentMountInfo.hp1 + ")</font>";
				_attrValueLeft2.htmlText = _currentMountInfo.mp + "<font color='#6fb54c' >(+" + _currentMountInfo.mp1 + ")</font>";
				_attrValueLeft3.htmlText = _currentMountInfo.attack + "<font color='#6fb54c' >(+" + _currentMountInfo.attack1 + ")</font>";
				_attrValueLeft4.htmlText = _currentMountInfo.defence + "<font color='#6fb54c' >(+" + _currentMountInfo.defence1 + ")</font>";
				
				_attrValueRight1.htmlText = (_evolutionLevel == _evolutionLevelMax) ? '-' : 
					(_currentMountInfo.hp + "<font color='#6fb54c' >(+" + (_baseEvolutionNextLevel.hp + MountsDiamondTemplateList.getDiamondInfoByGrowup(templateId,nextGrowup).hp + ")</font>"));
				_attrValueRight2.htmlText = (_evolutionLevel == _evolutionLevelMax) ? '-' : 
					(_currentMountInfo.mp + "<font color='#6fb54c' >(+" + (_baseEvolutionNextLevel.mp + MountsDiamondTemplateList.getDiamondInfoByGrowup(templateId,nextGrowup).mp + ")</font>"));
				_attrValueRight3.htmlText = (_evolutionLevel == _evolutionLevelMax) ? '-' : 
					(_currentMountInfo.attack + "<font color='#6fb54c' >(+" + (_baseEvolutionNextLevel.attack + MountsDiamondTemplateList.getDiamondInfoByGrowup(templateId,nextGrowup).attack + ")</font>"));
				_attrValueRight4.htmlText = (_evolutionLevel == _evolutionLevelMax) ? '-' : 
					(_currentMountInfo.defence + "<font color='#6fb54c' >(+" + (_baseEvolutionNextLevel.defence + MountsDiamondTemplateList.getDiamondInfoByGrowup(templateId,nextGrowup).defence + ")</font>"));
			}
			else
			{
				_attrValueLeft1.htmlText = (_currentMountInfo.farAttack + _currentMountInfo.magicAttack + _currentMountInfo.mumpAttack) + "<font color='#6fb54c' >(+" + (_currentMountInfo.farAttack1 + _currentMountInfo.magicAttack1 + _currentMountInfo.mumpAttack1) + ")</font>";
				_attrValueLeft2.htmlText = _currentMountInfo.magicDefence + "<font color='#6fb54c' >(+" + _currentMountInfo.magicDefence1 + ")</font>";
				_attrValueLeft3.htmlText = _currentMountInfo.farDefence + "<font color='#6fb54c' >(+" + _currentMountInfo.farDefence1 + ")</font>";
				_attrValueLeft4.htmlText = _currentMountInfo.mumpDefence + "<font color='#6fb54c' >(+" + _currentMountInfo.mumpDefence1 + ")</font>";
				
				_attrValueRight1.text = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : String(_currentMountInfo.magicAttack + _currentMountInfo.magicAttack1 + _baseIntelligenceNextLevel.magicAttack) ;
				_attrValueRight2.text = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : String(_currentMountInfo.magicDefence + _currentMountInfo.magicDefence1 + _baseIntelligenceNextLevel.magicDefense) ;
				_attrValueRight3.text = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : String(_currentMountInfo.farDefence + _currentMountInfo.farDefence1 + _baseIntelligenceNextLevel.farDefense) ;
				_attrValueRight4.text = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : String(_currentMountInfo.mumpDefence + _currentMountInfo.mumpDefence1 + _baseIntelligenceNextLevel.mumpDefense);
				
				if(_currentMountInfo.magicAttack != 0)
				{
					_attrValueRight1.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
						(_currentMountInfo.magicAttack + "<font color='#6fb54c' >(+" + (_baseIntelligenceNextLevel.magicAttack + MountsStarTemplateList.getStarInfoByQuality(templateId,nextQuality).magicAttack + ")</font>"));
				}
				if(_currentMountInfo.mumpAttack != 0)
				{
					_attrValueRight1.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
						(_currentMountInfo.mumpAttack + "<font color='#6fb54c' >(+" + (_baseIntelligenceNextLevel.mumpAttack + MountsStarTemplateList.getStarInfoByQuality(templateId,nextQuality).mumpAttack + ")</font>"));
				}
				if(_currentMountInfo.farAttack != 0)
				{
					_attrValueRight1.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
						(_currentMountInfo.farAttack + "<font color='#6fb54c' >(+" + (_baseIntelligenceNextLevel.farAttack + MountsStarTemplateList.getStarInfoByQuality(templateId,nextQuality).farAttack + ")</font>"));
				}
				_attrValueRight2.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
					(_currentMountInfo.magicDefence + "<font color='#6fb54c' >(+" + (_baseIntelligenceNextLevel.magicDefense + MountsStarTemplateList.getStarInfoByQuality(templateId,nextQuality).magicDefense + ")</font>"));
				_attrValueRight3.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
					(_currentMountInfo.farDefence + "<font color='#6fb54c' >(+" + (_baseIntelligenceNextLevel.farDefense + MountsStarTemplateList.getStarInfoByQuality(templateId,nextQuality).farDefense + ")</font>"));
				_attrValueRight4.htmlText = (_intelligenceLevel == _intelligenceLevelMax) ? '-' : 
					(_currentMountInfo.mumpDefence + "<font color='#6fb54c' >(+" + (_baseIntelligenceNextLevel.mumpDefense + MountsStarTemplateList.getStarInfoByQuality(templateId,nextQuality).mumpDefense + ")</font>"));
			}
			
		}
		
		private function getCost():String
		{
			var ret:int;
			var nextLevel:int = (_type == UpgradeQualityPanelType.EVOLUTION) ? _evolutionLevel + 1 : _intelligenceLevel + 1;
			ret = 500 + nextLevel * 100;
			return String(ret);
		}
		
		private function initEvent():void
		{
			_btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentMountInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.mountsInfo.addEventListener(MountsEvent.MOUNTS_ID_UPDATE, currentMountChangeHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnUpgrade.removeEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentMountInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.mountsInfo.removeEventListener(MountsEvent.MOUNTS_ID_UPDATE, currentMountChangeHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
		}
		
//		private function gameSizeChangeHandler(e:CommonModuleEvent):void
//		{
//			setPosition();
//		}		
		
		private function handleBtnUpgradeMouseOver(e:MouseEvent):void
		{
			if(_type == UpgradeQualityPanelType.EVOLUTION)
			{
				TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.mounts.growMax'),null,new Rectangle(e.stageX,e.stageY,0,0));
			}
			else
			{
				TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.mounts.qualityMax'),null,new Rectangle(e.stageX,e.stageY,0,0));
			}
		}
		
		private function handleBtnUpgradeMouseOut(e:Event):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.MOUNTS1)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addContent);
			}
		}
		
		private function currentMountChangeHandler(e:MountsEvent):void
		{
			_currentMountInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			_currentMountInfo = _mediator.module.mountsInfo.currentMounts;
			_currentMountInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			
			setData(null);
		}
		
		private function bagInfoUpdateHandler(event:Event):void
		{
			updateDanAndFuAmount();
			
			_txtDanNumber.setValue(''+_danAmount);
			_txtFu.text = (_type == UpgradeQualityPanelType.EVOLUTION) ? 
				LanguageManager.getWord('ssztl.mounts.fu1FirstValue', '' + _fuAmount) :
				LanguageManager.getWord('ssztl.mounts.fu2FirstValue', '' + _fuAmount);
			
		}
		
		private function updateDanAndFuAmount():void
		{
			_danAmount =  (_type == UpgradeQualityPanelType.EVOLUTION) ? 
				GlobalData.bagInfo.getItemCountById(DanCell.danItemTemplateIdDict[DanCellType.EVOLUTION])  :
				GlobalData.bagInfo.getItemCountById(DanCell.danItemTemplateIdDict[DanCellType.INTELLIGENCE]);
			_fuAmount =  (_type == UpgradeQualityPanelType.EVOLUTION) ? 
				GlobalData.bagInfo.getItemCountById(CategoryType.MOUNTS_GROW_PROTECTED_SYMBOL)  :
				GlobalData.bagInfo.getItemCountById(CategoryType.MOUNTS_QUALITY_PROTECTED_SYMBOL);
		}
		
		private function btnUpgradeClickHandler(event:MouseEvent):void
		{
			if(_danAmount == 0)
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
					BuyPanel.getInstance().show(
						[
							DanCell.danItemTemplateIdDict[ (_type == UpgradeQualityPanelType.EVOLUTION) ? DanCellType.EVOLUTION : DanCellType.INTELLIGENCE]
						], 
						new ToStoreData(1));
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
					if(_checkboxUseFu.selected)
					{
						if(_fuAmount == 0)
						{
							BuyPanel.getInstance().show(
								[
									(_type == UpgradeQualityPanelType.EVOLUTION) ? CategoryType.MOUNTS_GROW_PROTECTED_SYMBOL : CategoryType.MOUNTS_QUALITY_PROTECTED_SYMBOL
								], 
								new ToStoreData(1));
						}
						else
						{
							if(_type == UpgradeQualityPanelType.EVOLUTION)
							{
								MountsGrowUpdateSocketHandler.send(_currentMountInfo.id, true);
							}
							else
							{
								MountsQualityUpdateSocketHandler.send(_currentMountInfo.id, true);
							}
						}
					}
					else
					{
						if(_type == UpgradeQualityPanelType.EVOLUTION)
						{
							MountsGrowUpdateSocketHandler.send(_currentMountInfo.id, false);
						}
						else
						{
							MountsQualityUpdateSocketHandler.send(_currentMountInfo.id, false);
						}
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
			if(_currentMountInfo)
			{
				_currentMountInfo = null;
			}
			if(_txtName)
			{
				_txtName = null;
			}
			if(_txtLevel)
			{
				_txtLevel = null;
			}
			if(_txtQuality)
			{
				_txtQuality = null;
			}
			if(_txtDanNumber)
			{
				_txtDanNumber = null;
			}
			if(_txtSuccessProbability)
			{
				_txtSuccessProbability = null;
			}
			if(_danCell)
			{
				_danCell.dispose();
				_danCell = null;
			}
			if(_checkboxUseFu)
			{
				_checkboxUseFu = null;
			}
			if(_checkboxAutoBuy)
			{
				_checkboxAutoBuy = null;
			}
			if(_txtFu)
			{
				_txtFu = null;
			}
			if(_txtCost)
			{
				_txtCost = null;
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
			if(_attrValueLeft4)
			{
				_attrValueLeft4 = null;
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
			if(_attrValueRight4)
			{
				_attrValueRight4 = null;
			}
			if(_btnUpgrade)
			{
				_btnUpgrade.dispose();
				_btnUpgrade = null;
			}
			if(_mountsCell)
			{
				_mountsCell.dispose();
				_mountsCell = null;
			}
		}
	}
}