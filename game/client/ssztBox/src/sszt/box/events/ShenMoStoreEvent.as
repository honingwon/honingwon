package sszt.box.events
{
	import flash.events.Event;
	
	public class ShenMoStoreEvent extends Event
	{
		public static const ADD_ITEM:String = "addItem";
		public static const REMOVE_ITEM:String = "removeItem";
		public static const UPDATE:String = "update";
		public static const TOTAL_CHANGED:String = "totalChanged";
		
		public static const GAIN_ITEM_UPDATE:String = "gainItemUpdate";
		
		public static const ITEM_UPDATE:String = "itemUpdate";
		public static const CLEAR:String = "clear";
		
		public var data:Object;
		public function ShenMoStoreEvent(type:String,obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}