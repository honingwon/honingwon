package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubListInfoUpdateEvent extends Event
	{
		public static const SETCLUBLIST:String = "setClubList";
		
		public var data:Object;
		
		public function ClubListInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}