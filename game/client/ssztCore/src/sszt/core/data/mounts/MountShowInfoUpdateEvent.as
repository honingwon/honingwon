package sszt.core.data.mounts
{
	import flash.events.Event;
	
	public class MountShowInfoUpdateEvent extends Event
	{
		public static var MOUNT_SHOW_INFO_LOAD_COMPLETE:String = "mountShowInfoLoadComplete";
		
		public function MountShowInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}