package sszt.scene.events
{
	import flash.events.Event;
	
	public class ScenePlayerListUpdateEvent extends Event
	{
		public static const ADDPLAYER:String = "addPlayer";
		public static const REMOVEPLAYER:String = "removePlayer";
		
		public static const SETSELF_COMPLETE:String = "setSelfComplete";
		
		public static const DOUBLESIT_CHANGE:String = "doubleSitChange";
		
		public var data:Object;
		
		public function ScenePlayerListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}