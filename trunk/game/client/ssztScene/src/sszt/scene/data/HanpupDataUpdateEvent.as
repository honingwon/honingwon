package sszt.scene.data
{
	import flash.events.Event;
	
	public class HanpupDataUpdateEvent extends Event
	{
		public static const ADD_SKILL:String = "addSkill";
		public static const REMOVE_SKILL:String = "removeSkill";
		
		public var data:Object;
		
		public function HanpupDataUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}