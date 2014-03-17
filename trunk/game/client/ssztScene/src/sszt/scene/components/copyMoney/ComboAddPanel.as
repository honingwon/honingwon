package sszt.scene.components.copyMoney
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.BigMapMediator;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheCloseBtn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	

	public class ComboAddPanel extends MSprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _mediator:SceneMediator;
		private var _closeBtn:MCacheCloseBtn;
		private var _textData:MAssetLabel;
		private var _textTips:MAssetLabel;
		
		public function ComboAddPanel(argMediator:SceneMediator)
		{
			_mediator = argMediator;
			super();
		}
		override protected function configUI() : void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([				
				new BackgroundInfo(BackgroundType.BORDER_ALERT,new Rectangle(0,0,256,320)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,83,222,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,215,222,2),new MCacheSplit2Line()),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(32,49,194,23),new Bitmap(new ComboTextAddAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,7,256,14),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.titleName"),MAssetLabel.LABEL_TYPE_TITLE)),
			]);
			addChild(_bg as DisplayObject);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,256,30);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_closeBtn = new MCacheCloseBtn();
			_closeBtn.move(227,4);
			addChild(_closeBtn);
			
			_textData = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_textData.setSize(222,110);
			_textData.move(49,100);
			_textData.setHtmlValue(LanguageManager.getWord("ssztl.scene.killAdditionValue"));
			addChild(_textData);
			
			_textTips = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_textTips.textColor = 0x68b800;
			_textTips.setSize(220,54);
			_textTips.move(20,220);
			_textTips.wordWrap = true;
			_textTips.multiline = true;
			_textTips.setHtmlValue(LanguageManager.getWord("ssztl.moneycopy.killAdditionPrompt"));
			addChild(_textTips);
			
			initEvent();
		}
		private function initEvent() : void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		private function removeEvent() : void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - width,parent.stage.stageHeight - height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		public function doEscHandler():void
		{
			dispose();
			
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		override public function dispose() : void
		{
			this.removeEvent();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_dragArea = null;
			this._mediator = null;
			_textData = null;
			_textTips = null;
			if(parent)parent.removeChild(this);
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}