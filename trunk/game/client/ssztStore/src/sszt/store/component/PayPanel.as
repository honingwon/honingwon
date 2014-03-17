package sszt.store.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import mx.graphics.codec.JPEGEncoder;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseBigCell;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.store.BtnBuyAsset;
	import ssztui.store.PayItemListAsset;
	import ssztui.store.PayTitleAsset;
	import ssztui.ui.BtnAssetClose;
	

	public class PayPanel extends MSprite implements IPanel
	{
		public static const PANEL_WIDTH:int = 538; 
		public static const PANEL_HEIGHT:int = 200;
		
		private var _bg:IMovieWrapper;
		private var _bgTitle:Bitmap
		private var _dragArea:Sprite;
		private var _btnClose:MAssetButton1;
		private var _banner:Bitmap;
		private var _picPath:String;
		private var _btns:Array;
		private var _cellList:Array;
		private var _idList:Array;
		
		public function PayPanel()
		{
			initView();
			initEvents();
		}
		private function initView():void
		{
			sizeChangeHandler(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_16, new Rectangle(0, 0, PANEL_WIDTH, PANEL_HEIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(135,184,400,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(163,52,355,131),new Bitmap(new PayItemListAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(183,69,50,50),new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(183+89,69,50,50),new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(183+89*2,69,50,50),new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(183+89*3,69,50,50),new Bitmap(CellCaches.getCellBigBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_bgTitle = new Bitmap(new PayTitleAsset());
			_bgTitle.x = 218;
			_bgTitle.y = -27;
			if(GlobalData.functionYellowEnabled)
			{
				addChild(_bgTitle);
			}
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0, 0);
			_dragArea.graphics.drawRect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(PANEL_WIDTH-26,7);
			addChild(_btnClose);
			
			_banner = new Bitmap();
			_banner.x = 1;
			_banner.y = -27;
			addChild(_banner);
			
			_idList = [206100,206101,206102,206103];
			_cellList = [];
			_btns = [];
			for(var i:int=0; i<4; i++){
				var _shopItem:ShopItemInfo = ShopTemplateList.getShop(ShopID.STORE).getItem(_idList[i])
					
				var _cell:BaseBigCell = new BaseBigCell();
				_cell.info = _shopItem.template;
				_cell.move(183+i*89,69);
				addChild(_cell);
				_cellList.push(_cell);
				
				var buy:MAssetButton1 = new MAssetButton1(new BtnBuyAsset());
				buy.move(183+i*89,150);
				addChild(buy);
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(183+i*89,152,50,12),new MAssetLabel(LanguageManager.getWord("ssztl.common.buy"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER)));
				_btns.push(buy);
			}
			
			_picPath = GlobalAPI.pathManager.getActivityBannerPath(40);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_banner.bitmapData = data;
		}
		private function initEvents():void
		{
			for(var i:int = 0; i <_btns.length ; ++i)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_btnClose.addEventListener(MouseEvent.CLICK, closePanel);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		private function removeEvents():void
		{
			for(var i:int = 0; i <_btns.length ; ++i)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK, closePanel);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MAssetButton1);
			var _shopItem:ShopItemInfo = ShopTemplateList.getShop(ShopID.STORE).getItem(_idList[index])
			JSUtils.funPayToken(_shopItem.id,1);
			
		}
		private function closePanel(event:MouseEvent):void
		{
			dispose();
		}
		
		private function dragDownHandler(event:MouseEvent):void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			this.startDrag();
		}
		
		private function dragUpHandler(event:MouseEvent):void
		{
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			this.stopDrag();
		}
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH - PANEL_WIDTH)/2),Math.round((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
		}
		public function doEscHandler():void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvents();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_dragArea)
			{
				_dragArea = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			if(_banner )
			{
				_banner = null;
			}
			dispatchEvent(new Event(Event.CLOSE));
			super.dispose();
		}
		
	}
}