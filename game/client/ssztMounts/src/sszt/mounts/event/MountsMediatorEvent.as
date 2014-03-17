package sszt.mounts.event
{
	import flash.events.Event;
	
	public class MountsMediatorEvent extends Event
	{
		public var data:Object;
		public static const MOUNTS_START_COMMAND:String = "mountsStartCommand";
		public static const MOUNTS_END_COMMAND:String = "mountsEndCommand";
		public static const MOUNTS_START:String = "mountsStart";
		public static const MOUNTS_FEED_START:String = "mountsFeedStart";
		public static const MOUNTS_DISPOSE:String = "mountsDispose";
		public static const SHOW_CALL_PANEL:String = "showCallPanel";
		public static const SHOW_MOUNT:String = "showMount";
		
		public function MountsMediatorEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}