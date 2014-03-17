package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneAttackableInfoUpdateEvent extends Event
	{
		public static const ATTACKSTATE_UPDATE:String = "attackStateUpdate";
		
		public static const ADDACTION:String = "addAction";
		
		public var data:Object;
		
		public function SceneAttackableInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}