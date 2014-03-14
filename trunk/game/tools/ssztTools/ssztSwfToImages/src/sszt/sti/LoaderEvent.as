package sszt.sti
{
	import flash.events.Event;
	
	public class LoaderEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		public static const LOAD_PROGRESS:String = "loadProgress";
		
		public var data:Object;
		public var bytesLoaded:Number; 
		public var bytesTotal:Number;
		
		
		
		public function LoaderEvent(type:String,data:Object = null,bytesLoadered:Number = 0,bytesTotal:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			this.bytesLoaded = bytesLoadered;
			this.bytesTotal = bytesTotal;
			super(type, bubbles, cancelable);
		}
	}
}