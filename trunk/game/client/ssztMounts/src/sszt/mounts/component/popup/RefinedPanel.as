/** 
 * @author 王岳春
 * @E-mail: 301045474@qq.com
 */ 
package sszt.mounts.component.popup
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsItemInfoUpdateEvent;
	import sszt.core.data.mounts.MountsRefinedTemplate;
	import sszt.core.data.mounts.MountsRefinedTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.mounts.component.cells.MountsCell1;
	import sszt.mounts.event.MountsEvent;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.mounts.socketHandler.MountsRefinedSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.TitleCZAsset;
	import ssztui.pet.TitleXLAsset;
	import ssztui.ui.RightArrowAsset;
	
	public class RefinedPanel extends MPanel
	{
		public static const PANEL_WIDTH:int = 272;
		public static const PANEL_HEIGHT:int = 383;
		
		private var _mediator:MountsMediator;
		private var _bg:IMovieWrapper;
		private var _currentMountInfo:MountsItemInfo;
		private var _baseRefinedLevel:MountsRefinedTemplate;
		private var _baseRefinedNextLevel:MountsRefinedTemplate;
		private var _refinedLevel:int;
		private var _refinedLevelMax:int;		
		
		private var _txtName:MAssetLabel;
		private var _txtLevel:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtRateCopper:MAssetLabel;
		private var _txtRateYuanbao:MAssetLabel;
		private var _txtCostCopper:MAssetLabel;
		private var _txtCostYuanbao:MAssetLabel;
		private var _attrValueLeft1:MAssetLabel;
		private var _attrValueLeft2:MAssetLabel;
		private var _attrValueLeft3:MAssetLabel;
		private var _attrValueLeft4:MAssetLabel;
		private var _attrValueLeft5:MAssetLabel;
		private var _attrValueLeft6:MAssetLabel;
		private var _attrValueLeft7:MAssetLabel;
		private var _attrValueLeft8:MAssetLabel;
		private var _attrValueRight1:MAssetLabel;
		private var _attrValueRight2:MAssetLabel;
		private var _attrValueRight3:MAssetLabel;
		private var _attrValueRight4:MAssetLabel;
		private var _attrValueRight5:MAssetLabel;
		private var _attrValueRight6:MAssetLabel;
		private var _attrValueRight7:MAssetLabel;
		private var _attrValueRight8:MAssetLabel;
		private var _mountsCell:MountsCell1;
				
		private var _btnUpgradeCopper:MCacheAssetBtn1;
		private var _btnUpgradeYuanbao:MCacheAssetBtn1;
		private var _btnUpgradeMask:MSprite;
		private var _btnUpgradeMask1:MSprite;
		
		public function RefinedPanel(mediator:MountsMediator)
		{
			var titleBitmapData:BitmapData;
			titleBitmapData = new TitleXLAsset();
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
//			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.MOUNTS2));
						
		}
		
		
		override protected  function configUI():void
		{
			super.configUI();
			setContentSize(272, 383);
			
			var txtBgQuality:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			txtBgQuality.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.common.refinedLabel') + '：</font></b>';
			var attrLabelLeft1:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft2:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft3:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft4:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft5:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft6:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft7:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelLeft8:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight1:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight2:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight3:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight4:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight5:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight6:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight7:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			var attrLabelRight8:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			
			attrLabelLeft1.text = attrLabelRight1.text = LanguageManager.getWord('ssztl.common.life') + '：';
			attrLabelLeft2.text = attrLabelRight2.text = LanguageManager.getWord('ssztl.common.magic') + '：';
			attrLabelLeft3.text = attrLabelRight3.text = LanguageManager.getWord('ssztl.common.attack') + '：';
			attrLabelLeft4.text = attrLabelRight4.text = LanguageManager.getWord('ssztl.club.defense') + '：';
			attrLabelLeft5.text = attrLabelRight5.text = LanguageManager.getWord('ssztl.mounts.attack') + '：';
			attrLabelLeft6.text = attrLabelRight6.text = LanguageManager.getWord('ssztl.common.magicDefence2') + '：';
			attrLabelLeft7.text = attrLabelRight7.text = LanguageManager.getWord('ssztl.common.farDefence2') + '：';
			attrLabelLeft8.text = attrLabelRight8.text = LanguageManager.getWord('ssztl.common.mumpDefence2') + '：';
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 2, 256, 375)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 7, 246, 185)),
				new BackgroundInfo(BackgroundType.BORDER_13, new Rectangle(15, 9, 242, 69)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 195, 246, 177)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,17,54,54), new Bitmap(CellCaches.getCellBigBoxBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(24,19,50,50), new Bitmap(CellCaches.getCellBigBg())),
				
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(17,199,119,26)),
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(137,199,119,26)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(76, 152, 18, 18), new Bitmap(MoneyIconCaches.copperAsset) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(176, 152, 18, 18), new Bitmap(MoneyIconCaches.yuanBaoAsset) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(114, 199, 40, 23), new Bitmap( new RightArrowAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(87, 46, 48, 18), txtBgQuality ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(43, 153, 50, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.fare'), MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(143, 153, 50, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.fare'), MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(37, 203, 80, 18), new MAssetLabel(LanguageManager.getWord('ssztl.mounts.currentRefined'), MAssetLabel.LABEL_TYPE_TITLE2, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(173, 203, 80, 18), new MAssetLabel(LanguageManager.getWord('ssztl.mounts.refinedMax'), MAssetLabel.LABEL_TYPE_TAG2, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 228, 80, 18), attrLabelLeft1),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 245, 80, 18), attrLabelLeft2),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 262, 80, 18), attrLabelLeft3),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 279, 80, 18), attrLabelLeft4),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 298, 80, 18), attrLabelLeft5),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 315, 80, 18), attrLabelLeft6),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 332, 80, 18), attrLabelLeft7),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 349, 80, 18), attrLabelLeft8),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 228, 80, 18), attrLabelRight1),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 245, 80, 18), attrLabelRight2),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 262, 80, 18), attrLabelRight3),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 279, 80, 18), attrLabelRight4),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 298, 80, 18), attrLabelRight5),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 315, 80, 18), attrLabelRight6),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 332, 80, 18), attrLabelRight7),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(146, 349, 80, 18), attrLabelRight8)
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
			//addContent(_txtLevel);
			
			_txtQuality = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtQuality.move(128, 46);
			addContent(_txtQuality);
			
			_txtRateCopper = new MAssetLabel('', MAssetLabel.LABEL_TYPE7);
			_txtRateCopper.move(87,95);
			addContent(_txtRateCopper);
			
			_txtRateYuanbao = new MAssetLabel('', MAssetLabel.LABEL_TYPE7);
			_txtRateYuanbao.move(187,95);
			addContent(_txtRateYuanbao);
			
			_txtCostCopper = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtCostCopper.move(95, 153);
			addContent(_txtCostCopper);
			
			_txtCostYuanbao = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtCostYuanbao.move(195, 153);
			addContent(_txtCostYuanbao);
			
			_attrValueLeft1 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft1.move(58, 228);
			addContent(_attrValueLeft1);
			_attrValueLeft2 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft2.move(58, 245);
			addContent(_attrValueLeft2);
			_attrValueLeft3 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft3.move(58, 262);
			addContent(_attrValueLeft3);
			_attrValueLeft4 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft4.move(58, 279);
			addContent(_attrValueLeft4);
			_attrValueLeft5 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft5.move(58, 298);
			addContent(_attrValueLeft5);
			_attrValueLeft6 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft6.move(58, 315);
			addContent(_attrValueLeft6);
			_attrValueLeft7 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft7.move(58, 332);
			addContent(_attrValueLeft7);
			_attrValueLeft8 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueLeft8.move(58, 349);
			addContent(_attrValueLeft8);
			
			_attrValueRight1 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight1.move(182, 228);
			addContent(_attrValueRight1);
			_attrValueRight2 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight2.move(182, 245);
			addContent(_attrValueRight2);
			_attrValueRight3 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight3.move(182, 262);
			addContent(_attrValueRight3);
			_attrValueRight4 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight4.move(182, 279);
			addContent(_attrValueRight4);
			_attrValueRight5 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight5.move(182, 298);
			addContent(_attrValueRight5);
			_attrValueRight6 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight6.move(182, 315);
			addContent(_attrValueRight6);
			_attrValueRight7 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight7.move(182, 332);
			addContent(_attrValueRight7);
			_attrValueRight8 = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_attrValueRight8.move(182, 349);
			addContent(_attrValueRight8);
			
			_attrValueLeft1.textColor = _attrValueLeft2.textColor = _attrValueLeft3.textColor = _attrValueLeft4.textColor = _attrValueLeft5.textColor = _attrValueLeft6.textColor = _attrValueLeft7.textColor = _attrValueLeft8.textColor = 0x6fb54c;
			_attrValueRight1.textColor = _attrValueRight2.textColor = _attrValueRight3.textColor = _attrValueRight4.textColor = _attrValueRight5.textColor = _attrValueRight6.textColor = _attrValueRight7.textColor = _attrValueRight8.textColor = 0x6fb54c;
			
			_btnUpgradeCopper = new MCacheAssetBtn1(0, 3, LanguageManager.getWord('ssztl.mounts.upgradeCopper'));
			_btnUpgradeCopper.move(51, 120);
			addContent(_btnUpgradeCopper);
			_btnUpgradeYuanbao = new MCacheAssetBtn1(0, 3, LanguageManager.getWord('ssztl.mounts.upgradeYuanbao'));
			_btnUpgradeYuanbao.move(151, 120);
			addContent(_btnUpgradeYuanbao);
			
			_btnUpgradeMask = new MSprite();
			_btnUpgradeMask.graphics.beginFill(0,0);
			_btnUpgradeMask.graphics.drawRect(0,0,75,30);
			_btnUpgradeMask.graphics.endFill();
			_btnUpgradeMask.move(101, 212);
			addContent(_btnUpgradeMask);
			_btnUpgradeMask.visible = false;
			_btnUpgradeMask.mouseEnabled = false;
			
			_btnUpgradeMask1 = new MSprite();
			_btnUpgradeMask1.graphics.beginFill(0,0);
			_btnUpgradeMask1.graphics.drawRect(0,0,75,30);
			_btnUpgradeMask1.graphics.endFill();
			_btnUpgradeMask1.move(101, 212);
			addContent(_btnUpgradeMask1);
			_btnUpgradeMask1.visible = false;
			_btnUpgradeMask1.mouseEnabled = false;
		}
		
		private function setData(e:Event):void
		{			
			_refinedLevel = _currentMountInfo.refined;
			_refinedLevelMax =_currentMountInfo.level;
			_baseRefinedLevel = MountsRefinedTemplateList.getMountsRefinedTemplate(_currentMountInfo.templateId, _refinedLevel);
			_baseRefinedNextLevel = MountsRefinedTemplateList.getMountsRefinedTemplate(_currentMountInfo.templateId, _refinedLevel + 1);
			if(_refinedLevel == _refinedLevelMax && _currentMountInfo.refinedHp >= _baseRefinedNextLevel.totalHp 
				&& _currentMountInfo.refinedMp >= _baseRefinedNextLevel.totalMp && _currentMountInfo.refinedAttack >= _baseRefinedNextLevel.attack
				&& _currentMountInfo.refinedDefence >= _baseRefinedNextLevel.defence && _currentMountInfo.farDefence >= _baseRefinedNextLevel.farDefense
				&& _currentMountInfo.refinedMagicDefence >= _baseRefinedNextLevel.magicDefense && _currentMountInfo.refinedMumpDefence >= _baseRefinedNextLevel.mumpDefense
				&& _currentMountInfo.refinedProAttack >= _baseRefinedNextLevel.propertyAttack)
			{
				_btnUpgradeCopper.enabled = false;
				_btnUpgradeYuanbao.enabled = false;
//				_btnUpgradeMask.visible = true;
//				_btnUpgradeMask.mouseEnabled = true;
//				_btnUpgradeMask.addEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
//				_btnUpgradeMask.addEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			}
			else
			{
				_btnUpgradeCopper.enabled = true;
				_btnUpgradeYuanbao.enabled = true;
//				_btnUpgradeMask.visible = false;
//				_btnUpgradeMask.mouseEnabled = false;
//				_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
//				_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			}			
			
//			_txtName.setValue(_currentMountInfo.nick);
			_txtName.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentMountInfo.templateId).quality) +"'>" + _currentMountInfo.nick + "</font> " +
				_currentMountInfo.level.toString() + LanguageManager.getWord("ssztl.common.levelLabel")
			);
			_txtLevel.setValue(LanguageManager.getWord('ssztl.common.levelValue', _currentMountInfo.level));
			_txtQuality.htmlText = '<b><font size="14">' + _refinedLevel + '/' + _refinedLevelMax + '</font></b>';
			
			_mountsCell.mountsInfo = _currentMountInfo;
			
			//百分比
			var rateCopper:int = 90 - _refinedLevel * 2;
			var rateYuanbao:int = 100;
			if(rateCopper < 10)
			{
				rateCopper = 10;
			}
			
			_txtRateCopper.htmlText = LanguageManager.getWord('ssztl.pet.successRate') + '：' + rateCopper + '%';
			_txtRateYuanbao.htmlText = LanguageManager.getWord('ssztl.pet.successRate') + '：' + rateYuanbao + '%';
						
			_txtCostCopper.setValue(getCostCopper());
			_txtCostYuanbao.setValue(getCostYuanbao());
			
			var templateId:Number = _currentMountInfo.templateId;
			var nextRefined:int = _currentMountInfo.refined + 1;
			var hpMax:int = _baseRefinedNextLevel.totalHp - _baseRefinedLevel.totalHp;
			var mpMax:int = _baseRefinedNextLevel.totalMp - _baseRefinedLevel.totalMp
			var attackMax:int = _baseRefinedNextLevel.attack - _baseRefinedLevel.attack
			var defenceMax:int = _baseRefinedNextLevel.defence - _baseRefinedLevel.defence
			var propertyAttackMax:int = _baseRefinedNextLevel.propertyAttack - _baseRefinedLevel.propertyAttack
			var magicDefenseMax:int = _baseRefinedNextLevel.magicDefense - _baseRefinedLevel.magicDefense
			var farDefenseMax:int = _baseRefinedNextLevel.farDefense - _baseRefinedLevel.farDefense
			var mumpDefenseMax:int = _baseRefinedNextLevel.mumpDefense - _baseRefinedLevel.mumpDefense
			_attrValueLeft1.htmlText = (_currentMountInfo.refinedHp >= hpMax ||_refinedLevel == _refinedLevelMax) ? 
				hpMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedHp.toString();
			_attrValueLeft2.htmlText = (_currentMountInfo.refinedMp >= mpMax ||_refinedLevel == _refinedLevelMax) ? 
				mpMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedMp.toString();
			_attrValueLeft3.htmlText = (_currentMountInfo.refinedAttack >= attackMax ||_refinedLevel == _refinedLevelMax) ? 
				attackMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedAttack.toString();
			_attrValueLeft4.htmlText = (_currentMountInfo.refinedDefence >= defenceMax ||_refinedLevel == _refinedLevelMax) ? 
				defenceMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedDefence.toString();
			_attrValueLeft5.htmlText = (_currentMountInfo.refinedProAttack >= propertyAttackMax ||_refinedLevel == _refinedLevelMax) ? 
				propertyAttackMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedProAttack.toString();
			_attrValueLeft6.htmlText = (_currentMountInfo.refinedMagicDefence >= magicDefenseMax ||_refinedLevel == _refinedLevelMax) ? 
				magicDefenseMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedMagicDefence.toString();
			_attrValueLeft7.htmlText = (_currentMountInfo.refinedFarDefence >= farDefenseMax ||_refinedLevel == _refinedLevelMax) ? 
				farDefenseMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedFarDefence.toString();
			_attrValueLeft8.htmlText = (_currentMountInfo.refinedMumpDefence >= mumpDefenseMax ||_refinedLevel == _refinedLevelMax) ? 
				mumpDefenseMax + " (" + LanguageManager.getWord("ssztl.common.full") + ")" : _currentMountInfo.refinedMumpDefence.toString();
				
			_attrValueRight1.htmlText = hpMax.toString();
			_attrValueRight2.htmlText = mpMax.toString();
			_attrValueRight3.htmlText = attackMax.toString();
			_attrValueRight4.htmlText = defenceMax.toString();
			_attrValueRight5.htmlText = propertyAttackMax.toString();
			_attrValueRight6.htmlText = magicDefenseMax.toString();
			_attrValueRight7.htmlText = farDefenseMax.toString();
			_attrValueRight8.htmlText = mumpDefenseMax.toString();
			
		}
		
		private function getCostCopper():String
		{
			var ret:int = (_refinedLevel + 1)* 800;
			if(ret > 80000) 
				ret = 80000;
			return String(ret);
		}
		
		private function getCostYuanbao():String
		{
			var f:Number = (_refinedLevel + 1)/ 20;
			var ret:int = Math.ceil(f * f) * 6;
			return String(ret);
		}
		
		private function initEvent():void
		{
			_btnUpgradeCopper.addEventListener(MouseEvent.CLICK, btnUpgradeCopperClickHandler);
			_btnUpgradeYuanbao.addEventListener(MouseEvent.CLICK, btnUpgradeYuanbaoClickHandler);
			_currentMountInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.mountsInfo.addEventListener(MountsEvent.MOUNTS_ID_UPDATE, currentMountChangeHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnUpgradeCopper.removeEventListener(MouseEvent.CLICK, btnUpgradeCopperClickHandler);
			_btnUpgradeYuanbao.removeEventListener(MouseEvent.CLICK, btnUpgradeYuanbaoClickHandler);
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
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.mounts.refinedMax'),null,new Rectangle(e.stageX,e.stageY,0,0));			
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
		
		private function btnUpgradeCopperClickHandler(event:MouseEvent):void
		{
			MountsRefinedSocketHandler.send(_currentMountInfo.id, 0);
		}
		
		private function btnUpgradeYuanbaoClickHandler(event:MouseEvent):void
		{
			MountsRefinedSocketHandler.send(_currentMountInfo.id, 1);
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
			if(_txtRateYuanbao)
			{
				_txtRateYuanbao = null;
			}
			if(_txtRateCopper)
			{
				_txtRateCopper = null;
			}
			if(_txtQuality)
			{
				_txtQuality = null;
			}
			if(_txtCostCopper)
			{
				_txtCostCopper = null;
			}
			if(_txtCostYuanbao)
			{
				_txtCostYuanbao = null;
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
			if(_attrValueLeft5)
			{
				_attrValueLeft5 = null;
			}
			if(_attrValueLeft6)
			{
				_attrValueLeft6 = null;
			}
			if(_attrValueLeft7)
			{
				_attrValueLeft7 = null;
			}
			if(_attrValueLeft8)
			{
				_attrValueLeft8 = null;
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
			if(_attrValueRight5)
			{
				_attrValueRight5 = null;
			}
			if(_attrValueRight6)
			{
				_attrValueRight6 = null;
			}
			if(_attrValueRight7)
			{
				_attrValueRight7 = null;
			}
			if(_attrValueRight8)
			{
				_attrValueRight8 = null;
			}
			if(_btnUpgradeCopper)
			{
				_btnUpgradeCopper.dispose();
				_btnUpgradeCopper = null;
			}
			if(_btnUpgradeYuanbao)
			{
				_btnUpgradeYuanbao.dispose();
				_btnUpgradeYuanbao = null;
			}
			if(_btnUpgradeMask)
			{
				_btnUpgradeMask.dispose();
				_btnUpgradeMask = null;
			}
			if(_btnUpgradeMask1)
			{
				_btnUpgradeMask1.dispose();
				_btnUpgradeMask1 = null;
			}			
			if(_mountsCell)
			{
				_mountsCell.dispose();
				_mountsCell = null;
			}
		}
	}
}