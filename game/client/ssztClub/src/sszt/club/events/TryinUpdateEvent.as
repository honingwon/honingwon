package sszt.club.events
{
	import flash.events.Event;
	
	public class TryinUpdateEvent extends Event
	{
		public static const TRYIN_UPDATE:String = "tryInUpdate";
		
		public var data:Object;
		
		public function TryinUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}