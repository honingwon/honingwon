package sszt.personal.events
{
	import flash.events.Event;
	
	public class PersonalMediatorEvents extends Event
	{
		public static const PERSONAL_COMMAND_START:String = "personalCommandStart";
		public static const PERSONAL_COMMAND_END:String = "personalCommandEnd";
		
		public static const PERSONAL_MEDIATOR_START:String = "personalMediatorStart";
		public static const PERSONAL_MEDIATOR_DISPOSE:String = "personlMediatorDispose";
		
		public var data:Object;
		public function PersonalMediatorEvents(type:String,obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}