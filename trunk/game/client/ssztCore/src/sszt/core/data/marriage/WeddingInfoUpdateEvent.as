package sszt.core.data.marriage
{
	import flash.events.Event;
	
	public class WeddingInfoUpdateEvent extends Event
	{
		public static const FREE_CANDIES_NUM_UPDATE:String = 'freeCandiesNumUpdate';
		public static const IN_CEREMONY:String = 'inCeremony';
		public static const INIT:String = 'init';
		public static const SECONDS_UPDATE:String = 'secondsUpdate';
		
		public function WeddingInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}