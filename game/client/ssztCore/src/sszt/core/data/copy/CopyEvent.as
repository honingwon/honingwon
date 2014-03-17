package sszt.core.data.copy
{
	import flash.events.Event;
	
	public class CopyEvent extends Event
	{
		public static const COPYAPPLY:String = "copyApply";
		public var data:Object;
		
		public function CopyEvent(type:String,obj:Object,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}