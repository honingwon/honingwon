package sszt.pet.component.popup
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
	import flash.text.TextFormatAlign;
	
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pet.PetXisuiUpdateSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.pet.data.PetAttrAttackType;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.TitleAsset;
	import ssztui.pet.TitleXSAsset;
	import ssztui.pet.xisuiBtnAsset1;
	import ssztui.pet.xisuiBtnAsset2;
	import ssztui.pet.xisuiBtnAsset3;
	
	public class PetXisuPanel extends MPanel
	{
		private var _mediator:PetMediator;
		
		private var _bg:IMovieWrapper;
		private var _xsBg:Bitmap;
		private var _sortBtnBg:Array;
		private var _sortBg:Sprite;
		private var _sortBtnList:Array;		
		private var _btnStartXisu:MCacheAssetBtn1;
		private var _washExplain:MAssetLabel;
		
		private var _selectedBtn:MSelectButton;
		private var _selectedType:int;
		private var _currentPetInfo:PetItemInfo;
		
		
		public function PetXisuPanel(mediator:PetMediator)
		{
			_mediator = mediator;
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			super(new MCacheTitle1("", new Bitmap(new TitleXSAsset())), true,-1);
			setData(null);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(316,380);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,3,300,370)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(15,10,286,240)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(15,253,286,112)),
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(17,255,282,26)),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(203, 186, 16, 14), new Bitmap(MoneyIconCaches.yuanBaoAsset)),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(102, 187, 80, 16), new MAssetLabel(LanguageManager.getWord('ssztl.pet.xisuiCost') + ' 10', MAssetLabel.LABEL_TYPE8, 'left')),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(118,259,80,16), new MAssetLabel(LanguageManager.getWord('ssztl.pet.washExplain'), MAssetLabel.LABEL_TYPE_TITLE2)),
			]);
			addContent(_bg as DisplayObject);
			_xsBg = new Bitmap();
			_xsBg.x = 17;
			_xsBg.y = 12;
			addContent(_xsBg);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(102,185,80,16), new MAssetLabel(LanguageManager.getWord('ssztl.pet.xisuiCost') + ' 10', MAssetLabel.LABEL_TYPE8,'left')));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(197,184,18,18), new Bitmap(MoneyIconCaches.yuanBaoAsset)));
			
			_washExplain = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_washExplain.wordWrap = true;
			_washExplain.setSize(270,90);
			_washExplain.move(22,282);
			_washExplain.setHtmlValue(LanguageManager.getWord('ssztl.pet.washDescript'));
			addContent(_washExplain);
			
			_sortBg = new Sprite();
			addContent(_sortBg);
			
			_sortBtnBg = [];			
			_sortBtnList = [];
			var classArray:Array = [xisuiBtnAsset1,xisuiBtnAsset2,xisuiBtnAsset3];
			var pos:Array = [new Point(37,46),new Point(128,15),new Point(218,46)];
			for(var i:int=0; i<3; i++)
			{
				var sortBtn:MSelectButton = new MSelectButton(classArray[i],"",60,60);
				sortBtn.x = pos[i].x;
				sortBtn.y = pos[i].y;
				addContent(sortBtn);
				_sortBtnList.push(sortBtn);
			}
			
			_btnStartXisu = new MCacheAssetBtn1(2,1,LanguageManager.getWord('ssztl.pet.wash'));
			_btnStartXisu.move(109,207);
			addContent(_btnStartXisu);
			
			if(_mediator.module.assetsReady)
			{
				assetsCompleteHandler();
			}
		}
		
		private function initEvent():void
		{
			_btnStartXisu.addEventListener(MouseEvent.CLICK, startXisu);
			for(var i:int = 0; i < 3; i++)
			{
				MSelectButton(_sortBtnList[i]).addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			_mediator.module.petsInfo.addEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnStartXisu.removeEventListener(MouseEvent.CLICK, startXisu);
			for(var i:int = 0; i < 3; i++)
			{
				MSelectButton(_sortBtnList[i]).removeEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
		}
		
		private function currentPetChangeHandler(e:Event):void
		{
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			setData(null);
		}
		
		private function setData(e:Event):void
		{
			_selectedType = _currentPetInfo.type;
			if(_selectedBtn)
			{
				_selectedBtn.selected = false;
				if(_mediator.module.assetsReady)
				{
					_sortBtnBg[_sortBtnList.indexOf(_selectedBtn)].gotoAndStop(1);
				}
			}
			switch(_currentPetInfo.type)
			{
				case PetAttrAttackType.FAR_ATTACK :
					_selectedBtn = _sortBtnList[0];
					break;
				case PetAttrAttackType.OUTER_ATTACK :
					_selectedBtn = _sortBtnList[1];
					break;
				case PetAttrAttackType.INNER_ATTACK :
					_selectedBtn = _sortBtnList[2];
					break;
			}
			_selectedBtn.selected = true;
			if(_mediator.module.assetsReady)
			{
				_sortBtnBg[_sortBtnList.indexOf(_selectedBtn)].gotoAndStop(2);
			}
		}
		
		private function btnClickHandler(event:MouseEvent):void
		{
			var targetBtn:MSelectButton = event.currentTarget as MSelectButton;
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
				if(_mediator.module.assetsReady)
				{
					_sortBtnBg[_sortBtnList.indexOf(_selectedBtn)].gotoAndStop(1);
				}
			}
			_selectedBtn = targetBtn;
			_selectedBtn.selected = true;
			if(_mediator.module.assetsReady)
			{
				_sortBtnBg[_sortBtnList.indexOf(_selectedBtn)].gotoAndStop(2);
			}
		}
		
		private function startXisu(e:Event):void
		{
			PetXisuiUpdateSocketHandler.send(_mediator.module.petsInfo.currentPetItemInfo.id, _selectedType);
		}
		
		public function assetsCompleteHandler():void
		{
//			_xsBg.bitmapData = AssetUtil.getAsset('ssztui.pet.WashBgAsset',BitmapData) as BitmapData;
//			for(var i:int=0; i<3; i++){
//				var _btnBg:MovieClip = AssetUtil.getAsset('ssztui.pet.xisuiBtnBgAsset'+i,MovieClip) as MovieClip;
//				_btnBg.x = _sortBtnList[i].x;
//				_btnBg.y = _sortBtnList[i].y;
//				_sortBg.addChild(_btnBg);
//				_sortBtnBg.push(_btnBg);
//			}
//			//当前属性动画
//			_sortBtnBg[2].gotoAndStop(2);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_xsBg){
				_xsBg.bitmapData.dispose();
				_xsBg = null;
			}
			if(_btnStartXisu && _btnStartXisu.parent)
			{
				_btnStartXisu.parent.removeChild(_btnStartXisu);
				_btnStartXisu = null;
			}
			if(_sortBtnBg && _sortBtnBg.length >0)
			{
				for(var i:int=0; i<_sortBtnBg.length; i++)
				{
					if(_sortBtnBg[i].parent) _sortBtnBg[i].parent.removeChild(_sortBtnBg[i]);					
				}
				_sortBg = null;
				_sortBtnBg = null;
			}
			_washExplain = null;
		}
		
	}
}