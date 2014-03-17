package sszt.core.data.worldBossInfo
{
	import flash.events.Event;
	
	public class WorldBossUpdateEvent extends Event
	{
		public static const UPDATE_REMAINING_NUM:String = 'updateRemainingNum';
		
		public function WorldBossUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}