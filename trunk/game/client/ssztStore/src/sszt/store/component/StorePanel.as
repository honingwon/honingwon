package sszt.store.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.store.mediator.StoreMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	
	import ssztui.store.ItemSelectedBgAsset;
	import ssztui.store.TitleAsset;
	import ssztui.store.YellowVipAdAsset;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;
	import ssztui.ui.TitleBackgroundLeftAsset;
	import ssztui.ui.TitleBackgroundRightAsset;
	
	public class StorePanel extends MSprite implements IPanel
	{
		public static var copperAsset:BitmapData;
		public static var bindCopperAsset:BitmapData;
		public static var yuanBaoAsset:BitmapData;
		public static var bindYuanBaoAsset:BitmapData;
		public static var qqMoneyAsset:BitmapData;
		
		public static const PANEL_WIDTH:int = 736;
		public static const PANEL_HEIGHT:int = 435;
		
		private var _mediator:StoreMediator;
		private var _toStoreData:ToStoreData;
		
		private var _bg:IMovieWrapper;
		
		private var _currentIndex:int;
		private var _btns:Array;		
		private var _tabPanels:Array;		
		private var _classes:Array;
		
		private var _closeBtn:MAssetButton1;
		private var _dragArea:Sprite;
		private var _assetsComplete:Boolean;
		
		private var _picPath:String
		private var _peri:Bitmap;
		private var _tabViewBox:Sprite;		
		public static var selectBorder:Bitmap;			
		private var _quickBuy:QuickBuyPanel;
		private var _myMoney:MyMoneyView;
		
		public function StorePanel(mediator:StoreMediator,data:ToStoreData)
		{
			copperAsset = MoneyIconCaches.copperAsset;
			bindCopperAsset = MoneyIconCaches.bingCopperAsset;
			yuanBaoAsset = MoneyIconCaches.yuanBaoAsset;
			bindYuanBaoAsset = MoneyIconCaches.bingYuanBaoAsset;
			qqMoneyAsset = MoneyIconCaches.qqMoneyAsset;
			
			_mediator = mediator;			
			_toStoreData = data;
			_currentIndex = 1;
			selectBorder = new Bitmap(new ItemSelectedBgAsset());
			
			init();
			initEvent();
		}
		
		protected function init():void
		{
			sizeChangeHandler(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_1, new Rectangle(0,0,PANEL_WIDTH,PANEL_HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(87,65,641,362)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(91,69,633,309)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(91,380,633,41)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(91,70,633,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(91,420,633,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(308,12,28,18),new Bitmap(new TitleBackgroundLeftAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(405,12,28,18),new Bitmap(new TitleBackgroundRightAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(340,8,60,26),new Bitmap(new TitleAsset())),
			]);
			addChild(_bg as DisplayObject);
			
//			-64,-10
			_peri = new Bitmap();
			_peri.y = 22;
			_peri.x = -213;
			addChild(_peri);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,PANEL_WIDTH,40);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_tabViewBox = new Sprite();
			addChild(_tabViewBox);
		
			_classes = [QStoreView, SilverStoreView,BindSilverStoreView];
			
			_btns = new Array();
			var shopCategoryNames:Array = [LanguageManager.getWord('ssztl.common.qMoneyMarket'),LanguageManager.getWord('ssztl.common.goldMarket'),LanguageManager.getWord('ssztl.common.bindYuanBao2')]
			for(var i:int =0;i<shopCategoryNames.length;i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,shopCategoryNames[i]);
				btn.move(94+i*69,40);
				_btns.push(btn);
//				addChild(btn);
			}
			
			_btns[_currentIndex].selected = true;
			
			_tabPanels = new Array();
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(PANEL_WIDTH-28,6);
			addChild(_closeBtn);
			
			//快速购买
			_quickBuy = new QuickBuyPanel();
			_quickBuy.move(PANEL_WIDTH-2,0);
//			addChild(_quickBuy);
			
			_myMoney = new MyMoneyView();
			_myMoney.move(103,390);
			addChild(_myMoney);
			_myMoney.visible = false;
			
			setTabPanel(_currentIndex);
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			for(var i:int = 0; i < _tabPanels.length; i++)
			{
				if(_tabPanels[i] != null)
					(_tabPanels[i]).assetsCompleteHandler();
			}
			_picPath = GlobalAPI.pathManager.getStorePeriPath();
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_peri.bitmapData = data;
		}
		
		private function setTabPanel(index:int):void
		{
			if(_tabPanels[index] == null)
			{
				_tabPanels[index] = new _classes[index](_mediator,_toStoreData);
				if(_assetsComplete)
				{
					(_tabPanels[index]).assetsCompleteHandler();
				}
				_tabPanels[index].move(91,69);
			}
			_tabViewBox.addChild(_tabPanels[index] as DisplayObject);
			
			_myMoney.visible = index>0?true:false;
		}
		
		private function initEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
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
			move(Math.round((CommonConfig.GAME_WIDTH - PANEL_WIDTH)/2),Math.round((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btns.indexOf(evt.currentTarget);
			if(_currentIndex == index) return;
			_tabPanels[_currentIndex].hide();
			_btns[_currentIndex].selected = false;
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			setTabPanel(_currentIndex);
		}
		
		public function doEscHandler():void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_peri && _peri.bitmapData)
			{
//				_peri.bitmapData.dispose();
				_peri = null;
			}
			if(_btns)
			{
				for(var i:int =0;i<_btns.length;i++)
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
				_btns = null;
			}
			if(_tabPanels)
			{
				for(var j:int=0;j<_tabPanels.length;j++)
				{
					if(_tabPanels[j])
					{
						_tabPanels[j].dispose();
						_tabPanels[j] = null;
					}
				}
				_tabPanels = null;
			}
			if(copperAsset)
			{
//				copperAsset.dispose();
				copperAsset = null;
			}
			if(bindCopperAsset)
			{
//				bindCopperAsset.dispose();
				bindCopperAsset = null;
			}
			if(yuanBaoAsset)
			{
//				yuanBaoAsset.dispose();
				yuanBaoAsset = null;
			}
			if(bindYuanBaoAsset)
			{
//				bindYuanBaoAsset.dispose();
				bindYuanBaoAsset = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn = null;
			}
			if(_myMoney)
			{
				_myMoney.dispose();
				_myMoney = null;
			}
			_dragArea = null;
			selectBorder = null;
			_classes = null;
			_mediator = null;
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}