package sszt.scene.data.roles
{
	import flash.events.Event;
	
	public class BaseScenePetInfoUpdateEvent extends Event
	{
		public static const NAME_UPDATE:String = "nameUpdate";
		
		public static const STYLE_UPDATE:String = "styleUpdate";
		
		public var data:Object;
		
		public function BaseScenePetInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}