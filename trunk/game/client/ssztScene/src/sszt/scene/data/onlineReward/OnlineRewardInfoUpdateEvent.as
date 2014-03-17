package sszt.scene.data.onlineReward
{
	import flash.events.Event;
	
	public class OnlineRewardInfoUpdateEvent extends Event
	{
		public static const UPDATE:String = 'update';
		public function OnlineRewardInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}