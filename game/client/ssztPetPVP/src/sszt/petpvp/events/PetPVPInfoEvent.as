package sszt.petpvp.events
{
	import flash.events.Event;
	
	public class PetPVPInfoEvent extends Event
	{
		public var data:Object;
		
		public static const ALL_UPDATE:String = 'allUpdate';
		public static const CHALLENGE_INFO_UPDATE:String = 'challengeInfoUpdate';
		public static const RESULT_UPDATE:String = 'resultUpdate';
		public static const CHALLENGE_TIMES_UPDATE:String = 'challengeTimesUpdate';
		public static const MY_PETS_INFO_UPDATE:String = 'myPetsInfoUpdate';
		public static const RANK_INFO_UPDATE:String = 'rankInfoUpdate';
		public static const LOG_INFO_UPDATE:String = 'logInfoUpdate';
		public static const AWARD_STATE_UPDATE:String = 'awardStateUpdate';
		
		public function PetPVPInfoEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}