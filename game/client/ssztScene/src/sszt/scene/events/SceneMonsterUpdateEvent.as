package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneMonsterUpdateEvent extends Event
	{
		public static const ADD_MONSTER:String = "addMonster";
		public static const REMOVE_MONSTER:String = "removeMonster";
		
		public var data:Object;
		
		public function SceneMonsterUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}