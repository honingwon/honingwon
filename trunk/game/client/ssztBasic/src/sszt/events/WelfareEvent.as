package sszt.events
{
	import flash.events.Event;
	
	import sszt.events.ModuleEvent;
	
	public class WelfareEvent extends ModuleEvent
	{
		public static const EXCHANGE_EXP:String = "exChange";
		public static const UPDATE_LOGIN_REWARD:String = "updateLoginReward";
		
		public static const DISCOUNT_UPDATE:String = "discountUpdate";
		public static const COUNT_CHANGE:String = "countChange";
		public static const AWARD_GET_UPDATE:String = "awardGetUpdate";
		
		
		public function WelfareEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj,bubbles, cancelable);
		}
	}
}