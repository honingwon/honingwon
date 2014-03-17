package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneInfoUpdateEvent extends Event
	{
		public static const SELECT_CHANGE:String = "selectedChange";
		
		public static const SETNAIL_COMPLETE:String = "setNailComplete";
		
		public static const MAP_ENTER:String = "mapEnter";
		
		public static const RENDER:String = "render";
		
		public static const BIGMAP_SELECT_CHANGE:String = "bigmapSelectChange";
		
		public var data:Object;
		
		public function SceneInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}