package sszt.firebox.events
{
	import flash.events.Event;
	
	public class FireBoxEvent extends Event
	{
		public var data:Object;
		public static var MATERIAL_CELL_UPDATE:String = "materialCellUpdate";
		public static var COMPOSE_NUMBER_UPDATE:String = "composeNumberUpdate"; 
		
		public function FireBoxEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data =obj;
			super(type, bubbles, cancelable);
		}
	}
}