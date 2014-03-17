package sszt.club.events
{
	import flash.events.Event;
	
	public class ContributeInfoUpdateEvent extends Event
	{
		public static const CONTRIBUTE_INFO_UPDATE:String = "contributeInfoUpdate";
		
		public static const CONTRIBUTE_LOG_UPDATE:String = "contributeLogUpate";
		
		public var data:Object;
		
		public function ContributeInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}