package sszt.core.data.club
{
	import flash.events.Event;
	
	public class ClubSkillEvent extends Event
	{
		public static const CLUB_SKILL_UPDATE:String = "clubSkillUpdate";
		public static const ADD_CLUB_SKILL:String = "addClubSkill";
		public static const REMOVE_CLUB_SKILL:String = "removeClubSkill"
		public var data:Object;
		
		public function ClubSkillEvent(type:String,obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}