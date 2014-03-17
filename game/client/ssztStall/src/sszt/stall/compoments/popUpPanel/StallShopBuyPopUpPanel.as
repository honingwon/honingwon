package sszt.stall.compoments.popUpPanel
{
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.stall.data.StallShopInfo;
	import sszt.stall.mediator.StallMediator;
	
	public class StallShopBuyPopUpPanel extends StallBasePopUpPanel
	{
		public function StallShopBuyPopUpPanel(argStallMediator:StallMediator,cellItemInfo:ItemInfo)
		{
			super(argStallMediator, cellItemInfo,true,false);
			initialShopBuyCell();
		}
		
		override public function okHandler(e:MouseEvent):void
		{
			if(getCount()>cellItemInfo.count)
			{
				MAlert.show("购买数量不能大于最大销售数量");
			}
			else
			{
				//格子更新（数据层）
				//从待售容器删除更新
//				stallShopInfo.updateFromStallBegSaleVector(cellItemInfo.place,getCount());
				//锁定待售容器物品，从购买容器增加更新
				cellItemInfo.lock = true;
				stallShopInfo.updateToShoppingBuyVector(cellItemInfo,getCount());
			}
			dispose();
		}
		
		private function get stallShopInfo():StallShopInfo
		{
			return stallModule.stallShopInfo;
		}
		
		private function initialShopBuyCell():void
		{
			setCount(cellItemInfo.count);
			setPrice(cellItemInfo.stallSellPrice);
		}
	}
}