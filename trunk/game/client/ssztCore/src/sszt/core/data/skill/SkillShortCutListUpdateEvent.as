package sszt.core.data.skill
{
	import flash.events.Event;
	
	public class SkillShortCutListUpdateEvent extends Event
	{
		public static const UPDATE_SHORTCUT:String = "updateShortCut";
		
		public var data:Object;
		
		public function SkillShortCutListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}