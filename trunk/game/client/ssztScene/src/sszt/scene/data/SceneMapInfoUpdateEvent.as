package sszt.scene.data
{
	import flash.events.Event;
	
	public class SceneMapInfoUpdateEvent extends Event
	{
		public static const SETDATA_COMPLETE:String = "setDataComplete";
		
		public static const SHOW_NPC_PANEL:String = "showNpcPanel";
		
		public static const LOAD_DATA_COMPLETE:String = "loadDataComplete";
		
		
		public var data:Object;
		
		public function SceneMapInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}