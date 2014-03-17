package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneDuplicatePassUpdateEvent extends Event
	{
		public static const DUPLICATE_PASS_UPDATE_AWARD:String = "duplicatePassUpdateAward";
		public static const DUPLICATE_PASS_UPDATE_MONSTER:String = "duplicatePassUpdateMonster";
		public var data:Object;
		public function SceneDuplicatePassUpdateEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}