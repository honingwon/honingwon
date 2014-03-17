package sszt.core.data.skill
{
	import flash.events.Event;
	
	public class SkillItemInfoUpdateEvent extends Event
	{
		public static const LOCKUPDATE:String = "lockUpdate";
		
		public static const COOLDOWN_UPDATE:String = "cooldownUpdate";
		
		public static const SKILL_UPGRADE:String = "skillUpgrade";
		
		public var data:Object;
		
		public function SkillItemInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}