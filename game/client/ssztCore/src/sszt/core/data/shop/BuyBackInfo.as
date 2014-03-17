package sszt.core.data.shop
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.item.ItemInfo;

	public class BuyBackInfo extends EventDispatcher
	{
//		public var buyBackList:Vector.<ItemInfo>;
		public var buyBackList:Array;
		
		public function BuyBackInfo()
		{
//			buyBackList = new Vector.<ItemInfo>();
			buyBackList = [];
		}
		
		public function addItem(item:ItemInfo):void
		{
			if(buyBackList.length > 10) return;
			buyBackList.push(item);
			dispatchEvent(new BuyBackInfoUpdateEvent(BuyBackInfoUpdateEvent.ADD_BUYBACK_ITEM,item));
		}
		
		public function removeItem(place:int):void
		{
			for(var i:int =0;i<buyBackList.length;i++)
			{
				if(buyBackList[i].place == place)
				{
					buyBackList.splice(i,1);
					dispatchEvent(new BuyBackInfoUpdateEvent(BuyBackInfoUpdateEvent.REMOVE_BUYBACK_ITEM,place));
					break;
				}
			}
		}
			
//		public function updateBuyBack(list:Vector.<ItemInfo>):void
		public function updateBuyBack(list:Array):void
		{
			for each(var i:ItemInfo in list)
			{
				if(!i.isExist)
				{
					removeItem(i.place);
				}else
				{
					addItem(i);
				}
			}
		}
		
		public function getItem(place:int):ItemInfo
		{
			if(place >= buyBackList.length) return null;
			return buyBackList[place];
		}
	}
}