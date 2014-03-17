package sszt.activity.components.panels
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.activity.BtnGetMoneyAsset;
	import ssztui.ui.BtnAssetClose;
	
	public class GetCopperPanel extends MSprite implements IPanel
	{
		public static const PANEL_WIDTH:int = 297;
		public static const PANEL_HEIGHT:int = 426;
		private var _bg:Bitmap;
		private var _picPath:String;
		
		private var _closeBtn:MAssetButton1;
		private var _dragArea:Sprite;
		private var _tip:MAssetLabel;
		private var _amount:MAssetLabel;
		
		private var _efBox:MSprite;
		private var _openEffect:BaseLoadEffect;
		private var _mainBtn:MAssetButton1;
		
		public function GetCopperPanel()
		{
			init();
			initEvent();
		}
		
		protected function init():void
		{
			sizeChangeHandler(null);
			
			_bg = new Bitmap();
			addChild(_bg);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0x000000,0.3);
			_dragArea.graphics.drawRect(0,0,PANEL_WIDTH,PANEL_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(PANEL_WIDTH-24,1);
			addChild(_closeBtn);
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_tip.move(PANEL_WIDTH/2,275);
			addChild(_tip);
			_tip.setHtmlValue(LanguageManager.getWord("ssztl.exchange.getMoneyTip",20,54000));
			
			_amount = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_amount.move(PANEL_WIDTH/2,380);
			addChild(_amount);
			_amount.setHtmlValue(LanguageManager.getWord("ssztl.exchange.getMoneyAmount",10));
			
			_tip.textColor = _amount.textColor = 0x502500;
			
			_mainBtn = new MAssetButton1(new BtnGetMoneyAsset());
			_mainBtn.move(103,333);
			addChild(_mainBtn);
			
			_efBox = new MSprite();
			_efBox.move(152,170);
			addChild(_efBox);
			_efBox.rotation = 90;
			
			_picPath = GlobalAPI.pathManager.getBannerPath("exchangeCopper.jpg"); 
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bg.bitmapData = data;
			if(_dragArea)
			{
				_dragArea.graphics.clear();
				_dragArea.graphics.beginFill(0,0);
				_dragArea.graphics.drawRect(0,0,PANEL_WIDTH,PANEL_HEIGHT);
				_dragArea.graphics.endFill();
			}
		}
		private function initEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_mainBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		private function removeEvent():void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			_mainBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			if(!_openEffect)
			{
				_openEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.BOX_EFFECT));
				_openEffect.addEventListener(Event.COMPLETE,effectCompleteHandler);
				_openEffect.play(SourceClearType.TIME,300000);
			}
			if(_openEffect.parent != this)
			{
				_efBox.addChild(_openEffect);
			}
		}
		private function effectCompleteHandler(evt:Event):void
		{
			if(_openEffect)
			{
				_openEffect.removeEventListener(Event.COMPLETE,effectCompleteHandler);
				_openEffect.dispose();
				_openEffect = null;
			}
		}
		
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - PANEL_WIDTH,parent.stage.stageHeight - PANEL_HEIGHT));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH/2 + 2)),Math.round((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		public function doEscHandler():void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_bg = null;
			_tip = null;
			_amount = null;
			if(_openEffect)
			{
				_openEffect.removeEventListener(Event.COMPLETE,effectCompleteHandler);
				_openEffect.dispose();
				_openEffect = null;
			}
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}