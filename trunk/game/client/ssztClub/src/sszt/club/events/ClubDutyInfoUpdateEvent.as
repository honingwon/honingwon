package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubDutyInfoUpdateEvent extends Event
	{
		public static const CLUB_DUTYINFO_UPDATE:String = "clubDutyInfoUpdate";
		
		public var data:Object;
		
		public function ClubDutyInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}