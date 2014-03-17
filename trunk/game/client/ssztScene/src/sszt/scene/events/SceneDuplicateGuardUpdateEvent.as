package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneDuplicateGuardUpdateEvent extends Event
	{
		public static const DUPLICATE_GUARD_UPDATE_AWARD:String = "duplicateGuardUpdateAward";
		public static const DUPLICATE_GUARD_UPDATE_MISSION:String = "duplicateGuardUpdateMission";
		public static const DUPLICATE_GUARD_CAN_OPEN_NEXT_MONSTER:String ="duplicateGuardCanOpenNextMonster";
		
		public var data:Object;
		public function SceneDuplicateGuardUpdateEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}