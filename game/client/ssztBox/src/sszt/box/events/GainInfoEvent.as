package sszt.box.events
{
	import flash.events.Event;
	
	public class GainInfoEvent extends Event
	{
		public static const GAIN_INFO_ADD:String = "gainInfoAdd";
		public static const GAIN_INFO_REMOVE:String = "gainInfoRemove";
		public var data:Object;
		public function GainInfoEvent(type:String,obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;	
			super(type, bubbles, cancelable);
		}
	}
}