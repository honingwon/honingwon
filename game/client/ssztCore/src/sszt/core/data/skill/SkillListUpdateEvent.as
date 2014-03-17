package sszt.core.data.skill
{
	import flash.events.Event;
	
	public class SkillListUpdateEvent extends Event
	{
		public static const ADD_SKILL:String = "addSkill";
		public static const REMOVE_SKILL:String = "removeSkill";
		public static const UPDATE_SKILL:String = "updateSkill";
		
		public var data:Object;
		
		public function SkillListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}