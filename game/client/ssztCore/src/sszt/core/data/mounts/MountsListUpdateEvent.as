package sszt.core.data.mounts
{
	import flash.events.Event;
	
	public class MountsListUpdateEvent extends Event
	{
		public static const ADD_MOUNTS:String = "addMounts";
		public static const REMOVE_MOUNTS:String = "removeMounts";

		public var data:Object;
		
		public function MountsListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}