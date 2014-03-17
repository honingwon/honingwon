package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubWealUpdateEvent extends Event
	{
		public static const WEAL_INFO_UPDATE:String = "wealInfoUpdate";
		
		public var data:Object;
		
		public function ClubWealUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}