package scene.events{
	import flash.events.Event;
	
	public class BaseSceneObjectEvent extends Event {
		
		public static const SCENEOBJ_CLICK:String = "sceneObjClick";
		public static const SCENEOBJ_OUT:String = "sceneObjOut";
		public static const SCENEOBJ_OVER:String = "sceneObjOver";
		
		public var data:Object;
		
		public function BaseSceneObjectEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false){
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}//package scene.events
