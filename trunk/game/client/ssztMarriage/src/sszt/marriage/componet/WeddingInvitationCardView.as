package sszt.marriage.componet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.marriage.WeddingInvitationInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.marriage.PresentGiftBtnAsset;
	
	/**
	 * 请柬
	 * */
	public class WeddingInvitationCardView extends MSprite implements IPanel
	{
		public static const PANEL_WIDTH:int = 549;
		public static const PANEL_HEIGHT:int = 388;
		
		private var _bg:Bitmap;
		private var _photo:Bitmap;
		private var _dragArea:Sprite;
		
		private var _nameBridegroom:MAssetLabel;
		private var _nameBride:MAssetLabel;
		private var _inviteWords:MAssetLabel;
		private var _presentCashGiftHandler:Function;
		private var _btnPresentGift:MAssetButton1;
		private var _btnPresentGift2:MAssetButton1;
		private var _btnPresentGift3:MAssetButton1;
		private var _info:WeddingInvitationInfo;
		private var _holdOn:MAssetLabel;
		private var _holdOnBtn:Sprite;
		
		public function WeddingInvitationCardView(info:WeddingInvitationInfo,presentCashGiftHandler:Function)
		{
			_info = info;
			_presentCashGiftHandler = presentCashGiftHandler;
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setPanelPosition(null);
			graphics.beginFill(0x000000,0.5);
			graphics.drawRect(0,0,PANEL_WIDTH,PANEL_HEIGHT);
			graphics.endFill();
			
			_bg = new Bitmap();
			addChild(_bg);
			
			_photo = new Bitmap();
			_photo.x = 12;
			_photo.y = 60;
			addChild(_photo);
			
			_nameBridegroom = new MAssetLabel(_info.nick1,MAssetLabel.LABEL_TYPE_YAHEI);
			_nameBridegroom.move(155,258);
			addChild(_nameBridegroom);
			_nameBridegroom.setValue(_info.nick1);
			
			_nameBride = new MAssetLabel(_info.nick2,MAssetLabel.LABEL_TYPE_YAHEI);
			_nameBride.move(155,293);
			addChild(_nameBride);
			_nameBride.setValue(_info.nick2);
			
			_inviteWords = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_inviteWords.textColor = 0x0f0f0f;
			_inviteWords.wordWrap = true;
			_inviteWords.move(296,35);
			_inviteWords.setSize(230,125);
			addChild(_inviteWords);
			_inviteWords.setHtmlValue(LanguageManager.getWord("ssztl.marriage.inviteWords"));
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,PANEL_WIDTH,PANEL_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			graphics.beginFill(0,0.5);
			graphics.drawRect(0,0,300,300);
			graphics.endFill();
			
			_btnPresentGift = new MAssetButton1(new PresentGiftBtnAsset());
			_btnPresentGift.label = LanguageManager.getWord("ssztl.marriage.presentGiftLabel1");
			_btnPresentGift.move(333,204);
			addChild(_btnPresentGift);
			
			_btnPresentGift2 = new MAssetButton1(new PresentGiftBtnAsset());
			_btnPresentGift2.label = LanguageManager.getWord("ssztl.marriage.presentGiftLabel2");
			_btnPresentGift2.move(333,234);
			addChild(_btnPresentGift2);
			
			_btnPresentGift3 = new MAssetButton1(new PresentGiftBtnAsset());
			_btnPresentGift3.label = LanguageManager.getWord("ssztl.marriage.presentGiftLabel3");
			_btnPresentGift3.move(333,264);
			addChild(_btnPresentGift3);
			
			_holdOn = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_holdOn.textColor = 0x910000;
			_holdOn.move(410,313);
			addChild(_holdOn);
			_holdOn.setHtmlValue("<u>稍后再说</u>");
			_holdOnBtn = new Sprite();
			_holdOnBtn.graphics.beginFill(0,0);
			_holdOnBtn.graphics.drawRect(410-_holdOn.textWidth/2,313,_holdOn.textWidth,_holdOn.textHeight);
			_holdOnBtn.graphics.endFill();
			addChild(_holdOnBtn);
			_holdOnBtn.buttonMode = true;
		}
		
		private function initEvent():void
		{
			_btnPresentGift.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_btnPresentGift2.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_btnPresentGift3.addEventListener(MouseEvent.CLICK,btnClickHandler);
			
			_holdOnBtn.addEventListener(MouseEvent.CLICK,holdOnBtnClickHandler);
			
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		protected function holdOnBtnClickHandler(event:MouseEvent):void
		{
			dispose();
		}
		
		private function removeEvent():void
		{
			_btnPresentGift.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_btnPresentGift2.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_btnPresentGift3.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			
			_holdOnBtn.removeEventListener(MouseEvent.CLICK,holdOnBtnClickHandler);
			
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var btn:MAssetButton1 = e.currentTarget as MAssetButton1;
			var type:int;
			switch(btn)
			{
				case _btnPresentGift :
					type = 1;
					break;
				case _btnPresentGift2 :
					type = 2;
					break;
				case _btnPresentGift3 :
					type = 3;
					break;
			}
			_presentCashGiftHandler(_info.userId,type);
//			dispose();
		}
		public function assetsCompleteHandler():void
		{
			graphics.clear();
			_bg.bitmapData = AssetUtil.getAsset('ssztui.marriage.WeddingInvitationCardAsset',BitmapData) as BitmapData;
			_photo.bitmapData = AssetUtil.getAsset('ssztui.marriage.WeddingPhotoAsset1',BitmapData) as BitmapData;
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
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_btnPresentGift)
			{
				_btnPresentGift.dispose();
				_btnPresentGift = null;
			}
			if(_btnPresentGift2)
			{
				_btnPresentGift2.dispose();
				_btnPresentGift2 = null;
			}
			if(_btnPresentGift3)
			{
				_btnPresentGift3.dispose();
				_btnPresentGift3 = null;
			}
			if(_holdOnBtn)
			{
				_holdOnBtn.graphics.clear();
				_holdOnBtn = null;
			}
			_holdOn = null;
			_nameBridegroom = null;
			_nameBride = null;
			_inviteWords = null;
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}