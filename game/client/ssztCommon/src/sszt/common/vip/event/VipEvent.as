package sszt.common.vip.event
{
	import flash.events.Event;
	
	public class VipEvent extends Event
	{
		public static var VIPERDATE_COMPLETE:String = "viperDataComplete";
		public static var SELFDATA_COMPLETE:String = "selfDataComplete";
		public var data:Object;
		
		public function VipEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}