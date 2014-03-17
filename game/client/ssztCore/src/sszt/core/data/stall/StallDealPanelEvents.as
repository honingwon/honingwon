package sszt.core.data.stall
{
	import flash.events.Event;
	
	public class StallDealPanelEvents extends Event
	{
		//摆摊交易信息更新
		public static const STALL_CONTENT_UPDATE:String = "stallContentUpdate";
		//摆摊交易信息清空
		public static const STALL_CLEAR_CONTENT:String = "stallClearContent";
		//摆摊名更新
		public static const STALL_NAME_UPDATE:String = "stallNameUpdate";
		
		public var data:Object;
		
		public function StallDealPanelEvents(type:String, argData:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = argData;
		}
	}
}