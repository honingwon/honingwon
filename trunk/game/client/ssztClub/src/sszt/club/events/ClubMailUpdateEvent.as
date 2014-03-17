package sszt.club.events
{
	import flash.events.Event;

	public class ClubMailUpdateEvent extends Event
	{
		public static var MAIL_SEND_SUCCESS:String = "mailSendSuccess";
		public var data:Object;
		
		public function ClubMailUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type,bubbles,cancelable);
		}
	}
}