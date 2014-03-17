package sszt.core.data.player
{
	import flash.events.Event;
	
	public class PlayerInfoUpdateEvent extends Event
	{
		public static const PKVALUE_CHANGE:String = "PKValueChange";
		
		public static const CLUBINFO_UPDATE:String = "clubInfoUpdate";
		
		public static const LIFE_EXP_SIT_STATE_UPDATE:String = "lifeExpSitStateUpdate";
		
		
		
		public var data:Object;
		
		public function PlayerInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}