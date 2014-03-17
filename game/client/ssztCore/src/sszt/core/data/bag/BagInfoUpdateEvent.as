package sszt.core.data.bag
{
	import flash.events.Event;
	
	public class BagInfoUpdateEvent extends Event
	{
		public static const ITEM_UPDATE:String = "itemUpdate";
		public static const ITEM_ID_UPDATE:String = "itemIdUpdate";
		public static const BAG_EXTEND:String =" bagExtend";
		
		public var data:Object;
		
		public function BagInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}