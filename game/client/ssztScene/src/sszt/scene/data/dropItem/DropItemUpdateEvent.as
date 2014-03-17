package sszt.scene.data.dropItem
{
	import flash.events.Event;
	
	public class DropItemUpdateEvent extends Event
	{
		public static const STATE_UPDATE:String = "stateUpdate";
		
		public var data:Object;
		
		public function DropItemUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}