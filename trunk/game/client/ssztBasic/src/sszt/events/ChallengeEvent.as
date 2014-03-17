package sszt.events
{
	import sszt.events.ModuleEvent;
	
	public class ChallengeEvent extends ModuleEvent
	{
		
		/**
		 * 试炼副本记录信息刷新
		 */		
		public static const CHALLENGE_BOSS_INFO:String = "challengeBossInfo";
		
		/**
		 * 霸主信息
		 */		
		public static const CHALLENGE_TOP_INFO:String = "challengeTopInfo";
		
		public function ChallengeEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}