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
	import sszt.constData.SourceClearType;
	import sszt.constData.VipType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.pet.PetXisuiUpdateSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseLoadEffect;
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
	import sszt.pet.component.items.XisuItemView;
	import sszt.pet.data.PetAttrAttackType;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.pet.socketHandler.PetStatisUpdateSocketHandler;
	import sszt.pet.util.PetUtil;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MSelectButton;
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
	import ssztui.pet.xisuiBtnAsset1;
	import ssztui.pet.xisuiBtnAsset2;
	import ssztui.pet.xisuiBtnAsset3;
	import ssztui.ui.SplitCompartLine;
	
	public class PetXisuView extends Sprite implements IPetView
	{
		private var _mediator:PetMediator;
		private var _bg:IMovieWrapper;
		private var _currentPetInfo:PetItemInfo;
		private var _qualityLevel:int;
		private var _qualityLevelMax:int;
		private var _currentDanAmount:int;
		private var _currentDanTemplateId:int;
		
		private var _bgImg:Bitmap;
		private var _txtName:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtCost:MAssetLabel;
		
		private var _btnStartXisu:MCacheAssetBtn1;
		
		private var _helpTip:MSprite;
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _extList:Array;
		private var _preview:MAssetButton1;
		
		private var _selectedType:int;
		private var _sortBtnBg:Array;
		private var _sortBtnList:Array;
		private var _selectedBtn:XisuItemView;
		private var _currentBtn:XisuItemView;
		
		public function PetXisuView(mediator:PetMediator)
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
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(18,44,48,18), txtBgQuality ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(391,319,50,15), new MAssetLabel(LanguageManager.getWord('ssztl.common.ruleIntro'), MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(373,320,15,15), new Bitmap(new HelpIconAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(61,318,18,18), new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(29,319,50,18), new MAssetLabel(LanguageManager.getWord('ssztl.common.fare'), MAssetLabel.LABEL_TYPE_TAG,TextFieldAutoSize.LEFT)),
			]);
			addChild(_bg as DisplayObject);
			
			_txtName = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtName.move(18,18);
			addChild(_txtName);
			
			_txtQuality = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtQuality.setLabelType([new TextFormat("Tahoma",16,0xfffccc,true)]);
			_txtQuality.move(63,41);
			addChild(_txtQuality);
			
			_txtCost = new MAssetLabel('10', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtCost.move(77, 319);
			addChild(_txtCost);
			
			_btnStartXisu = new MCacheAssetBtn1(2, 0, LanguageManager.getWord('ssztl.pet.wash'));
			_btnStartXisu.move(181,310);
			addChild(_btnStartXisu);
			
			_sortBtnList = [];
			for(var i:int=0; i<3; i++)
			{
				var sortBtn:XisuItemView = new XisuItemView(i);
				sortBtn.move(110+i*90,197);
				addChild(sortBtn);
				_sortBtnList.push(sortBtn);
			}
			
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
			
		}
		
		private function setData(e:Event):void
		{
			_selectedType = _currentPetInfo.type;
			if(_currentBtn)
				_currentBtn.currentType = false;
			switch(_currentPetInfo.type)
			{
				case PetAttrAttackType.FAR_ATTACK :
					_currentBtn = _sortBtnList[0];
					break;
				case PetAttrAttackType.OUTER_ATTACK :
					_currentBtn = _sortBtnList[1];
					break;
				case PetAttrAttackType.INNER_ATTACK :
					_currentBtn = _sortBtnList[2];
					break;
			}
			_currentBtn.currentType = true;
			
			_currentDanTemplateId = PetUtil.getPetStairPillType(_currentPetInfo.stairs);			
			updateCurrentDanAmount();
			
			_qualityLevel = _currentPetInfo.stairs;
			_txtName.setHtmlValue(
				"<b><font size='14' color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentPetInfo.templateId).quality) +"'>" + _currentPetInfo.nick + "</font></b> " +
				LanguageManager.getWord('ssztl.common.levelValue',_currentPetInfo.level)
			);
			_txtQuality.setHtmlValue(_qualityLevel.toString());

			
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
			_btnStartXisu.addEventListener(MouseEvent.CLICK, startXisuHandler);
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
			
			for(var i:int = 0; i < 3; i++)
			{
				_sortBtnList[i].addEventListener(MouseEvent.CLICK, listClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			_btnStartXisu.removeEventListener(MouseEvent.CLICK, startXisuHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			
			_preview.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			for(var j:int = 0 ;j< _extList.length ; ++j)
			{
				_extList[j].removeEventListener(MouseEvent.MOUSE_OVER,extOverHandler);
				_extList[j].removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
			for(var i:int = 0; i < 3; i++)
			{
				_sortBtnList[i].removeEventListener(MouseEvent.CLICK, listClickHandler);
			}
		}
		private function btnClickHandler(event:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.initShowPetDevelop();
		}
		private function listClickHandler(event:MouseEvent):void
		{
			var targetBtn:XisuItemView = event.currentTarget as XisuItemView;
			
			if(_selectedBtn && _selectedBtn == targetBtn)
			{
				return;
			}
			var index:int = _sortBtnList.indexOf(targetBtn);
			switch(index)
			{
				case 0: 
					_selectedType = PetAttrAttackType.FAR_ATTACK;
					break;
				case 1: 
					_selectedType = PetAttrAttackType.OUTER_ATTACK;
					break;
				case 2: 
					_selectedType = PetAttrAttackType.INNER_ATTACK;
					break;
			}
			if(_selectedBtn)
			{
				_selectedBtn.selected = false;
			}
			_selectedBtn = targetBtn;
			_selectedBtn.selected = true;
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
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.pet.washDescript'),null,new Rectangle(evt.stageX,evt.stageY,0,0));
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
			if(_selectedBtn && _selectedBtn != _currentBtn)
			{
				_selectedBtn.selected = false;
			}
			_selectedBtn = null;
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
		}
		
		private function updateCurrentDanAmount():void
		{
			_currentDanAmount = GlobalData.bagInfo.getItemCountById(_currentDanTemplateId);
		}
		
		private function startXisuHandler(event:MouseEvent):void
		{
			PetXisuiUpdateSocketHandler.send(_mediator.module.petsInfo.currentPetItemInfo.id, _selectedType);
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
			if(_btnStartXisu)
			{
				_btnStartXisu.dispose();
				_btnStartXisu = null;
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