package sszt.stall.compoments
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.data.stall.StallGoodsPanelEvents;
	import sszt.core.data.stall.StallInfo;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.module.ModuleEventDispatcher;
	import sszt.stall.StallModule;
	import sszt.stall.compoments.cell.StallBegBuyCell;
	import sszt.stall.compoments.cell.StallBegSaleCell;
	import sszt.stall.compoments.emptyCell.StallBegBuyCellEmpty;
	import sszt.stall.compoments.emptyCell.StallBegSaleCellEmpty;
	import sszt.stall.mediator.StallMediator;
	
	public class GoodsPanel extends Sprite
	{
		private var _stallGoodsMediator:StallMediator;
//		public var begSaleGoodsCellVector:Vector.<StallBegSaleCell> = new Vector.<StallBegSaleCell>(StallInfo.STALL_PAGE_SIZE);
//		public var begBuyGoodsCellVector:Vector.<StallBegBuyCell> = new Vector.<StallBegBuyCell>(StallInfo.STALL_PAGE_SIZE);
		public var begSaleGoodsCellVector:Array = new Array(StallInfo.STALL_PAGE_SIZE);
		public var begBuyGoodsCellVector:Array = new Array(StallInfo.STALL_PAGE_SIZE);
		
		private var _begSaleMoneyField:TextField;
		private var _begBuyMoneyField:TextField;
		private var _ownMoneyField:TextField;
		private var _begBuyTile:MTile;
		private var _begSaleTile:MTile;
		
		private var _saleCellEmptyDrag:StallBegSaleCellEmpty;
		
		private var _buyCellEmptyDrag:StallBegBuyCellEmpty;
		
		public function GoodsPanel(stallGoodsMediator:StallMediator)
		{
			_stallGoodsMediator = stallGoodsMediator;
			super();
			initialView();
			initalEvents();
		}
		
		public function initialView():void
		{
			_begBuyTile = new MTile(38,38,6);
			_begBuyTile.itemGapH = _begBuyTile.itemGapW = 0;
			_begBuyTile.setSize(228,114);
			_begBuyTile.move(269,58);
			addChild(_begBuyTile);
			
			_begSaleTile = new MTile(38,38,6);
			_begSaleTile.itemGapH = _begSaleTile.itemGapW = 0;
			_begSaleTile.setSize(228,114);
			_begSaleTile.move(269,233);
			addChild(_begSaleTile);
			
			_saleCellEmptyDrag = new StallBegSaleCellEmpty();
			_saleCellEmptyDrag.move(269,58);
			addChild(_saleCellEmptyDrag);
			
			_buyCellEmptyDrag = new StallBegBuyCellEmpty();
			_buyCellEmptyDrag.move(269,233);
			addChild(_buyCellEmptyDrag);
			
			var  _tmpStallSaleCell:StallBegSaleCell;
			var _tmpStallBuyCell:StallBegBuyCell;
			
			//初始化待售格子
			for(var i:int = 0;i<StallInfo.STALL_PAGE_SIZE;i++)
			{
				_tmpStallSaleCell = new StallBegSaleCell(saleCellClick,saleCellDoubleClick);
				_begBuyTile.appendItem(_tmpStallSaleCell);
				begSaleGoodsCellVector[i] = _tmpStallSaleCell;
				
				_tmpStallSaleCell.itemInfo = null;

				_tmpStallSaleCell.addEventListener(MouseEvent.MOUSE_DOWN,saleCellDownHandler);
				_tmpStallSaleCell.addEventListener(MouseEvent.CLICK,saleCellClickHandler);
			}
			
			for(var t:int = 0;t<StallInfo.STALL_PAGE_SIZE;t++)
			{
				_tmpStallBuyCell = new StallBegBuyCell(buyCellClick,buyCellDoubleClick);
				_begSaleTile.appendItem(_tmpStallBuyCell);
				begBuyGoodsCellVector[t] = _tmpStallBuyCell;
				
				_tmpStallBuyCell.addEventListener(MouseEvent.MOUSE_DOWN,buyCellDownHandler);
				_tmpStallBuyCell.addEventListener(MouseEvent.CLICK,buyCellClickHandler);
			}
			
			_begSaleMoneyField = new TextField();
			_begSaleMoneyField.textColor = 0xFFFFFF;
			_begSaleMoneyField.text = "0";
			_begSaleMoneyField.x = 335;
			_begSaleMoneyField.y = 175;
			_begSaleMoneyField.width = 140;
			_begSaleMoneyField.height = 20;
			_begSaleMoneyField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
			
			_begBuyMoneyField = new TextField();
			_begBuyMoneyField.textColor = 0xFFFFFF;
			_begBuyMoneyField.text = "0";
			_begBuyMoneyField.x = 335;
			_begBuyMoneyField.y = 349;
			_begBuyMoneyField.width = 140;
			_begBuyMoneyField.height = 20;
			_begBuyMoneyField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
			_ownMoneyField = new TextField();
			_ownMoneyField.textColor = 0xFFFFFF;
			_ownMoneyField.text = GlobalData.selfPlayer.userMoney.copper.toString();
			_ownMoneyField.x = 335;
			_ownMoneyField.y = 372;
			_ownMoneyField.width = 140;
			_ownMoneyField.height = 20;
			_ownMoneyField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
			addChild(_begSaleMoneyField);
			addChild(_begBuyMoneyField);
			addChild(_ownMoneyField);
			
		}
		
		private function saleCellClick(cell:StallBegSaleCell):void
		{
//			GlobalAPI.dragManager.startDrag(cell);
		}
		private function saleCellDoubleClick(cell:StallBegSaleCell):void
		{
			ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,cell));
		}
		
		private function buyCellClick(cell:StallBegBuyCell):void
		{
			//			GlobalAPI.dragManager.startDrag(cell);
		}
		private function buyCellDoubleClick(cell:StallBegBuyCell):void
		{
			ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,cell));
		}
		
		
		public function saleCellDownHandler(e:MouseEvent):void
		{
			var stallSaleCell:StallBegSaleCell = e.currentTarget as StallBegSaleCell;
			if(stallSaleCell&&stallSaleCell.itemInfo&&GlobalData.selfPlayer.stallName == "")
			{
				stallSaleCell.dragStart();
			}
		}
		
		public function buyCellDownHandler(e:MouseEvent):void
		{
			var stallBuyCell:StallBegBuyCell = e.currentTarget as StallBegBuyCell;
			if(stallBuyCell&&GlobalData.selfPlayer.stallName == "")
			{
				stallBuyCell.dragStart();
			}
		}
		
		public function saleCellClickHandler(e:MouseEvent):void
		{
			var stallSaleCell:StallBegSaleCell = e.currentTarget as StallBegSaleCell;
			
			if(stallSaleCell&&stallSaleCell.itemInfo&&GlobalData.selfPlayer.stallName == "")
			{
				DoubleClickManager.addClick(stallSaleCell);
			}
		}
		
		public function buyCellClickHandler(e:MouseEvent):void
		{
			var stallBuyCell:StallBegBuyCell = e.currentTarget as StallBegBuyCell;
			if(stallBuyCell&&GlobalData.selfPlayer.stallName == "")
			{
				DoubleClickManager.addClick(stallBuyCell);
			}
		}
		
		public function cellMoveHandler(e:CellEvent):void
		{
			
		}
		
		public function saleCelllMoveHandler(e:CellEvent):void
		{
			_stallGoodsMediator.showStallSalePopPanel(e.data as ItemInfo);
		}
		
		public function buyCelllMoveHandler(e:CellEvent):void
		{
			var tmpItemInfo:ItemInfo = e.data as ItemInfo;
			var isExist:Boolean = false;
			for each(var i:StallBuyCellInfo in GlobalData.stallInfo.begBuyInfoVector)
			{
					if(i.templateId == tmpItemInfo.templateId)
					{
						MAlert.show("同一类型物品不能求购两次,请直接左键修改数量！","警告");
						isExist = true;
						break;
					}
			}
			if(!isExist)
			{
				_stallGoodsMediator.showStallBuyPopPanel(tmpItemInfo);
			}
		}
		
		public function initalEvents():void
		{
			GlobalData.stallInfo.addEventListener(StallGoodsPanelEvents.STALL_BUY_GOODS_UPDATE,updateBuyCellVector);
			GlobalData.clientBagInfo.addEventListener(ClientBagInfoUpdateEvent.STALL_SALE_VECTOR_UPDATE,updateBegSaleVector);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,updateAllSaleVectorByBagHandler);
			_saleCellEmptyDrag.addEventListener(CellEvent.CELL_MOVE,saleCelllMoveHandler);
			_buyCellEmptyDrag.addEventListener(CellEvent.CELL_MOVE,buyCelllMoveHandler);
		}
		
		public function removeEvents():void
		{
			GlobalData.stallInfo.removeEventListener(StallGoodsPanelEvents.STALL_BUY_GOODS_UPDATE,updateBuyCellVector);
			GlobalData.clientBagInfo.removeEventListener(ClientBagInfoUpdateEvent.STALL_SALE_VECTOR_UPDATE,updateBegSaleVector);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_UPDATE,updateAllSaleVectorByBagHandler);
			_saleCellEmptyDrag.removeEventListener(CellEvent.CELL_MOVE,saleCelllMoveHandler);
			_buyCellEmptyDrag.removeEventListener(CellEvent.CELL_MOVE,buyCelllMoveHandler);
		}
		
		private function updateAllSaleVectorByBagHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpPlaceVector:Vector.<int> = e.data as Vector.<int>;
			var tmpPlaceVector:Array = e.data as Array;
			for(var i:int = 0;i<tmpPlaceVector.length;i++)
			{
				GlobalData.clientBagInfo.updateToStallBegSaleVector(tmpPlaceVector[i]);
			}
		}

		
		public function updateBuyCellVector(e:StallGoodsPanelEvents):void
		{
			var _templateId:int = e._data;
			
			var _tmpStallBuyCellIno:StallBuyCellInfo = GlobalData.stallInfo.getBuyItemFromBegBuyVector(_templateId);
			
			var _isExist:Boolean = false;
			for each(var t:StallBegBuyCell in begBuyGoodsCellVector)
			{
				if(t.stallBuyInfo!=null)
				{
					if(t.stallBuyInfo.templateId == _templateId)
					{
						t.stallBuyInfo = _tmpStallBuyCellIno;
						_isExist = true;
						break;
					}
				}
			}
			
			if(!_isExist)
			{
				for each(var i:StallBegBuyCell in begBuyGoodsCellVector)
				{
					if(i.stallBuyInfo == null)
					{
						i.stallBuyInfo = _tmpStallBuyCellIno;
						break;
					}
				}
			}

			updateBuyPrice();
		}
		
		public function updateBegSaleVector(e:ClientBagInfoUpdateEvent):void
		{
			var place:int = e.data as int;
			var _tmpStallSaleCellItem:ItemInfo = GlobalData.clientBagInfo.getItemInfoFromSallSaleVector(place);
			var isExist:Boolean = false;
			for each(var t:StallBegSaleCell in begSaleGoodsCellVector)
			{
				if(t.itemInfo != null)
				{
					if(t.itemInfo.place == place)
					{
						t.itemInfo = _tmpStallSaleCellItem;
						isExist = true;
						break;
					}
				}
			}
			if(!isExist)
			{
				for each(var i:StallBegSaleCell in begSaleGoodsCellVector)
				{
					if(i.itemInfo == null)
					{
						i.itemInfo = GlobalData.clientBagInfo.getItemInfoFromSallSaleVector(place);
						break;
					}
				}
			}
			updateSalePrice();
		}
		
		
		public function updateBuyPrice():void
		{
			var tmpPrice:int = 0;
			for each(var i:StallBuyCellInfo in GlobalData.stallInfo.begBuyInfoVector)
			{
				tmpPrice += i.price*i.num;
			}
			_begBuyMoneyField.text = tmpPrice.toString();
		}
		
		public function updateSalePrice():void
		{
			var tmpPrice:int = 0;
			for each(var i:ItemInfo in GlobalData.clientBagInfo.stallBegSaleVector)
			{
				tmpPrice += i.stallSellPrice * i.count;
			}
			_begSaleMoneyField.text = tmpPrice.toString();
		}
		
		public function get module():StallModule
		{
			return _stallGoodsMediator.stallModule;
		}
		
		public function dispose():void
		{
			removeEvents();
			_stallGoodsMediator = null;
			if(begSaleGoodsCellVector)
			{
				for each(var i:StallBegSaleCell in begSaleGoodsCellVector)
				{
					i.dispose();
				}
				begSaleGoodsCellVector = null;
			}
			if(begBuyGoodsCellVector)
			{
				for each(var t:StallBegBuyCell in begBuyGoodsCellVector)
				{
					t.dispose();
				}
				begBuyGoodsCellVector = null;
			}
			_begSaleMoneyField = null;
			_begBuyMoneyField = null;
			_ownMoneyField = null;
			if(_begBuyTile)
			{
				_begBuyTile.dispose();
				_begBuyTile = null;
			}
			if(_begSaleTile)
			{
				_begSaleTile.dispose();
				_begSaleTile = null;
			}
			if(_saleCellEmptyDrag)
			{
				_saleCellEmptyDrag.dispose();
				_saleCellEmptyDrag = null;
			}
			if(_buyCellEmptyDrag)
			{
				_buyCellEmptyDrag.dispose();
				_buyCellEmptyDrag = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}