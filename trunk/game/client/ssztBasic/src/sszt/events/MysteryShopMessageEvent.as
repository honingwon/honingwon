package sszt.events
{
	import flash.events.Event;
	
	public class MysteryShopMessageEvent extends Event
	{
		public static const Mystery_MSG_ADD:String = "MysteryMsgAdd";
		public static const Mystery_MSG_REMOVE:String = "MysteryMsgRemove";
		public static const Mystery_MSG_LOADED:String = "MysteryMsgLoaded";
		public static const GAIN_ITEM_LIST_UPDATE:String = "gainItemListUpdate";
		public var data:Object
		public function MysteryShopMessageEvent(type:String,obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}