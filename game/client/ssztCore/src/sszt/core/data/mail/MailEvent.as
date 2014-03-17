package sszt.core.data.mail
{
	import flash.events.Event;
	
	public class MailEvent extends Event
	{
		public static const MAIL_LOAD_FINISH:String = "load finish";
		public static const MAIL_ADD:String = "mail add";
		public static const MAIL_DELETE:String = "mail delete";
		public static const MAIL_READ:String = "mail read";
		public static const MAIL_ATTACH_RECEIVE:String = "mail attach receive";
		public static const MAIL_SEND_RESULT:String = "send result";
		public var data:Object;
		public function MailEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}