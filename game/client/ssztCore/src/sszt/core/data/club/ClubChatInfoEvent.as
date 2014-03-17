package sszt.core.data.club
{
	import flash.events.Event;
	
	public class ClubChatInfoEvent extends Event
	{
		public static const UPDATE:String = 'update';
		public function ClubChatInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}