package sszt.pet.component
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
	import flash.sampler.NewObjectSample;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.constData.VipType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.PetDiamondTip;
	import sszt.core.view.tips.PetStarLevelTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.pet.component.PetPanel;
	import sszt.pet.component.cells.DanCell;
	import sszt.pet.component.cells.PetCellBig;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.pet.socketHandler.PetStatisUpdateSocketHandler;
	import sszt.pet.util.PetUtil;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.BtnPreviewAsset;
	import ssztui.pet.HelpIconAsset;
	import ssztui.pet.IconDiamondAsset;
	import ssztui.pet.IconStarAsset;
	import ssztui.pet.TitleAsset;
	import ssztui.ui.SplitCompartLine;
	
	public class PetStairsView extends Sprite implements IPetView
	{
		private var _mediator:PetMediator;
		private var _bg:IMovieWrapper;
		private var _currentPetInfo:PetItemInfo;
		private var _qualityLevel:int;
		private var _qualityLevelMax:int;
		private var _currentDanAmount:int;
		private var _currentDanTemplateId:int;
		private var _PetHeadCell:PetCellBig;
		
		private var _bgImg:Bitmap;
		private var _txtName:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtDanNumber:MAssetLabel;
		private var _txtCost:MAssetLabel;
		private var _txtSuccessProbability:MAssetLabel;
		
		private var _danCell:DanCell;
		private var _btnUpgrade:MCacheAssetBtn1;
		private var _btnUpgradeMask:MSprite;
		
		private var _helpTip:MSprite;
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _extList:Array;
		private var _preview:MAssetButton1;
		
		public function PetStairsView(mediator:PetMediator)
		{
			_mediator = mediator;
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			
			initView()
			setData(null);
			initEvent();
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.PET1));
			
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
			
			_PetHeadCell = new PetCellBig();
			_PetHeadCell.move(24,19);
//			addChild(_PetHeadCell);
			
			_txtName = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtName.move(18,18);
			addChild(_txtName);
			
			_txtQuality = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtQuality.setLabelType([new TextFormat("Tahoma",16,0xfffccc,true)]);
			_txtQuality.move(63,41);
			addChild(_txtQuality);
			
			_txtSuccessProbability = new MAssetLabel('', MAssetLabel.LABEL_TYPE3);
			_txtSuccessProbability.textColor = 0x66ff00;
			_txtSuccessProbability.move(231,200);
			addChild(_txtSuccessProbability);
			
			_danCell = new DanCell();
			_danCell.move(140,240);
			addChild(_danCell);
			
			_txtDanNumber = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtDanNumber.move(187,250);
