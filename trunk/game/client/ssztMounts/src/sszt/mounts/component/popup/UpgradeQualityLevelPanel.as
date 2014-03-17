/** 
 * @author 王鸿源
 * @E-mail: honingwon@gmail.com
 */ 
package sszt.mounts.component.popup
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.VipType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsItemInfoUpdateEvent;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.mounts.component.DanCellType;
	import sszt.mounts.component.MountsLeftPanel;
	import sszt.mounts.component.MountsPanel;
	import sszt.mounts.component.cells.DanCell;
	import sszt.mounts.component.cells.MountsCell1;
	import sszt.mounts.data.MountsInfo;
	import sszt.mounts.event.MountsEvent;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.mounts.socketHandler.MountsStatisUpdateSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class UpgradeQualityLevelPanel extends MPanel
	{
		public static const PANEL_WIDTH:int = 272;
		public static const PANEL_HEIGHT:int = 383;
		
		private var _mediator:MountsMediator;
		private var _bg:IMovieWrapper;
		private var _currentMountInfo:MountsItemInfo;
		private var _qualityLevel:int;
		private var _qualityLevelMax:int;
		private var _danAmount:int;
		
		private var _txtName:MAssetLabel;
		private var _txtLevel:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtDanNumber:MAssetLabel;
		private var _txtCost:MAssetLabel;
		private var _txtSuccessProbability:MAssetLabel;
		private var _mountsCell:MountsCell1;
		
		private var _danCell:DanCell;
		
		private var _btnUpgrade:MCacheAssetBtn1;
		private var _btnUpgradeMask:MSprite;
		
		public function UpgradeQualityLevelPanel(mediator:MountsMediator)
		{
			DanCell.initDict();
			super(new MCacheTitle1("Jingjie"), true, -1,true,false,GlobalAPI.layerManager.getTopPanelRec());
			_mediator = mediator;
			_currentMountInfo = _mediator.module.mountsInfo.currentMounts;
			setData(null);
			initEvent();
			
//			setPosition();
		}
		
//		private function setPosition():void
//		{
//			var x:int = (CommonConfig.GAME_WIDTH - MountsPanel.PANEL_WIDTH - UpgradeQualityLevelPanel.PANEL_WIDTH)/2 + MountsPanel.PANEL_WIDTH
//			var y:int = (CommonConfig.GAME_HEIGHT - MountsPanel.PANEL_HEIGHT)/2
//			move(x,y);
//		}
		
		override protected  function configUI():void
		{
			super.configUI();
			setContentSize(272, 383);
			
			var txtBgQuality:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			txtBgQuality.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.sword.qualityLevel') + '：</font></b>';
			var txtBgRulesIntro:MAssetLabel = new MAssetLabel(LanguageManager.getWord('ssztl.mounts.stairsRules'), MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			txtBgRulesIntro.setSize(236,124);
			_bg = BackgroundUtils.setBackground([
				/*
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 2, 256, 375)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 7, 246, 205)),
				new BackgroundInfo(BackgroundType.BORDER_13, new Rectangle(15, 9, 242, 69)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 215, 246, 157)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(16, 80, 240, 29), new Bitmap(new MountsBarAsset) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(30, 116, 38, 38), new Bitmap(CellCaches.getCellBg()) ),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(169, 122, 59, 22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(66, 189, 14, 12), new Bitmap(MoneyIconCaches.copperAsset) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(87, 46, 48, 18), txtBgQuality ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(156, 129, 15, 18), new MAssetLabel('×', MAssetLabel.LABEL_TYPE1, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(31, 185, 50, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.fare'), MAssetLabel.LABEL_TYPE2, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17, 229, 238, 5), new Bitmap(new MountsBgAsset) ),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(111, 223, 80, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.ruleIntro'), MAssetLabel.LABEL_TYPE2, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(21, 246, 236, 124),  txtBgRulesIntro),
				*/
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 2, 256, 375)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 7, 246, 205)),
				new BackgroundInfo(BackgroundType.BORDER_13, new Rectangle(15,9, 242, 201)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13,215, 246, 157)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,79,242,2)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(15,219,242,26)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,17,54,54), new Bitmap(CellCaches.getCellBigBoxBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(24,19,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(30,116,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(204,123,40,22)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(85,47,48,18), txtBgQuality ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(182,126,15,18), new MAssetLabel('×', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(96,223,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.common.ruleIntro'), MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(21,249,230,114),txtBgRulesIntro),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(66, 184, 18, 18), new Bitmap(MoneyIconCaches.copperAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(31, 185, 50, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.fare'), MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT) ),
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
			_txtQuality.move(130,47);
			addContent(_txtQuality);
			
			_txtSuccessProbability = new MAssetLabel('', MAssetLabel.LABEL_TYPE7);
			_txtSuccessProbability.move(136,86);
			addContent(_txtSuccessProbability);
			
			_danCell = new DanCell(DanCellType.QUALITY);
			_danCell.move(30, 116);
			addContent(_danCell);
			
			_txtDanNumber = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtDanNumber.setSize(29,16);
			_txtDanNumber.move(214,126);
			addContent(_txtDanNumber);
			
			_txtCost = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtCost.move(83, 185);
			addContent(_txtCost);
			
			_btnUpgrade = new MCacheAssetBtn1(0, 3, LanguageManager.getWord('ssztl.mounts.upgrade'));
			_btnUpgrade.move(101, 159);
			addContent(_btnUpgrade);
			
			_btnUpgradeMask = new MSprite();
			_btnUpgradeMask.graphics.beginFill(0,0);
			_btnUpgradeMask.graphics.drawRect(0,0,75,30);
			_btnUpgradeMask.graphics.endFill();
			_btnUpgradeMask.move(101, 159);
			addContent(_btnUpgradeMask);
			_btnUpgradeMask.visible = false;
			_btnUpgradeMask.mouseEnabled = false;
		}
		
		private function setData(e:Event):void
		{
			updateDanAmount();
			
			_qualityLevel = _currentMountInfo.stairs;
			
			if(_qualityLevel == MountsInfo.MOUNTS_STAIRS_MAX)
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
			
//			_txtName.setValue(_currentMountInfo.nick);
//			_txtLevel.setValue(LanguageManager.getWord('ssztl.common.levelValue', _currentMountInfo.level));
			_txtName.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentMountInfo.templateId).quality) +"'>" + _currentMountInfo.nick + "</font> " +
				_currentMountInfo.level.toString() + LanguageManager.getWord("ssztl.common.levelLabel")
			);
			_mountsCell.mountsInfo = _currentMountInfo;
			
			_txtQuality.htmlText = '<b><font size="14">' + _qualityLevel + '</font></b>';
			var rate:int;
			var addtionalRate:int;
			if(_qualityLevel < 2)
			{
				rate = 100;
			}
			else if(_qualityLevel < 6)
			{
				rate = 80;
			}
			else if(_qualityLevel < 10)
			{
				rate = 60;
			}
			else if(_qualityLevel < 14)
			{
				rate = 40;
			}
			else if(_qualityLevel < 20)
			{
				rate = 30;
			}
			else if(_qualityLevel < 30)
			{
				rate = 20;
			}
			else if(_qualityLevel < 40)
			{
				rate = 10;
			}
			else if(_qualityLevel < 55)
			{
				rate = 5;
			}
			else if(_qualityLevel < 56)
			{
				rate = 4;
			}
			else if(_qualityLevel < 57)
			{
				rate = 3;
			}
			else
			{
				rate = 2;
			}
			var vipType:int = GlobalData.selfPlayer.getVipType();
			if(vipType > VipType.NORMAL)
			{
				addtionalRate = VipTemplateList.getVipTemplateInfo(vipType).mountsStairRate;
				rate += addtionalRate;
				rate = (rate > 100) ? 100 : rate;
			}
			if(GlobalData.selfPlayer.getVipType()>1)
			{
				switch(GlobalData.selfPlayer.getVipType())
				{
					case 2:
						_txtSuccessProbability.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' +  '</font></b>'+LanguageManager.getWord('ssztl.pet.successRateAddh');
						break;
					case 3:
						_txtSuccessProbability.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' +  '</font></b>'+LanguageManager.getWord('ssztl.pet.successRateAddb');
						break;
				}
					
			}
			else
				_txtSuccessProbability.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' +  '</font></b>';
			_txtCost.setValue(getCost());
			_txtDanNumber.setValue(''+_danAmount);
		}
		
		private function getCost():String
		{
			var ret:int;
			var nextLevel:int = _qualityLevel + 1;
			ret = 500 + nextLevel * 100;
			return String(ret);
		}
		
		private function initEvent():void
		{
			_btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentMountInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.mountsInfo.addEventListener(MountsEvent.MOUNTS_ID_UPDATE, currentMountChangeHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentMountInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.mountsInfo.removeEventListener(MountsEvent.MOUNTS_ID_UPDATE, currentMountChangeHandler);
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
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.mounts.stairsMax'),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function handleBtnUpgradeMouseOut(e:Event):void
		{
			TipsUtil.getInstance().hide();
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
			updateDanAmount();
			_txtDanNumber.setValue(''+_danAmount);
		}
		
		private function updateDanAmount():void
		{
			_danAmount = GlobalData.bagInfo.getItemCountById(DanCell.danItemTemplateIdDict[DanCellType.QUALITY]);
		}
		
		private function btnUpgradeClickHandler(event:MouseEvent):void
		{
			if(_danAmount == 0)
			{
				BuyPanel.getInstance().show([DanCell.danItemTemplateIdDict[DanCellType.QUALITY]],new ToStoreData(1));
			}
			else
			{
				MountsStatisUpdateSocketHandler.send(_currentMountInfo.id);
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
				_txtName= null;
			}
			if(_txtLevel)
			{
				_txtLevel= null;
			}
			if(_txtQuality)
			{
				_txtQuality= null;
			}
			if(_txtDanNumber)
			{
				_txtDanNumber= null;
			}
			if(_txtCost)
			{
				_txtCost= null;
			}
			if(_txtSuccessProbability)
			{
				_txtSuccessProbability= null;
			}
			if(_danCell)
			{
				_danCell.dispose();
				_danCell = null;
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