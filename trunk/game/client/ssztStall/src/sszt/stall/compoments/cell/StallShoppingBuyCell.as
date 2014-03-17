package sszt.stall.compoments.cell
{
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.CellType;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	
	public class StallShoppingBuyCell extends StallBaseItemInfoCell
	{
		private var _stallShopBuyInfo:StallShopBuySaleInfo;
		public function StallShoppingBuyCell(clickHandler:Function, doubleClickHandler:Function)
		{
			super(clickHandler, doubleClickHandler);
		}
		
		override public function getSourceType():int
		{
			return CellType.STALLSHOPPINGBUYCELL;
		}

		public function get stallShopBuyInfo():StallShopBuySaleInfo
		{
			return _stallShopBuyInfo;
		}

		public function set stallShopBuyInfo(value:StallShopBuySaleInfo):void
		{
			if(_stallShopBuyInfo == value)
			{
				if(value != null)
				{
					_countField.text = _stallShopBuyInfo.count.toString();
				}
				return ;
			}
			_stallShopBuyInfo = value;
			if(_stallShopBuyInfo)
			{
				itemInfo = _stallShopBuyInfo.itemInfo;
				info = _stallShopBuyInfo.itemInfo.template;
				_countField.text = _stallShopBuyInfo.count.toString();
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