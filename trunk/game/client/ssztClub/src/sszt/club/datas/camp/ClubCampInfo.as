package sszt.club.datas.camp
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.club.events.ClubCampInfoUpdateEvent;

	public class ClubCampInfo extends EventDispatcher
	{
		public static const BOSS_REMAINING_TIMES_MAX:int = 5;
		public static const COLLECTION_REMAINING_TIMES_MAX:int = 5;
		
		private var _lastCalledClubBossId:int;
		private var _lastCalledClubCollectionId:int;
		private var _bossRemainingTimes:int;
		private var _collectionRemainingTimes:int;
		private var _lastCalledCollectionTime:int;
		
		public function set lastCalledClubBossId(id:int):void
		{
			_lastCalledClubBossId = id;
			dispatchEvent(new ClubCampInfoUpdateEvent(ClubCampInfoUpdateEvent.CALL_CLUB_BOSS_SUCCESSFULLY));
		}
		
		public function get lastCalledClubBossId():int
		{
			return _lastCalledClubBossId;
		}
		
		public function set lastCalledClubCollectionId(id:int):void
		{
			_lastCalledClubCollectionId = id;
			dispatchEvent(new ClubCampInfoUpdateEvent(ClubCampInfoUpdateEvent.CALL_CLUB_COLLECTION_SUCCESSFULLY));
		}
		
		public function get lastCalledClubCollectionId():int
		{
			return _lastCalledClubCollectionId;
		}
		
		public function updateRemainingTimes(bossRemainingTimes:int,collectionRemainingTimes:int,lastTime:int):void
		{
			_bossRemainingTimes = bossRemainingTimes;
			_collectionRemainingTimes = collectionRemainingTimes;
			_lastCalledCollectionTime = lastTime;
			dispatchEvent(new ClubCampInfoUpdateEvent(ClubCampInfoUpdateEvent.CLUB_CALL_REMAINING_TIMES_UPDATE));
		}
		
		public function get bossRemainingTimes():int
		{
			return _bossRemainingTimes;
		}
		
		public function get collectionRemainingTimes():int
		{
			return _collectionRemainingTimes;
		}
		
		public function get lastCalledCollectionTime():int
		{
			return _lastCalledCollectionTime;
		}
	}
}