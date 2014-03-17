package sszt.core.data.entrustment
{
	import flash.events.Event;
	
	public class EntrustmentInfoEvent extends Event
	{
		public static const IS_IN_ENTRUSTING:String = 'isInEntrusting';
		public function EntrustmentInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}