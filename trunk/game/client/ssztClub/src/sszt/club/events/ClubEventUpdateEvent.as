package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubEventUpdateEvent extends Event
	{
		public static const CLUE_EVENT_UPDATE:String = "clubEventUpdate";
		
		public var data:Object;
		
		public function ClubEventUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}