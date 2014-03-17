package sszt.stall.compoments.cell
{
	import sszt.ui.container.MAlert;
	
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;

	public class StallShoppingSaleCell extends StallBaseItemInfoCell
	{
		private var _stallShopSaleInfo:StallShopBuySaleInfo;
		public function StallShoppingSaleCell(clickHandler:Function, doubleClickHandler:Function)
		{
			super(clickHandler, doubleClickHandler);
		}
		
		override public function getSourceType():int
		{
			return CellType.STALLSHOPPINGSALECELL;
		}
		
		override public function dragStop(data:IDragData):void
		{
			var action:int = data.action;
//			if(action == DragActionType.DRAGIN)
//			{
				//已经在bagCell里面写了
//				GlobalData.clientBagInfo.removeFromStallShoppingSaleVector(itemInfo.place);
//			}
			if(action == DragActionType.NONE)
			{
				MAlert.show("拖动失败！","警告");
			}
		}

		public function get stallShopSaleInfo():StallShopBuySaleInfo
		{
			return _stallShopSaleInfo;
		}

		public function set stallShopSaleInfo(value:StallShopBuySaleInfo):void
		{
			if(_stallShopSaleInfo == value)
			{
				if(value != null)
				{
					_countField.text = _stallShopSaleInfo.count.toString();
				}
				return ;
			}
			_stallShopSaleInfo = value;
			if(_stallShopSaleInfo)
			{
				itemInfo = _stallShopSaleInfo.itemInfo;
				info = _stallShopSaleInfo.itemInfo.template;
				_countField.text = _stallShopSaleInfo.count.toString();
			}
			else
			{
				itemInfo = null;
				info = null;
				_countField.text ="";
			}
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			_iteminfo = value;
		}

	}
}