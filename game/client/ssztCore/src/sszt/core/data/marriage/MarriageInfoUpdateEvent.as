package sszt.core.data.marriage
{
	import flash.events.Event;
	
	public class MarriageInfoUpdateEvent extends Event
	{
		public static const WEDDING_GIFT_LIST_UPDATE:String = "weddingGiftListUpdate";
		
		public function MarriageInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}