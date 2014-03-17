package sszt.skill.events
{
	import flash.events.Event;
	
	public class CellEvent extends Event
	{
		
		public static const UPGRADE_CLICK:String = "UPGRADE_CLICK";
		
		public var data:Object;
		
		public function CellEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}