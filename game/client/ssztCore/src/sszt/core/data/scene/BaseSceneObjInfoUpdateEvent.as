package sszt.core.data.scene
{
	import flash.events.Event;
	
	public class BaseSceneObjInfoUpdateEvent extends Event
	{
		public static const WALK_START:String = "walkStart";
		
		public static const POSITION_UPDATE:String = "positionUpdate";
		
		public static const SELECTED_CHANGE:String = "selectedChange";
		
		public static const MOVE:String = "move";
		
		public static const MOVETYPE_UPDATE:String = "moveTypeUpdate";
		
		public static const SCENEREMOVE:String = "sceneRemove";
		
		public var data:Object;
		
		public function BaseSceneObjInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}