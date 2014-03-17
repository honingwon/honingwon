package sszt.stall.compoments.popUpPanel
{
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.stall.data.StallShopInfo;
	import sszt.stall.mediator.StallMediator;
	
	public class StallShopSalePopUpPanel extends StallBasePopUpPanel
	{
		public function StallShopSalePopUpPanel(argStallMediator:StallMediator,cellItemInfo:ItemInfo)
		{
			super(argStallMediator, cellItemInfo,true,false);
			initialShopSaleCell();
		}
		
		override public function okHandler(e:MouseEvent):void
		{
			var begBuyCount:int = stallShopInfo.getStallBuyCellInfoFromStallBegBuyVector(cellItemInfo.templateId).num;
			var shopSaleAllCount:int = GlobalData.clientBagInfo.getSameItemCountFromShoppingBuyVector(cellItemInfo.templateId);
			var remainBegBuyCount:int = begBuyCount - shopSaleAllCount;
			if(getCount() > cellItemInfo.count)
			{
				MAlert.show("出售数量不能大于物品最大数量","警告");
			}
			else if(getCount() >= remainBegBuyCount)
			{
				setCount(remainBegBuyCount);
				//从背包格子锁定，出售格子增加（数据层）
				cellItemInfo.lock = true;
				GlobalData.clientBagInfo.addToStallshoppingSaleVector(new StallShopBuySaleInfo(cellItemInfo,getCount()));
			}
			else
			{
				//从背包格子锁定，出售格子增加（数据层）
				cellItemInfo.lock = true;
				GlobalData.clientBagInfo.addToStallshoppingSaleVector(new StallShopBuySaleInfo(cellItemInfo,getCount()));
			}
			dispose();
		}
		
		private function get stallShopInfo():StallShopInfo
		{
			return stallModule.stallShopInfo;
		}
		
		private function initialShopSaleCell():void
		{
			var tmpStallBuyCellInfo:StallBuyCellInfo = stallShopInfo.getStallBuyCellInfoFromStallBegBuyVector(cellItemInfo.templateId);
			if(cellItemInfo.count > tmpStallBuyCellInfo.num)
			{
				setCount(tmpStallBuyCellInfo.num);
			}
			else
			{
				setCount(cellItemInfo.count);	
			}
			setPrice(tmpStallBuyCellInfo.price);
		}
	}
}