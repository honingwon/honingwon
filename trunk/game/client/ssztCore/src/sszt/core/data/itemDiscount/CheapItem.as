package  sszt.core.data.itemDiscount
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.socket.IPackageIn;

	public class CheapItem extends EventDispatcher
	{
		public var shopInfo:ShopItemInfo;  
		public var cheapType:int;          //1,限制数量并且限制时间;2,限制数量不限制时间;3,限制时间不限制数量
		public var leftTime:int;
		public var leftCount:int;         
		public var limitCount:int;          //个人可以购买的数据
		public var maxCount:int;          //可以购买的最大数量
		
		
		public function CheapItem()
		{
			shopInfo = new ShopItemInfo();
		}
		
		public function parseData(data:IPackageIn):void
		{
			shopInfo.id = data.readInt();
			shopInfo.state = data.readByte();
			shopInfo.templateId = data.readInt();
			shopInfo.payType = data.readByte();
			shopInfo.price = data.readInt();
			shopInfo.originalPrice = data.readInt();
			
			cheapType = data.readInt();
			leftTime = data.readInt();
			leftCount = data.readInt();
			limitCount = data.readByte();
			maxCount = data.readInt();
		}
		
		public function updateCount(count:int,count1:int):void
		{
			if(leftCount == count && limitCount==count1) return;
			leftCount = count;
			limitCount = count1;
			dispatchEvent(new WelfareEvent(WelfareEvent.COUNT_CHANGE));
		}
	}
}