package sszt.store.component.secs
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.store.component.StoreCell;
	import sszt.store.event.StoreEvent;
	import sszt.store.mediator.StoreMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	
	import ssztui.ui.CellBigBgAsset;
	
	public class HotGoodTabPanel extends Sprite implements IGoodTabPanel
	{
		private var _mediator:StoreMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
//		private var _cells:Vector.<StoreCell>;
		private var _cells:Array;
		private var _shopType:int;
		private var _cheapItem1:DiscountCell;
		private var _cheapItem2:DiscountCell;
		private var _cheapItem3:DiscountCell;
		private var _disposeTime:Number = 0;
		public static const PAGE_SIZE:int = 9;
		private var _currentCell:StoreCell;
		
		public function HotGoodTabPanel(type:int,mediator:StoreMediator)
		{
			_shopType = type;
			_mediator = mediator;
			super();
			initView();
			initEvent();
//			ItemDiscountSocketHandler.sendDiscount();
		}
		
//		public function update(times:int,dt:Number = 0.04):void
//		{
//			var tmp:Number = getTimer();
//			if(tmp - _disposeTime >= FLASHTIMER)
//			{
//				_disposeTime = tmp;
//				ItemDiscountSocketHandler.sendDiscount();
//			}
//		}
		
		public function assetsCompleteHandler():void
		{
		}
		private function initEvent():void
		{
//			_mediator.storeModule.cheapInfo.addEventListener(StoreEvent.DISCOUNT_UPDATE,discountHandler);
			ModuleEventDispatcher.addModuleEventListener(WelfareEvent.DISCOUNT_UPDATE,discountHandler);
			for(var i:int = 0;i<_cells.length;i++)
			{
				_cells[i].addEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		
		private function removeEvent():void
		{
//			_mediator.storeModule.cheapInfo.removeEventListener(StoreEvent.DISCOUNT_UPDATE,discountHandler);
			ModuleEventDispatcher.removeModuleEventListener(WelfareEvent.DISCOUNT_UPDATE,discountHandler);
			for(var i:int = 0;i<_cells.length;i++)
			{
				_cells[i].removeEventListener(MouseEvent.CLICK,clickHandler);
			}
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
		
		private function discountHandler(evt:WelfareEvent):void
		{
//			_cheapItem1.cheapItem = _mediator.storeModule.cheapInfo.cheapItems[0];
//			_cheapItem2.cheapItem = _mediator.storeModule.cheapInfo.cheapItems[1];
//			_cheapItem3.cheapItem = _mediator.storeModule.cheapInfo.cheapItems[2];
			
			_cheapItem1.cheapItem = GlobalData.cheapInfo.cheapItems[0];
			_cheapItem2.cheapItem = GlobalData.cheapInfo.cheapItems[1];
			_cheapItem3.cheapItem = GlobalData.cheapInfo.cheapItems[2];
		}
		
		private function initView():void
		{
			_tile = new MTile(207,87,3);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.setSize(624,263);
			_tile.move(0,0);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
//			_cells = new Vector.<StoreCell>();
			_cells = new Array();
			for(var i:int =0;i<PAGE_SIZE;i++)
			{
				var cell:StoreCell = new StoreCell(_shopType);
				_cells.push(cell);
				_tile.appendItem(cell);
			}
			
			_cheapItem1 = new DiscountCell(_shopType);
			_cheapItem2 = new DiscountCell(_shopType);
			_cheapItem3 = new DiscountCell(_shopType);
			_cheapItem1.move(419,29);
			_cheapItem2.move(419,125);
			_cheapItem3.move(419,221);
			//_cheapItem3.move(420,221);
//			addChild(_cheapItem1);
//			addChild(_cheapItem2);
//			addChild(_cheapItem3);
			
//			var cheapItem:CheapItem = new CheapItem();
//			cheapItem.shopInfo = ShopTemplateList.getShop(1).shopItemInfos[0][0];
//			cheapItem.cheapType = 0;
//			cheapItem.leftCount = 5;
//			cheapItem.leftTime = 39;
//			_cheapItem1.cheapItem = cheapItem;
//			
//			var cheapItem1:CheapItem = new CheapItem();
//			cheapItem1.shopInfo = ShopTemplateList.getShop(1).shopItemInfos[0][1];
//			cheapItem1.cheapType = 3;
//			cheapItem1.leftCount = 5;
//			cheapItem1.leftTime = 39;
//			_cheapItem2.cheapItem = cheapItem1;
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
				for(var i:int=0;i<_cells.length;i++)
				{
					_cells[i].dispose();
				}
				_cells = null;
			}
			if(_cheapItem1)
			{
				_cheapItem1.dispose();
				_cheapItem1 = null;
			}
			if(_cheapItem2)
			{
				_cheapItem2.dispose();
				_cheapItem2 = null;
			}
			if(_cheapItem3)
			{
				_cheapItem3.dispose();
				_cheapItem3 = null;
			}
			_currentCell = null;
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}