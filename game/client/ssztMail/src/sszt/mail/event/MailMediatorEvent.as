package sszt.mail.event
{
	import flash.events.Event;
	
	public class MailMediatorEvent extends Event
	{
		public static const MAILSTARTCOMMAND:String = "mailStartCommand";
		public static const MAILENDCOMMAND:String = "mailEndCommand";
		public static const MAILSTART:String = "mailStart";
		public static const SHOWWRITEPANEL:String = "showWritePanel";
		public static const MAILDISPOSE:String = "mailDispose";
		public function MailMediatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}