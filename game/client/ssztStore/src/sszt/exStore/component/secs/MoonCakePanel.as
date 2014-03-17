package sszt.exStore.component.secs
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.SoundManager;
	import sszt.exStore.component.StoreCell;
	import sszt.exStore.event.StoreEvent;
	import sszt.exStore.mediator.ExStoreMediator;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.SplitCompartLine2;
	
	/**
	 *  月饼兑换 
	 * @author chendong
	 * 
	 */	
	public class MoonCakePanel extends Sprite implements IExStorePanel
	{
		private var _mediator:ExStoreMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _cells:Array;
		public static const PAGE_SIZE:int = 8;
		private var _shopType:int;
		private var _currentCell:StoreCell;
		
		private var _currentPage:int = 0;
		private var _pageView:PageView;
		
		public function MoonCakePanel(type:int,mediator:ExStoreMediator)
		{
			super();
			_mediator = mediator;
			_shopType = type;
			initView();
			initData();
			inttEvent();
			show();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(6,6,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(187,6,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(6,95,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(187,95,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(6,184,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(187,184,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(6,273,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(187,273,180,88)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,57,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,146,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,235,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,324,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,57,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,146,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,235,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,324,140,5),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,12,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(193,12,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,101,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(193,101,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,190,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(193,190,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,279,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(193,279,50,50),new Bitmap(new CellBigBgAsset()))
			]);
			addChild(_bg as DisplayObject);
			
			_tile = new MTile(180,88,2);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.setSize(361,355);
			_tile.move(6,6);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_cells = new Array();
			for(var i:int=0;i<8;i++)
			{
				var cell:StoreCell = new StoreCell(_shopType);
				cell.addEventListener(MouseEvent.CLICK,clickHandler);
				_cells.push(cell);
				_tile.appendItem(cell);
			}
			
			_pageView = new PageView(1,false,110);
			_pageView.move(132,365);
			addChild(_pageView);
			_pageView.visible = true;
			
			_pageView.totalRecord = ShopTemplateList.getShop(_shopType).shopItemInfos[0].length;
			_pageView.pageSize = PAGE_SIZE;
		}
		
		private function initData():void
		{
			showGoods(_currentPage);
		}
		
		private function inttEvent():void
		{
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeExploitHandler);
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var cell:StoreCell = evt.currentTarget as StoreCell;
			if(cell.shopItem)
			{
				if(_currentCell) _currentCell.selected = false;
				_currentCell = cell;
				_currentCell.selected = true;
			}
		}
		
		private function pageChangeExploitHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			_currentPage = _pageView.currentPage - 1;
			showGoods(_currentPage); 
		}
		
		private function clearCell():void
		{
			for(var i:int =0;i<_cells.length;i++)
			{
				_cells[i].shopItem = null;
			}
		}
		
		public function showGoods(page:int,type:int=0):void
		{
			clearCell();
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			var list:Array = shop.getItems(PAGE_SIZE,page,0);
			for(var i:int =0;i<list.length;i++)
			{
				_cells[i].shopItem = list[i];
			}
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
			_mediator.storeModule.cheapInfo.removeEventListener(StoreEvent.DISCOUNT_UPDATE,discountHandler);
		}
		
		public function show():void
		{
			this.visible = true;
			_mediator.storeModule.cheapInfo.addEventListener(StoreEvent.DISCOUNT_UPDATE,discountHandler);
		}
		
		private function discountHandler(e:StoreEvent):void
		{
			_mediator.storeModule.dispatchEvent(new StoreEvent(StoreEvent.COUNT_CHANGE));
		}
		
		private function removeEvent():void
		{
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeExploitHandler);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_cells)
			{
				for(var i:int =0;i<_cells.length;i++)
				{
					_cells[i].removeEventListener(MouseEvent.CLICK,clickHandler);
					_cells[i].dispose();
				}
				_cells = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			_currentCell = null;
			hide();
			_mediator = null;
			
		}
	}
}