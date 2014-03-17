package sszt.scene.data.dropItem
{
	import flash.events.Event;
	
	public class DropItemListUpdateEvent extends Event
	{
		public static const ADD_ITEM:String = "addItem";
		public static const REMOVE_ITEM:String = "removeItem";
		
		public var data:Object;
		
		public function DropItemListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}