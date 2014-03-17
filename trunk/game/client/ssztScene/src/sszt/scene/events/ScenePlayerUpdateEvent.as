package sszt.scene.events
{
	import flash.events.Event;
	
	public class ScenePlayerUpdateEvent extends Event
	{
		public static const ADDPLAYER:String = "addPlayer";
		public static const REMOVEPLAYER:String = "removePlayer";
		
		public static const INFO_UPDATE:String = "infoUpdate";
		
		public var data:Object;
		
		public function ScenePlayerUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}