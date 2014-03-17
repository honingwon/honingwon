package sszt.core.data.shop
{
	import flash.events.Event;
	
	public class BuyBackInfoUpdateEvent extends Event
	{
		public static const ADD_BUYBACK_ITEM:String = "addBuyBackItem";
		public static const REMOVE_BUYBACK_ITEM:String = "removeBuyBackItem";
		public var data:Object;
		public function BuyBackInfoUpdateEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}