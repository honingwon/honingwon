package sszt.core.data.bag
{
	import sszt.core.data.item.ItemInfo;

	public class StallShopBuySaleInfo
	{
		public var itemInfo:ItemInfo;
		public var count:int;
		public function StallShopBuySaleInfo(argItemInfo:ItemInfo,argCount:int)
		{
			this.itemInfo = argItemInfo;
			this.count = argCount;
		}
	}
}