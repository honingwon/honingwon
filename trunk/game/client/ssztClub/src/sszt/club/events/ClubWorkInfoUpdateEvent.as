package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubWorkInfoUpdateEvent extends Event
	{
		public static const WORK_INFO_UPDATE:String = "workInfoUpdate";
		
//		public static const WORK_INFO_INITIAL:String = "workInfoInitial";
		
		public var data:Object;
		
		public function ClubWorkInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}