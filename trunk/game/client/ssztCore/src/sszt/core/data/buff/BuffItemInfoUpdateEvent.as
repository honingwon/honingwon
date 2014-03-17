package sszt.core.data.buff
{
	import flash.events.Event;
	
	public class BuffItemInfoUpdateEvent extends Event
	{
		public static const PAUSE_UPDATE:String = "pauseUpdate";
		
		public var data:Object;
		
		public function BuffItemInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}