package sszt.events
{
	import flash.events.Event;
	
	public class MailModuleEvent extends Event
	{
		public static const NEW_MAIL:String = "new mail";
		
		public static const SHOW_MAIL_PANEL:String = "showMailPanel";
		
		public var data:Object;
		public function MailModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}