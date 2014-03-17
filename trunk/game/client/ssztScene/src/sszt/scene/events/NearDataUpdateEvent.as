package sszt.scene.events
{
	import flash.events.Event;
	
	public class NearDataUpdateEvent extends Event
	{
		public static const SETDATA_COMPLETE:String = "setDataComplete";
		
		public var data:Object;
		
		public function NearDataUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}