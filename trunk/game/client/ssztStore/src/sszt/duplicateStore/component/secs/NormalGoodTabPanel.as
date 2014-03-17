package sszt.duplicateStore.component.secs
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
	import sszt.duplicateStore.component.StoreCell;
	import sszt.duplicateStore.event.StoreEvent;
	import sszt.duplicateStore.mediator.StoreMediator;
	import sszt.duplicateStore.socket.GetDuplicateShopSaleNumSocketHandler;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class NormalGoodTabPanel extends Sprite implements IGoodTabPanel
	{
		private var _mediator:StoreMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
//		private var _cells:Vector.<StoreCell>;
		private var _cells:Array;
		public static const PAGE_SIZE:int = 8;
		private var _shopType:int;
		private var _currentCell:StoreCell;
		
		public function NormalGoodTabPanel(type:int,mediator:StoreMediator)
		{
			_mediator = mediator;
			_shopType = type;
			super();
			initView();
			show();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,7,180,90)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(188,7,180,90)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,98,180,90)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(188,98,180,90)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,189,180,90)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(188,189,180,90)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,280,180,90)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(188,280,180,90)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,59,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,150,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,241,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,332,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,59,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,150,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,241,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,332,140,5),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,15,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(196,15,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,106,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(196,106,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,197,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(196,197,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,288,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(196,288,50,50),new Bitmap(new CellBigBgAsset()))
			]);
			addChild(_bg as DisplayObject);
			
			_tile = new MTile(180,90,2);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.setSize(361,363);
			_tile.move(7,7);
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
			//初始化商店列表
			_shop = ShopTemplateList.getShop(_shopType);
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
		
		private function clearCell():void
		{
			for(var i:int =0;i<_cells.length;i++)
			{
				_cells[i].shopItem = null;
			}
		}
		
		public function showGoods(page:int,type:int):void
		{
			clearCell();
			var list:Array = _shop.getItems(PAGE_SIZE,page,type);
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
			_shop.updateSaleNum(e.data as IPackageIn);
			_mediator.storeModule.dispatchEvent(new StoreEvent(StoreEvent.COUNT_CHANGE));
		}
		
		private function get _shop():ShopTemplateInfo
		{
			return _mediator.storeModule.cheapInfo.shop;
		}
		
		private function set _shop(value:ShopTemplateInfo):void
		{
			_mediator.storeModule.cheapInfo.shop = value;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
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
			_currentCell = null;
			hide();
			_mediator = null;
			
		}
	}
}