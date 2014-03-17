package sszt.store.component.secs
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.store.component.StoreCell;
	import sszt.store.mediator.StoreMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	
	import ssztui.ui.CellBigBgAsset;
	
	public class NormalGoodTabPanel extends Sprite implements IGoodTabPanel
	{
		private var _mediator:StoreMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
//		private var _cells:Vector.<StoreCell>;
		private var _cells:Array;
		public static const PAGE_SIZE:int = 9;
		private var _shopType:int;
		private var _currentCell:StoreCell;
		
		public function NormalGoodTabPanel(type:int,mediator:StoreMediator)
		{
			_mediator = mediator;
			_shopType = type;
			super();
			initView();
		}
		
		private function initView():void
		{
			_tile = new MTile(207,87,3);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.setSize(626,350);
			_tile.move(0,0);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
//			_cells = new Vector.<StoreCell>();
			_cells = new Array();
			for(var i:int=0;i<9;i++)
			{
				var cell:StoreCell = new StoreCell(_shopType);
				cell.addEventListener(MouseEvent.CLICK,clickHandler);
				_cells.push(cell);
				_tile.appendItem(cell);
			}
			
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var cell:StoreCell = evt.currentTarget as StoreCell;
//			if(cell.shopItem)
//			{
//				if(_currentCell) _currentCell.selected = false;
//				_currentCell = cell;
//				_currentCell.selected = true;
//			}
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
			var shop:ShopTemplateInfo =ShopTemplateList.getShop(_shopType);
//			var list:Vector.<ShopItemInfo> = shop.getItems(PAGE_SIZE,page,type);
			var list:Array = shop.getItems(PAGE_SIZE,page,type);
			for(var i:int =0;i<list.length;i++)
			{
				_cells[i].shopItem = list[i];
			}
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function show():void
		{
			this.visible = true;
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
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}