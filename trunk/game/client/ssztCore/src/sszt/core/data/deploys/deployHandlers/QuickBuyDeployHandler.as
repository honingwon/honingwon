package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.view.quickBuy.BuyPanel;
	
	public class QuickBuyDeployHandler extends BaseDeployHandler
	{
		public function QuickBuyDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.QUICK_BUY;
		}
		/**
		 * parm1:商店编号
		 * parm2:购买类型 0代表购买单个物品
		 * parm3:物品模版id(当parm2为0时有效)
		 */
		override public function handler(info:DeployItemInfo):void
		{
			if(info.param2 == 0)
			{
				//购买单个物品
				BuyPanel.getInstance().show([info.param3],new ToStoreData(info.param1));
			}
			else
			{
				//购买相同类型物品
				var shopItemList:Array = ShopTemplateList.shopList[info.param1].shopItemInfos[info.param2-1];
				var templateList:Array = [];
				for each(var item:ShopItemInfo in shopItemList)
				{
					templateList.push(item.templateId);
				}
				BuyPanel.getInstance().show(templateList,new ToStoreData(info.param1));
			}
		}
	}
}