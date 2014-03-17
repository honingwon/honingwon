package sszt.consign.data.Item
{
	import sszt.core.data.item.ItemInfo;

	public class MyItemInfo
	{
		public var listId:Number;
		public var leftTime:int;
		public var itemInfo:ItemInfo;
		public var consignType:int; //1:物品 2：铜币 3：金币
		public var total:int;
		public var priceType:int; //2:铜币 3：金币
		public var consignPrice:int;
		public var consignTime:int;
		public function MyItemInfo()
		{
			itemInfo = new ItemInfo();
		}
	}
}