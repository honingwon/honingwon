package sszt.events
{
	import flash.events.Event;
	
	public class CellEvent extends Event
	{
		
		public static const CELL_DOUBLECLICK:String = "cellDoubleClick";
		
		public static const CELL_CLICK:String = "cellClick";
		
		public static const CELL_CHANGE:String = "cellChange";
		
		public static const CELL_MOVE:String = "cellMove";

		public static const CELL_DELETE:String = "cellDelete";
		
		public var data:Object;
		
		public function CellEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}