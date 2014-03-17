package sszt.scene.events
{
	import flash.events.Event;
	
	public class ScenePvpFirstUpdateEvent extends Event
	{
		public static const PVP_FIRST_INFO_UPDATE:String = "pvpFirstInfoUpdate";
		
		public var data:Object;
		public function ScenePvpFirstUpdateEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}