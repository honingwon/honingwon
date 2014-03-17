package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubManageInfoUpdateEvent extends Event
	{
		public static const MEMBERLIST_UPDATE:String = "memberListUpdate";
		
		public static const EXTEND_INFO_UPDATE:String = "extendInfoUpdate";
		
		public static const LEVELUP_INFO_UPDATE:String = "levelUpInfoUpdate";
		
		public var data:Object;
		
		public function ClubManageInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}