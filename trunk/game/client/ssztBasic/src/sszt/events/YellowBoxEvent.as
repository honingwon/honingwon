package sszt.events
{
	import sszt.events.ModuleEvent;
	
	public class YellowBoxEvent extends ModuleEvent
	{
		/**
		 * 领取活动奖励
		 */		
		public static const GET_INFO:String = "getInfo";
		
		/**
		 * 领取活动奖励
		 */		
		public static const GET_AWARD:String = "getAward";
		
		public function YellowBoxEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}