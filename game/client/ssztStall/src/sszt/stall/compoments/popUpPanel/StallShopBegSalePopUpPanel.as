package sszt.stall.compoments.popUpPanel
{
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.stall.data.StallShopInfo;
	import sszt.stall.mediator.StallMediator;
	
	public class StallShopBegSalePopUpPanel extends StallBasePopUpPanel
	{

		public function StallShopBegSalePopUpPanel(argStallMediator:StallMediator,argItemInfo:ItemInfo)
		{
			super(argStallMediator,argItemInfo,true,false);
			initialBegSaleCell();
		}
		
		override public function okHandler(e:MouseEvent):void
		{
			 var _stallShopBuyIno:StallShopBuySaleInfo = stallMediator.stallModule.stallShopInfo.getStallShopBuyInfoFromShoppingBuyVector(cellItemInfo.place);
			if(getCount() > _stallShopBuyIno.count)
			{
				MAlert.show("输入数量不能大于物品最大数量","警告");	
			}
			else
			{
				//格子更新
				//待售容器增加更新
				stallShopInfo.updateToStallBegSaleVector(cellItemInfo,getCount());
				//购买容器删除更新
				stallShopInfo.updateFromShoppingBuyVector(cellItemInfo.place,getCount());
			}
			dispose();
		}
		
		private function get stallShopInfo():StallShopInfo
		{
			return stallModule.stallShopInfo;
		}
		
		private function initialBegSaleCell():void
		{
			var tmpCount:int = stallShopInfo.getStallShopBuyInfoFromShoppingBuyVector(cellItemInfo.place).count;
			setCount(tmpCount);
			setPrice(cellItemInfo.stallSellPrice);
		}
	}
}