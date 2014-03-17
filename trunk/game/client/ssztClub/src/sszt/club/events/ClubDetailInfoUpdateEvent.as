package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubDetailInfoUpdateEvent extends Event
	{
		public static const DETAILINFO_UPDATE:String = "detailInfoUpdate";
		
		public var data:Object;
		
		public function ClubDetailInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}