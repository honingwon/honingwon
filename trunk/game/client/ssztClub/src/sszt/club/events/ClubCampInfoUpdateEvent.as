package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubCampInfoUpdateEvent extends Event
	{
		public static const CALL_CLUB_BOSS_SUCCESSFULLY:String = "callClubBossSuccessfully";
		public static const CALL_CLUB_COLLECTION_SUCCESSFULLY:String = "callClubCollectionSuccessfully";
		public static const CLUB_CALL_REMAINING_TIMES_UPDATE:String = 'clubCallRemainingTimesUpdate';
		
		
		public var data:Object;
		
		public function ClubCampInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}