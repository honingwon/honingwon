package sszt.events
{
	import flash.events.Event;
	
	public class StoreModuleEvent extends Event
	{
		public static const MYSTERY_SHOPINFO_UPDATE:String = "mysteryShopInfoUpdate";
		public static const MYSTERY_VIPTIME_UPDATE:String = "mysteryViptimeUpdate";
		public static const MYSTERY_REFRESH_UPDATE:String = "mysteryRefreshUpdate";
		public var data:Object;
		
		public function StoreModuleEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}