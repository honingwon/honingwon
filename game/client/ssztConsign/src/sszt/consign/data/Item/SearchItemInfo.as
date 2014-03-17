package sszt.consign.data.Item
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.item.ItemInfo;
	
	public class SearchItemInfo extends EventDispatcher
	{
		public var listId:Number;
		public var consignPrice:int;//寄售价格
		public var priceType:int;//价格单位
		public var remainDate:Date;//剩余时间
		public var itemInfo:ItemInfo;
		public var consignType:int;//寄售类型
		public var total:int; //数量
		public function SearchItemInfo()
		{
			super();
			itemInfo = new ItemInfo();
		}
	}
}