package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubArmyInfoUpdateEvent extends Event
	{
		public static const ARMYINFO_UPDATE:String = "armyInfoUpdate";
		
		public static const ARMY_MEMBER_UPDATE:String = "armyMemberUpdate";
		
		public var data:Object;
		
		public function ClubArmyInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}