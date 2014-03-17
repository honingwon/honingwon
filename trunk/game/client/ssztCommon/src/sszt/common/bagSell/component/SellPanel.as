package sszt.common.bagSell.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.common.bagSell.BagSellController;
	import sszt.common.npcStore.components.cell.NPCSellCell;
	import sszt.constData.DragActionType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemSellSocketHandler;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class SellPanel extends Sprite implements IAcceptDrag
	{
		private var _bg:IMovieWrapper;
		private var _controller:BagSellController;
		private var _shopType:int;
		//		private var _cellList:Vector.<NPCSellCell>;
		private var _cellList:Array;
		private var _tile:MTile;
		private var _sellBtn:MCacheAssetBtn1;
		public static const PAGESIZE:int = 12;
		private var _count:int = 0;
		private var _total:int = 0;
		private var _totalValue:MAssetLabel;
		private var _bgTxtTotal:MAssetLabel;
		
		public function SellPanel(control:BagSellController,type:int)
		{
			_controller = control;
			_shopType = type;
			super();
			init();
		}
		
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,12,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(51,12,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(90,12,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(129,12,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(168,12,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(207,12,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,52,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(51,52,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(90,52,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(129,52,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(168,52,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(207,52,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(73,97,90,20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(76,97,18,18), new Bitmap(MoneyIconCaches.bingCopperAsset))
			]);
			addChild(_bg as DisplayObject);
			
			_tile = new MTile(38,38,6);
			_tile.itemGapW = 1;
			_tile.itemGapH = 2;
			_tile.setSize(234,80);
			_tile.move(12,12);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			//			_cellList = new Vector.<NPCSellCell>();
			_cellList = new Array();
			for(var i:int = 0;i< PAGESIZE;i++)
			{
				var cell:NPCSellCell = new NPCSellCell();
				_cellList.push(cell);
				_tile.appendItem(cell);
			}
			
			_sellBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.sell"));
			_sellBtn.move(190,95);
			addChild(_sellBtn);
			
			_totalValue = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_totalValue.move(94,99);
			addChild(_totalValue);
			
			_bgTxtTotal = new MAssetLabel(LanguageManager.getWord('ssztl.common.sellTotalPrice'), MAssetLabel.LABEL_TYPE_TAG, TextFormatAlign.LEFT);
			_bgTxtTotal.move(14,99);
			addChild(_bgTxtTotal);
			
			initEvent();
		}
		
		public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.DRAGIN;
			if(!source)return action;
			var tempItemInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(source.getSourceType() == CellType.BAGCELL)
			{
				if(!tempItemInfo.template.canSell)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.itemUnsellable"));
					return DragActionType.UNDRAG;
				}
				//				if(tempItemInfo.isBind)
				//				{
				//					QuickTips.show("该物品已绑定");
				//					return DragActionType.UNDRAG;
				//				}
				if( _count >= 12)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.sellListFull"));
					return DragActionType.UNDRAG;
				}
				GlobalData.clientBagInfo.addToNPCStore(tempItemInfo);
			}
			return action;
		}
		
		private function initEvent():void
		{
			_sellBtn.addEventListener(MouseEvent.CLICK,sellClickHandler);
			GlobalData.clientBagInfo.addEventListener(ClientBagInfoUpdateEvent.ADDTONPCSTORE,addItemHandler);
			for(var i:int = 0;i<_cellList.length;i++)
			{
				_cellList[i].addEventListener(MouseEvent.CLICK,cellClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			_sellBtn.removeEventListener(MouseEvent.CLICK,sellClickHandler);
			GlobalData.clientBagInfo.removeEventListener(ClientBagInfoUpdateEvent.ADDTONPCSTORE,addItemHandler);
			for(var i:int = 0;i<_cellList.length;i++)
			{
				_cellList[i].removeEventListener(MouseEvent.CLICK,cellClickHandler);
			}
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			var cell:NPCSellCell = evt.currentTarget as NPCSellCell;
			if(cell.itemInfo)
			{
				GlobalData.clientBagInfo.removeFromNPCStore(cell.itemInfo.itemId);
				_total = _total - cell.itemInfo.template.sellCopper * cell.itemInfo.count;
				_totalValue.setValue(_total + '');
				cell.itemInfo = null;
				_count = _count -1;
			}
		}
		
		private function addItemHandler(evt:ClientBagInfoUpdateEvent):void
		{
			var item:ItemInfo = evt.data as ItemInfo;
			for(var i:int = 0;i < _cellList.length;i++)
			{
				if(_cellList[i].itemInfo == null)
				{
					_count++;
					_cellList[i].itemInfo = item;
					_total = _total + item.template.sellCopper * item.count;
					_totalValue.setValue(_total + '');
					break;
				}
			}
		}
		
		private function sellClickHandler(evt:MouseEvent):void	
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_count == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.noWaittingSell"));
				return ;
			}
			MAlert.show(LanguageManager.getWord("ssztl.common.sureSellItem"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,sellAlertHandler);
		}
		
		private function sellAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				for(var i:int = 0;i<_cellList.length;i++)
				{
					if(_cellList[i].itemInfo)
					{
						ItemSellSocketHandler.sendSell(_cellList[i].itemInfo.place,_cellList[i].itemInfo.count);
						_cellList[i].itemInfo = null;
					}
				}
				_count = 0;
				_total = 0;
				_totalValue.setValue("0");
				GlobalData.clientBagInfo.clearNPCStore();
			}
		}
		
		public function clearCellList():void
		{
			for(var i:int = 0;i<_cellList.length;i++)
			{
				if(_cellList[i].itemInfo)
				{
					_cellList[i].itemInfo = null;
				}
			}
			_count = 0;
			_total = 0;
			_totalValue.setValue("0");
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function dispose():void
		{
			GlobalData.clientBagInfo.clearNPCStore();
			removeEvent();
			_controller = null;
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
			if(_cellList)
			{
				for(var i:int =0;i<_cellList.length;i++)
				{
					_cellList[i].dispose();
				}
				_cellList = null;
			}
			if(_sellBtn)
			{
				_sellBtn.dispose();
				_sellBtn = null;
			}
			_totalValue = null;
			_bgTxtTotal = null;
			if(parent) parent.removeChild(this);
		}
	}
}