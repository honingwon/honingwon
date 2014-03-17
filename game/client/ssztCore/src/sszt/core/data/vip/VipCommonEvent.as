package sszt.core.data.vip
{
	import flash.events.Event;
	
	public class VipCommonEvent extends Event
	{
		public static const VIPSTATECHANGE:String = "vipStateChange";
		public static const AWARDSTATECHANGE:String = "awardStateChange";
		
		public static const AWARD_YUANBAO_STATECHANGE:String = "awardYuanbaoStateChange";
		public static const AWARD_COPPER_STATECHANGE:String = "awardCopperStateChange";
		public static const AWARD_BUFF_STATECHANGE:String = "awardBuffStateChange";
		
		public static const VIPTYPECHANGE:String = "vipTypeChange";
		
		public function VipCommonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}