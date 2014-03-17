package sszt.scene.components.gift
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.gift.GiftItemCell;
	import sszt.scene.mediators.NewcomerGiftMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;

	public class OnlineGiftPanel extends MSprite implements IPanel
	{
		private var _mediator:NewcomerGiftMediator;
		private var _bg:IMovieWrapper;
		private var _dragArea:MSprite;
		private var _btnClose:MAssetButton1;
		
		private var _countDown:CountDownView;
		private var _depict:MAssetLabel;
		private var _cells:Array;
		private var _btnGetGift:MCacheAssetBtn1;
		private var _btnWait:MCacheAssetBtn1;
		
		public static const DEFAULT_WIDTH:int = 250;
		public static const DEFAULT_HEIGHT:int = 256;
		
		public function OnlineGiftPanel()
		{
			init();
			initEvent();
		}
		protected function init():void
		{
			
			GlobalAPI.layerManager.getPopLayer().addChild(this);
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2, new Rectangle(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_3, new Rectangle(22,50,206,151)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(75,16,100,30),new Bitmap(AssetUtil.getAsset("ssztui.common.OnlineGifTitleAsset") as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,124,206,25),new Bitmap(new SplitCompartLine2())),
				
			]);
			addChild(_bg as DisplayObject);
			
			_dragArea = new MSprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,50);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(219,10);
			addChild(_btnClose);
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("Tahoma",24,0x33ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.setSize(150,30);
			_countDown.move(50,62);
			addChild(_countDown);
			_countDown.start(6000);
			
			_depict = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_depict.move(125,99);
			addChild(_depict);
			_depict.setHtmlValue(LanguageManager.getWord("ssztl.common.onlineGiftTipWait"));
			
			_cells = [];
			var amount:int = 2;
			for(var i:int=0; i<amount; i++)
			{
				var b:Bitmap = new Bitmap(CellCaches.getCellBg());
				b.x = 125+i*42-amount*20;
				b.y = 141;
				addChild(b);
				
				var c:GiftItemCell = new GiftItemCell();
				c.move(125+i*42-amount*20,141);
				addChild(c);
				_cells.push(c);
			}
			
			_btnGetGift = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.common.onlineGet'));
			_btnGetGift.move(75,208);
			addChild(_btnGetGift);
			
			_btnWait = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.common.onlineGetWait'));
			_btnWait.move(75,208);
			addChild(_btnWait);
			_btnWait.visible = false;
		}
		private function initEvent():void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);	
		}
		private function removeEvent():void
		{
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);	
		}
		private function setPanelPosition(e:Event):void
		{
			move( (CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - DEFAULT_WIDTH,parent.stage.stageHeight - DEFAULT_HEIGHT));
		}
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
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
			super.dispose();
			removeEvent();
			dispatchEvent(new Event(Event.CLOSE));
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			if(_dragArea)
			{
				_dragArea.dispose();
				_dragArea = null;
			}
			if(_btnGetGift){
				_btnGetGift.dispose();
				_btnGetGift = null;
			}
			if(_btnWait){
				_btnWait.dispose();
				_btnWait = null;
			}
			_depict = null;
		}
	}
}