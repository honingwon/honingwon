package sszt.core.data.titles
{
	import flash.events.Event;
	
	public class TitleNameEvents extends Event
	{
		public static const TITLE_NAME_UPDATE:String = "titleNameUpdate";
		
		public static const TITLE_NAME_CHANGE:String = "titleNameChange";
		
		public function TitleNameEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}