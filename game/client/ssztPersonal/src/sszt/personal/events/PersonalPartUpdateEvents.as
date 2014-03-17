package sszt.personal.events
{
	import flash.events.Event;
	
	public class PersonalPartUpdateEvents extends Event
	{
		public static const LUCKYLIST_UPDATE:String = "luckyListUpdate";
		public static const LUCKYSELECT_UPDATE:String = "luckySelectUpdate";
		
		public var data:Object;
		public function PersonalPartUpdateEvents(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}