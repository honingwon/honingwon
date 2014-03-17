package sszt.common.wareHouse.event
{
	import flash.events.Event;
	
	public class WareHouseEvent extends Event
	{
		public static const ADD_ITEM:String = "add item";
		public static const REMOVE_ITEM:String = "remove item";
		public static const UPDATE:String = "update";
		public static const COPPER_CHANGE:String = "copper change";
		public var data:Object;
		public function WareHouseEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}