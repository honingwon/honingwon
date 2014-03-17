package sszt.core.data.item
{
	import flash.events.Event;
	
	public class ItemInfoUpdateEvent extends Event
	{
		public static const UPDATE:String = "update";
		
		public static const LOCK_UPDATE:String = "lockUpdate";
		
		public static const COOLDOWN_UPDATE:String = "cooldownUpdate";
		
		public var data:Object;
		
		public function ItemInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}