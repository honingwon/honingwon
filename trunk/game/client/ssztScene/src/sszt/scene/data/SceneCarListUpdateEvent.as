package sszt.scene.data
{
	import flash.events.Event;
	
	public class SceneCarListUpdateEvent extends Event
	{
		public static const ADD_CAR:String = "addCar";
		public static const REMOVE_CAR:String = "removeCar";
		
		public var data:Object;
		
		public function SceneCarListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}