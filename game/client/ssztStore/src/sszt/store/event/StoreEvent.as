package sszt.store.event
{
	import flash.events.Event;
	
	public class StoreEvent extends Event
	{
		public static const DISCOUNT_UPDATE:String = "discountUpdate";
		public static const COUNT_CHANGE:String = "countChange";
		public static const AUCTION_UPDATE:String = "auctionUpdate";
		public static const APPEND_AUCTION_MESSAGE:String = "appendAuctionMessage";
		public var data:Object;
		
		public function StoreEvent(type:String,obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}