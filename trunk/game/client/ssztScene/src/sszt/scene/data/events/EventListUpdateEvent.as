package sszt.scene.data.events
{
	import flash.events.Event;
	
	public class EventListUpdateEvent extends Event
	{
		public static const ADDEVENT:String = "addEvent";
		public static const REMOVEEVENT:String = "removeEvent";
		
		public var data:Object;
		
		public function EventListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}