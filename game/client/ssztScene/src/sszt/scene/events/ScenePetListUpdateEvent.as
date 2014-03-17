package sszt.scene.events
{
	import flash.events.Event;
	
	public class ScenePetListUpdateEvent extends Event
	{
		public static const ADD_PET:String = "addPet";
		public static const REMOVE_PET:String = "removePet";
		
		public var data:Object;
		
		public function ScenePetListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}