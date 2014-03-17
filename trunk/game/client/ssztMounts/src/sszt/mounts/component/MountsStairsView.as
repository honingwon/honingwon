package sszt.mounts.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
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
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.tips.MountsDiamondTip;
	import sszt.core.view.tips.MountsStarLevelTip;
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
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.BtnPreviewAsset;
	import ssztui.pet.HelpIconAsset;
	import ssztui.pet.IconDiamondAsset;
	import ssztui.pet.IconStarAsset;
	
	public class MountsStairsView extends Sprite  implements IMountsView
	{
		private var _mediator:MountsMediator;
		private var _bgImg:Bitmap;
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
		private var _preview:MAssetButton1;
		private var _helpTip:MSprite;
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _extList:Array;
		private var _nameTxtImg:Bitmap;
		
		public function MountsStairsView(mediator:MountsMediator)
		{
			DanCell.initDict();
			_mediator = mediator;
			_currentMountInfo = _mediator.module.mountsInfo.currentMounts;

			super();
			initView();
			initEvent();
			setData(null);
			
		}
		
		private function initView():void
		{
			_bgImg = new Bitmap();
			_bgImg.x = _bgImg.y = 2;
			addChild(_bgImg);
			
			var txtBgQuality:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE22, TextFieldAutoSize.LEFT);
			txtBgQuality.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.sword.qualityLevel') + '：</font></b>';
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(140,240,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(18,44,48,18), txtBgQuality ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(391,319,50,15), new MAssetLabel(LanguageManager.getWord('ssztl.common.ruleIntro'), MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(373,320,15,15), new Bitmap(new HelpIconAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(61,318,18,18), new Bitmap(MoneyIconCaches.copperAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(29,319,50,18), new MAssetLabel(LanguageManager.getWord('ssztl.common.fare'), MAssetLabel.LABEL_TYPE_TAG,TextFieldAutoSize.LEFT)),
			]);
			addChild(_bg as DisplayObject);
			
			_mountsCell = new MountsCell1();
			_mountsCell.move(24,19);
//			addChild(_mountsCell);
			
			_txtName = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtName.move(18,18);
//			addChild(_txtName);
			
			_nameTxtImg = new Bitmap();
			_nameTxtImg.x = _nameTxtImg.y = 15;
			addChild(_nameTxtImg);
			
			_txtLevel = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtLevel.move(77,20);
			addChild(_txtLevel);
			
			_txtQuality = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtQuality.setLabelType([new TextFormat("Tahoma",16,0xfffccc,true)]);
			_txtQuality.move(63,43);
			addChild(_txtQuality);
			
			_txtSuccessProbability = new MAssetLabel('', MAssetLabel.LABEL_TYPE7);
			_txtSuccessProbability.textColor = 0x66ff00;
			_txtSuccessProbability.move(231,200);
			addChild(_txtSuccessProbability);
			
			_danCell = new DanCell(DanCellType.QUALITY);
			_danCell.move(140,240);
			addChild(_danCell);
			
			_txtDanNumber = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtDanNumber.move(214,126);
//			addChild(_txtDanNumber);
			
			_preview = new MAssetButton1(new BtnPreviewAsset() as MovieClip);
			_preview.move(406,55);
			addChild(_preview);
			
			_txtCost = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtCost.move(79, 319);
			addChild(_txtCost);
			
			_btnUpgrade = new MCacheAssetBtn1(2, 0, LanguageManager.getWord('ssztl.mounts.upgrade'));
			_btnUpgrade.move(181,310);
			addChild(_btnUpgrade);
			
			_btnUpgradeMask = new MSprite();
			_btnUpgradeMask.graphics.beginFill(0,0);
			_btnUpgradeMask.graphics.drawRect(0,0,75,30);
			_btnUpgradeMask.graphics.endFill();
			_btnUpgradeMask.move(101, 159);
			addChild(_btnUpgradeMask);
			_btnUpgradeMask.visible = false;
			_btnUpgradeMask.mouseEnabled = false;
			
			_helpTip = new MSprite();
			_helpTip.graphics.beginFill(0,0);
			_helpTip.graphics.drawRect(372,319,72,17);
			_helpTip.graphics.endFill();
			addChild(_helpTip);
			
			_starBg = new IconStarAsset();
			_starBg.x = 370;
			_starBg.y = 13;
			addChild(_starBg);
			
			_diamondBg = new IconDiamondAsset();
			_diamondBg.x = 409;
			_diamondBg.y = 13;
			addChild(_diamondBg);
			_starBg.gotoAndStop(1);
			_diamondBg.gotoAndStop(1);
			
			_extList = [_starBg,_diamondBg];
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
			
			_txtLevel.setValue(LanguageManager.getWord('ssztl.common.levelValue', _currentMountInfo.level));
			_nameTxtImg.bitmapData = MountsPanel.getMountsName(_currentMountInfo.nick);
			_txtName.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentMountInfo.templateId).quality) +"'>" + _currentMountInfo.nick + "</font> "
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
				rate = 90;
			}
			else if(_qualityLevel < 11)
			{
				rate = 80;
			}
			else if(_qualityLevel < 16)
			{
				rate = 70;
			}
			else if(_qualityLevel < 21)
			{
				rate = 60;
			}
			else if(_qualityLevel < 26)
			{
				rate = 50;
			}
			else if(_qualityLevel < 31)
			{
				rate = 40;
			}
			else if(_qualityLevel < 36)
			{
				rate = 30;
			}
			else if(_qualityLevel < 41)
			{
				rate = 20;
			}
			else if(_qualityLevel < 46)
			{
				rate = 10;
			}
			else if(_qualityLevel < 48)
			{
				rate = 9;
			}
			else if(_qualityLevel < 50)
			{
				rate = 8;
			}
			else if(_qualityLevel < 52)
			{
				rate = 7;
			}
			else
			{
				rate = 5;
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
			_danCell.amount = _danAmount;
			
			if(_currentMountInfo.star>-1) _starBg.gotoAndStop(_currentMountInfo.star+1);
			if(_currentMountInfo.diamond>-1) _diamondBg.gotoAndStop(_currentMountInfo.diamond+1);
			
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
			
			_helpTip.addEventListener(MouseEvent.MOUSE_OVER,helpTipOverHandler);
			_helpTip.addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			_preview.addEventListener(MouseEvent.CLICK, btnClickHandler);
			for(var j:int = 0 ;j< _extList.length ; ++j)
			{
				_extList[j].addEventListener(MouseEvent.MOUSE_OVER,extOverHandler);
				_extList[j].addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
		}
		
		private function removeEvent():void
		{
			_btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentMountInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.mountsInfo.removeEventListener(MountsEvent.MOUNTS_ID_UPDATE, currentMountChangeHandler);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			
			_helpTip.removeEventListener(MouseEvent.MOUSE_OVER,helpTipOverHandler);
			_helpTip.removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			_preview.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			for(var j:int = 0 ;j< _extList.length ; ++j)
			{
				_extList[j].removeEventListener(MouseEvent.MOUSE_OVER,extOverHandler);
				_extList[j].removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
		}
		private function btnClickHandler(event:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.initShowMountDevelop();
		}
		private function extOverHandler(evt:MouseEvent):void
		{
			if(!_currentMountInfo) return;
			var index:int = _extList.indexOf(evt.currentTarget);
			var template_id:int = this._currentMountInfo.templateId;
			var star_level:int = this._currentMountInfo.star;
			var diamond:int = this._currentMountInfo.diamond;
			var tipStr:String;
			if (index == 0 )
				tipStr = MountsStarLevelTip.getInstance().getDataStr(template_id,star_level);
			else if ( index == 1)
				tipStr = MountsDiamondTip.getInstance().getDataStr(template_id, diamond);
			
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function helpTipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.mounts.stairsRules'),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
			
		}
		
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
			_danCell.amount = _danAmount;
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
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset('ssztui.pet.StairsBgAsset',BitmapData) as BitmapData;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
			
		}
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgImg && _bgImg.bitmapData){
				_bgImg.bitmapData.dispose();
				_bgImg = null;
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
			_preview = null;
			_helpTip = null;
			if(_starBg && _starBg.bitmapData)
			{
				_starBg.bitmapData.dispose();
				_starBg = null;
			}
			if(_diamondBg && _diamondBg.bitmapData)
			{
				_diamondBg.bitmapData.dispose();
				_diamondBg = null;
			}
			if(_nameTxtImg && _nameTxtImg.bitmapData)
			{
				_nameTxtImg.bitmapData.dispose();
				_nameTxtImg = null;
			}
			_txtCost = null;
			_extList = null;
		}
	}
}