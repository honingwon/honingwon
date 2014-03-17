package sszt.events
{
	import flash.events.Event;
	
	public class PetPVPModuleEvent extends Event
	{
		public static const START_CHALLENGING:String = "startChallenging";
		public static const PET_PVP_SELF_LOG:String = "petPVPSelfLog";
		public static const DAILY_REWARD_STATE:String = "dailyRewardState";
		public static const UPDATE_ICON_VIEW:String = "updateIconView";
		public static const UPDATE_COUNT_DOWN:String = "updateCountDown";
		
		
		public var data:Object;
		
		public function PetPVPModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}