//			addChild(_txtDanNumber);
			
			_txtCost = new MAssetLabel('0', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtCost.move(77, 319);
			addChild(_txtCost);
			
			_btnUpgrade = new MCacheAssetBtn1(2, 0, LanguageManager.getWord('ssztl.common.stairs'));
			_btnUpgrade.move(181,310);
			addChild(_btnUpgrade);
			
			_btnUpgradeMask = new MSprite();
			_btnUpgradeMask.graphics.beginFill(0,0);
			_btnUpgradeMask.graphics.drawRect(0,0,75,30);
			_btnUpgradeMask.graphics.endFill();
			_btnUpgradeMask.move(101,165);
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
			
			_preview = new MAssetButton1(new BtnPreviewAsset() as MovieClip);
			_preview.move(407,55);
			addChild(_preview);
			
			_extList = [_starBg,_diamondBg];
//			var _poses:Array = [new Point(370,13),new Point(409,13)];
//			for(var v:int = 0;v<_poses.length;v++)
//			{
//				var sprite:Sprite = new Sprite();
//				sprite.graphics.beginFill(0,0);
//				sprite.graphics.drawRect(_poses[v].x,_poses[v].y,32,32);
//				sprite.graphics.endFill();
//				addChild(sprite);
//				_extList.push(sprite);
//			}
		}
		
		private function setData(e:Event):void
		{
			_currentDanTemplateId = PetUtil.getPetStairPillType(_currentPetInfo.stairs);
			
			_danCell.danInfo = ItemTemplateList.getTemplate(_currentDanTemplateId);
			
			updateCurrentDanAmount();
			
			_qualityLevel = _currentPetInfo.stairs;
			if(_qualityLevel == PetsInfo.PET_STAIRS_MAX)
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
			
//			_txtName.setValue(_currentPetInfo.nick + " " + LanguageManager.getWord('ssztl.common.levelValue', _currentPetInfo.level));
			_txtName.setHtmlValue(
				"<b><font size='14' color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentPetInfo.templateId).quality) +"'>" + _currentPetInfo.nick + "</font></b> " +
				LanguageManager.getWord('ssztl.common.levelValue',_currentPetInfo.level)
			);
			_PetHeadCell.petItemInfo = _currentPetInfo;
			_txtQuality.setHtmlValue(_qualityLevel.toString());
			var rate:int;
			var addtionalRate:int;
			if(_qualityLevel < 2)
			{
				rate = 100;
			}
			else if(_qualityLevel < 4)
			{
				rate = 75;
			}
			else if(_qualityLevel < 6)
			{
				rate = 50;
			}
			else if(_qualityLevel < 8)
			{
				rate = 40;
			}
			else if(_qualityLevel < 9)
			{
				rate = 30;
			}
			else if(_qualityLevel < 10)
			{
				rate = 20;
			}
			else 
			{
				rate = 10;
			}
			var vipType:int = GlobalData.selfPlayer.getVipType();
			if(vipType > VipType.NORMAL)
			{
				addtionalRate = VipTemplateList.getVipTemplateInfo(vipType).petStairRate;
				rate += addtionalRate;
				rate = (rate > 100) ? 100 : rate;
			}
			if(GlobalData.selfPlayer.getVipType()>1)
			{
				switch(GlobalData.selfPlayer.getVipType())
				{
					case 2:
						_txtSuccessProbability.htmlText = LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' +LanguageManager.getWord('ssztl.pet.successRateAddh');
						break;
					case 3:
						_txtSuccessProbability.htmlText = LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' +LanguageManager.getWord('ssztl.pet.successRateAddb');
						break;
				}
				
			}
			else
				_txtSuccessProbability.htmlText = LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' + '</font></b>';
			_txtDanNumber.setValue(''+_currentDanAmount);
			_danCell.amount = _currentDanAmount;
			_txtCost.setValue(getCost());
			
			if(_currentPetInfo.star>-1) _starBg.gotoAndStop(_currentPetInfo.star+1);
			if(_currentPetInfo.diamond>-1) _diamondBg.gotoAndStop(_currentPetInfo.diamond+1);
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
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.addEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
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
			_btnUpgrade.removeEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			
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
			_mediator.initShowPetDevelop();
		}
		private function extOverHandler(evt:MouseEvent):void
		{
			if(!_currentPetInfo) return;
			var index:int = _extList.indexOf(evt.currentTarget);
			var petType:int = _currentPetInfo.type;
			var templateId:int = _currentPetInfo.templateId;
			var starLevel:int = _currentPetInfo.star;
			var diamond:int = _currentPetInfo.diamond;
			var tipStr:String;
			if (index == 0 )
				tipStr = PetStarLevelTip.getInstance().getDataStr(templateId,starLevel);
			else if ( index == 1)
				tipStr = PetDiamondTip.getInstance().getDataStr(petType, templateId, diamond);
			
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function helpTipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.pet.stairsRules'),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
			
		}
		private function handleBtnUpgradeMouseOver(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.pet.stairsMax'),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function handleBtnUpgradeMouseOut(e:Event):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function currentPetChangeHandler(e:PetEvent):void
		{
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			setData(null);
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.PET1)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		private function bagInfoUpdateHandler(event:Event):void
		{
			updateCurrentDanAmount();
			_txtDanNumber.setValue(''+_currentDanAmount);
			_danCell.amount = _currentDanAmount;
		}
		
		private function updateCurrentDanAmount():void
		{
			_currentDanAmount = GlobalData.bagInfo.getItemCountById(_currentDanTemplateId);
		}
		
		private function btnUpgradeClickHandler(event:MouseEvent):void
		{
			if(_currentDanAmount == 0)
			{
				if(_currentDanTemplateId == CategoryType.PET_STAIRS_PILL4 || _currentDanTemplateId == CategoryType.PET_STAIRS_PILL5)
				{
					QuickTips.show(LanguageManager.getWord('ssztl.common.hasNotEnoughpItem'));
				}
				else
				{
					BuyPanel.getInstance().show([_currentDanTemplateId],new ToStoreData(ShopID.STORE));
				}
			}
			else
			{
				PetStatisUpdateSocketHandler.send(_currentPetInfo.id);
				GuideTip.getInstance().hide();
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
			if(_currentPetInfo)
			{
				_currentPetInfo = null;
			}
			if(_txtName)
			{
				_txtName= null;
			}
			if(_txtQuality)
			{
				_txtQuality= null;
			}
			if(_txtDanNumber)
			{
				_txtDanNumber= null;
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
			if(_PetHeadCell)
			{
				_PetHeadCell.dispose();
				_PetHeadCell = null;
			}
			if(_btnUpgrade)
			{
				_btnUpgrade.dispose();
				_btnUpgrade = null;
			}
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
			_txtCost = null;
			_extList = null;
		}
	}
}