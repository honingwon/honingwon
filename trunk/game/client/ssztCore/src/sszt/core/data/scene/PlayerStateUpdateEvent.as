package sszt.core.data.scene
{
	import flash.events.Event;
	
	public class PlayerStateUpdateEvent extends Event
	{
		public static const STATE_CHANGE:String = "stateChange";
		
		public static const CLIENT_STATE_CHANGE:String = "clientStateChange";
		
		public var data:Object;
		
		public function PlayerStateUpdateEvent(type:String,data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}