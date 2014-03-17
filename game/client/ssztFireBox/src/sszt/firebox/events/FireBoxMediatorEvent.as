package sszt.firebox.events
{
	import flash.events.Event;
	
	public class FireBoxMediatorEvent extends Event
	{
		public static const FIREBOX_COMMAND_START:String = "fireBoxCommandStart";
		public static const FIREBOX_COMMAND_END:String = "fireBoxCommandEnd";
		
		public static const FIREBOX_MEDIATOR_START:String = "fireBoxMediatorStart";
		public static const FIREBOX_MEDIATOR_DISPOSE:String = "fireBoxMediatorDispose";
		
		public var data:Object;
		public function FireBoxMediatorEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data =obj;
			super(type, bubbles, cancelable);
		}
	}
}