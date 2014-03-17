package sszt.events
{
	import flash.events.Event;
	
	public class NavigationModuleEvent extends Event
	{
		public static const SHOW_NAVIGATION:String = "showNavigation";
		public static const HIDE_NAVIGATION:String = "hideNavigation";
		
		public var data:Object;
		
		public function NavigationModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}