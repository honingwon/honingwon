package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubDeviceUpdateEvent extends Event
	{
		public static const DEVICE_UPDATE:String = "deviceUpdate";
		
		public function ClubDeviceUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}