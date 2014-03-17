package sszt.pvp.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PVPEvent extends Event
	{
		public var data:Object;
		
		public static const PVP_EXPLOIT_INFO_UPDATE:String = "pvpExploitInfoUpdate";
		public static const PVP_JOIN:String ="pvpJoin";
		public static const PVP_QUIT:String ="pvpQuit";
		
		public function PVPEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}