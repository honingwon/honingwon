package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubMonsterUpdateEvent extends Event
	{
		public static const CLUB_MONSTER_UPDATE:String = "clubMonsterUpdate";
		public var data:Object;
		public function ClubMonsterUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}