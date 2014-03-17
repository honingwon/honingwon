package sszt.core.data.bag
{
	import flash.events.Event;
	
	public class PetBagInfoUpdateEvent extends Event
	{
		public static const ITEM_PLACE_UPDATE:String = 'itemPlaceUpdate';
		public static const ITEM_ID_UPDATE:String = 'itemIdUpdate';
		public var data:Object;
		
		public function PetBagInfoUpdateEvent(type:String, obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}