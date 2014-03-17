package sszt.scene.events
{
	import flash.events.Event;
	
	public class SelfScenePlayerUpdateEvent extends Event
	{
		/**
		 * 切换地图9宫格
		 */		
		public static const MAP_GRID_UPDATE:String = "mapGridUpdate";
		
		public var data:Object;
		
		public function SelfScenePlayerUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}