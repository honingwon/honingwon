package sszt.scene.components.hangup
{
	import flash.events.Event;
	
	import sszt.core.data.skill.SkillItemInfo;
	
	public class HangupCellEvent extends Event
	{
		public static const DRAG_OUT:String = "dragOut";
		public static const DRAG_IN:String = "dragIn";
		
		public var info:SkillItemInfo;
		public var place:int;
		
		public function HangupCellEvent(type:String,info:SkillItemInfo = null,place:int = -1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.info = info;
			this.place = place;
			super(type, bubbles, cancelable);
		}
	}
}