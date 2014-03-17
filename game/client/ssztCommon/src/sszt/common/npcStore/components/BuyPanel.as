package sszt.common.npcStore.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.common.npcStore.components.cell.NPCSellCell;
	import sszt.common.npcStore.components.cell.NPCStoreCell;
	import sszt.common.npcStore.controllers.NPCStoreController;
	import sszt.constData.DragActionType;
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
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class BuyPanel extends Sprite implements IAcceptDrag
	{
		private var _controller:NPCStoreController;
		private var _shopType:int;
//		private var _cellList:Vector.<NPCSellCell>;
		private var _cellList:Array;
		private var _tile:MTile;
		private var _sellBtn:MCacheAssetBtn1;
		public static const PAGESIZE:int = 7;
		private var _count:int = 0;
		private var _total:int = 0;
		private var _totalValue:MAssetLabel;
		private var _bgTxtTotal:MAssetLabel;
		
		public function BuyPanel(control:NPCStoreController,type:int)
		{
			_controller = control;
			_shopType = type;
			super();
			init();
		}
		
		private function init():void
		{
//			graphics.beginFill(0, 0);
//			graphics.drawRect(0, 0, 309, 302);
//			graphics.endFill();
			
			_tile = new MTile(39,38,7);
			_tile.itemGapW = _tile.itemGapH = 0;
			_tile.setSize(273,38);
			_tile.move(8,27);
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
			_sellBtn.move(225,68);
			addChild(_sellBtn);
			
			_totalValue = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_totalValue.move(91,72);
			addChild(_totalValue);
			
			_bgTxtTotal = new MAssetLabel(LanguageManager.getWord('ssztl.common.sellTotalPrice')+"：", MAssetLabel.LABEL_TYPE_TAG, TextFormatAlign.LEFT);
			_bgTxtTotal.move(12,72);
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
				if( _count >= 7)
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