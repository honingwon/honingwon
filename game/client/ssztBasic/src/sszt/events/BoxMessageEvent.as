package sszt.events
{
	import flash.events.Event;
	
	public class BoxMessageEvent extends Event
	{
		public static const BOX_MSG_ADD:String = "boxMsgAdd";
		public static const BOX_MSG_REMOVE:String = "BoxMsgRemove";
		public static const BOX_MSG_LOADED:String = "boxMsgLoaded";
		public static const GAIN_ITEM_LIST_UPDATE:String = "gainItemListUpdate";
		public var data:Object
		public function BoxMessageEvent(type:String,obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}