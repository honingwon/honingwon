package sszt.scene.events
{
	import flash.events.Event;
	
	public class ScenePvP1UpdateEvent extends Event
	{
		public static const PVP1_CLOSE_COUNTDOWN:String = "pvp1CloseCountDown";
		public static const PVP1_STOP_COUNTDOWN:String = "pvp1StopCountDown";
		
		public var data:Object;		
		public function ScenePvP1UpdateEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}