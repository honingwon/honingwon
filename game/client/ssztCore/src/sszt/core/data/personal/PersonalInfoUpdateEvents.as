package sszt.core.data.personal
{
	import flash.events.Event;
	
	public class PersonalInfoUpdateEvents extends Event
	{
		public static const PERSONAL_MY_INFO_UPDATE:String = "personalMyInfoUpdate";
		public static const PERSONAL_MY_HEAD_UPDATE:String = "personalMyHeadUpdate";
		
		public static const PERSONAL_FRIENDINFO_UPDATE:String = "personalFriendInfoUpdate";
		public static const PERSONAL_CLUBINFO_UPDATE:String = "personalClubInfoUpdate";
		
		public var data:Object;
		public function PersonalInfoUpdateEvents(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}