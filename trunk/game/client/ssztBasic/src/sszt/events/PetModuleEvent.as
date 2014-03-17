package sszt.events
{
	import flash.events.Event;
	
	public class PetModuleEvent extends Event
	{
		public static const XISUI_SUCCESS:String = "xisuiSuccess";
		public static const MOUNTS_XISUI_SUCCESS:String = "mountsXisuiSuccess";
		
		public var data:Object;
		
		public function PetModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}