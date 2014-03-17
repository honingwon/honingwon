package sszt.scene.data.resourceWar
{
	import flash.events.Event;
	
	public class ResourceWarInfoUpdateEvent extends Event
	{
		public static const RANK_INFO_UPDATE:String = 'rankInfoUpdate';
		public static const MY_POINT_UPDATE:String = 'myPointUpdate';
		public static const RESULT_UPDATE:String = 'resultUpdate';
		
		public function ResourceWarInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}