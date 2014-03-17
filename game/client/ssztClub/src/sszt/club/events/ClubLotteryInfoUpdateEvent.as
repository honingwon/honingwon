package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubLotteryInfoUpdateEvent extends Event
	{
		public static const UPDATE_TIMES:String = 'updateTimes';
		public static const UPDATE_ITEM_ID:String = 'updateItemId';
		
		public function ClubLotteryInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}