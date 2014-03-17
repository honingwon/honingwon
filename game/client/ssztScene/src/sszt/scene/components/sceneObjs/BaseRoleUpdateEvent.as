package sszt.scene.components.sceneObjs
{
	import flash.events.Event;
	
	public class BaseRoleUpdateEvent extends Event
	{
		public var data:Object;
		
		public function BaseRoleUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}