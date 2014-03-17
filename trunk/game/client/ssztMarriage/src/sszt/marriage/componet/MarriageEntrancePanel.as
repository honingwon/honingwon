package sszt.marriage.componet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.WeddingType;
	import sszt.core.data.marriage.MarriageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.marriage.componet.item.CloseView;
	import sszt.marriage.componet.item.WeddingClassItem;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	
	import ssztui.marriage.BtnProgposeAsset;
	import ssztui.marriage.FristWifeAsset;
	import ssztui.marriage.SecondWifeAsset;
	import ssztui.marriage.winBgAsset;
	import ssztui.ui.BtnAssetClose;
	
	public class MarriageEntrancePanel extends MSprite implements IPanel
	{
		public static const PANEL_WIDTH:int = 438;
		public static const PANEL_HEIGHT:int = 492;
		
		private var _bg:IMovieWrapper;
		private var _bgWeltLeft:Bitmap;
		private var _bgWeltRight:Bitmap;
		private var _bgTitle:Bitmap;
		private var _dragArea:Sprite;
		private var _btnClose:MAssetButton1;
		
		private var _marryTargetNickChangeHandler:Function;
		private var _submitHandler:Function;
		
		private var _weddingType:int;
		
		private var _bmpBg:Bitmap;
		
		private var _targetTextfield:TextField;
		private var _friendPointLabel:CloseView;
		
		private var _goodWeddingBtn:WeddingClassItem;
		private var _betterWeddingBtn:WeddingClassItem;
		private var _btnSubmit:MAssetButton1;
		
		private var _weddingBtns:Array;
		private var _currentWeddingBtn:WeddingClassItem;
		private var _currentBtnIndex:int;
		
		private var _typeTag:Bitmap;
		private var _txtExplain1:MAssetLabel;
		private var _txtExplain2:MAssetLabel;
		
		public function MarriageEntrancePanel(marryTargetNickChangeHandler:Function, submitHandler:Function)
		{
			_marryTargetNickChangeHandler = marryTargetNickChangeHandler;
			_submitHandler = submitHandler;
			
			_weddingType = WeddingType.NOTHING;
			_currentBtnIndex = -1;
			
			super();
			initEvent();
			
			setBtnIndex(0);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,0,PANEL_WIDTH,PANEL_HEIGHT),new winBgAsset() as MovieClip),
			]);
			addChild(_bg as DisplayObject);
			
			_bmpBg = new Bitmap();
			_bmpBg.x = _bmpBg.y = 15;
			addChild(_bmpBg);
			
			_bgWeltLeft = new Bitmap();
			_bgWeltLeft.x = -8;
			_bgWeltLeft.y = 11;
			addChild(_bgWeltLeft);
			
			_bgWeltRight = new Bitmap();
			_bgWeltRight.x = PANEL_WIDTH+8;
			_bgWeltRight.y = 11;
			_bgWeltRight.scaleX = -1;
			addChild(_bgWeltRight);
			
			_bgTitle = new Bitmap();
			_bgTitle.x = 102;
			_bgTitle.y = -32;
			addChild(_bgTitle);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,PANEL_WIDTH,30);
			_dragArea.graphics.drawRect(102,-32,233,32);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(PANEL_WIDTH-31,8);
			addChild(_btnClose);
			
			_typeTag = new Bitmap();
			_typeTag.x = 163;
			_typeTag.y = 62;
			addChild(_typeTag);
			if(true)
				_typeTag.bitmapData = new FristWifeAsset() as BitmapData;
			else
				_typeTag.bitmapData = new SecondWifeAsset() as BitmapData;
			
			_targetTextfield = new TextField();
			_targetTextfield.width = 226;
			_targetTextfield.height = 18;
			_targetTextfield.x = 106;
			_targetTextfield.y = 96;
			_targetTextfield.maxChars = 20;
			_targetTextfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xffff00,true,null,null,null,null,TextFormatAlign.CENTER);
			_targetTextfield.type = TextFieldType.INPUT;
			addChild(_targetTextfield);
			_targetTextfield.text = '';
			
			_friendPointLabel = new CloseView();
			_friendPointLabel.move(340, 97);
			addChild(_friendPointLabel);
			
			_goodWeddingBtn = new WeddingClassItem(MarriageInfo.GOOD_RING_ID,MarriageInfo.GOOD_WEDDING_COST,MarriageInfo.GOOD_WEDDING_EXP);
			_goodWeddingBtn.move(34, 187);
			addChild(_goodWeddingBtn);
			
			_betterWeddingBtn = new WeddingClassItem(MarriageInfo.BETTER_RING_ID,MarriageInfo.BETTER_WEDDING_COST,MarriageInfo.BETTER_WEDDING_EXP);
			_betterWeddingBtn.move(34, 290);
			addChild(_betterWeddingBtn);
			
			_weddingBtns = [_goodWeddingBtn, _betterWeddingBtn];
			
			_btnSubmit = new MAssetButton1(new BtnProgposeAsset() as MovieClip);
			_btnSubmit.move(172,438);
			addChild(_btnSubmit);
			
			_txtExplain1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_txtExplain1.move(PANEL_WIDTH/2,125);
			addChild(_txtExplain1);
			_txtExplain1.setHtmlValue(LanguageManager.getWord("ssztl.marriage.demand"));
			
			_txtExplain2 = new MAssetLabel(LanguageManager.getWord("ssztl.marriage.demand2"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_txtExplain2.move(40,398);
			addChild(_txtExplain2);
		}
		
		private function initEvent():void
		{
			_targetTextfield.addEventListener(Event.CHANGE, targetTextFieldChangeHandler);
			_goodWeddingBtn.addEventListener(MouseEvent.CLICK, weddingTypeChangeHandler);
			_betterWeddingBtn.addEventListener(MouseEvent.CLICK, weddingTypeChangeHandler);
			_btnSubmit.addEventListener(MouseEvent.CLICK, submitHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, setPanelPosition);
			_btnClose.addEventListener(MouseEvent.CLICK, closePanel);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		private function removeEvent():void
		{
			_targetTextfield.removeEventListener(Event.CHANGE, targetTextFieldChangeHandler);
			_goodWeddingBtn.removeEventListener(MouseEvent.CLICK, weddingTypeChangeHandler);
			_betterWeddingBtn.removeEventListener(MouseEvent.CLICK, weddingTypeChangeHandler);
			_btnSubmit.removeEventListener(MouseEvent.CLICK, submitHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, setPanelPosition);
			_btnClose.removeEventListener(MouseEvent.CLICK, closePanel);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		public function assetsCompleteHandler():void
		{
			_bmpBg.bitmapData = AssetUtil.getAsset('ssztui.marriage.MarriageEntranceAsset',BitmapData) as BitmapData;
			_bgWeltLeft.bitmapData = AssetUtil.getAsset("ssztui.marriage.WeltAsset",BitmapData) as BitmapData;
			_bgWeltRight.bitmapData = AssetUtil.getAsset("ssztui.marriage.WeltAsset",BitmapData) as BitmapData;
			_bgTitle.bitmapData = AssetUtil.getAsset("ssztui.marriage.WeddingTitleAsset",BitmapData) as BitmapData;
		}
		
		private function weddingTypeChangeHandler(event:MouseEvent):void
		{
			var btn:WeddingClassItem = event.currentTarget as WeddingClassItem;
			var index:int = _weddingBtns.indexOf(btn);
			setBtnIndex(index);
		}
		
		private function submitHandler(event:MouseEvent):void
		{
			_submitHandler(_targetTextfield.text, _weddingType);
		}
		
		private function setBtnIndex(index:int):void
		{
			if(index == _currentBtnIndex) return;
			if(_currentWeddingBtn) _currentWeddingBtn.selected = false;
			_currentBtnIndex = index;
			_currentWeddingBtn = _weddingBtns[_currentBtnIndex];
			_currentWeddingBtn.selected = true;
			_weddingType = _currentBtnIndex + 1;
		}
		
		private function targetTextFieldChangeHandler(event:Event):void
		{
			var nick:String = _targetTextfield.text;
			_marryTargetNickChangeHandler(nick);
		}
		
		public function updateFriendPoint(friendPoint:int):void
		{
			_friendPointLabel.value = friendPoint;
		}
		
		override public function setSize(width1:Number, height1:Number):void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);
			graphics.endFill();
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - PANEL_WIDTH,parent.stage.stageHeight - PANEL_HEIGHT));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		public function doEscHandler():void
		{
			dispose();
		}
		
		private function closePanel(event:MouseEvent):void
		{
			dispose();
		}
		
		private function setPanelPosition(e:Event):void
		{
			move(Math.floor((CommonConfig.GAME_WIDTH - PANEL_WIDTH)/2), Math.floor((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bmpBg && _bmpBg.bitmapData)
			{
				_bmpBg.bitmapData.dispose();
				_bmpBg = null;
			}
			if(_bgWeltLeft && _bgWeltLeft.bitmapData)
			{
				_bgWeltLeft.bitmapData.dispose();
				_bgWeltLeft = null;
			}
			if(_bgWeltRight && _bgWeltRight.bitmapData)
			{
				_bgWeltRight.bitmapData.dispose();
				_bgWeltRight = null;
			}
			if(_bgTitle && _bgTitle.bitmapData)
			{
				_bgTitle.bitmapData.dispose();
				_bgTitle = null;
			}
			if(_typeTag && _typeTag.bitmapData)
			{
				_typeTag.bitmapData.dispose();
				_typeTag = null;
			}
			_marryTargetNickChangeHandler = null;
			_submitHandler = null;
			_targetTextfield = null;
			_txtExplain1 = null;
			_txtExplain2 = null;
			_friendPointLabel = null;
						
			_weddingBtns = null;
			_currentWeddingBtn = null;
			_dragArea = null;
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}