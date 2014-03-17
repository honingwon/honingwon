package sszt.welfare.event
{
	import flash.events.Event;
	
	public class WelfareEvent extends Event
	{
		
		public static const DISCOUNT_UPDATE:String = "discountUpdate";
		public static const COUNT_CHANGE:String = "countChange";
		
		public var data:Object;
		
		public function WelfareEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}