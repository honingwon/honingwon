package sszt.events
{
	import flash.events.Event;
	
	public class EnthralModuleEvent extends Event
	{
		public static const SHOW_ENTHRAL_ICON:String = "showEnthralIcon";
		public static const REMOVE_ENTHRAL_ICON:String = "removeEnthralIcon";
		public var data:Object;
		
		public function EnthralModuleEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}