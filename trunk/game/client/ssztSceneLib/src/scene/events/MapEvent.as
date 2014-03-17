package scene.events{
	import flash.events.Event;
	
	public class MapEvent extends Event {
		
		public static const NEED_DATA:String = "needData";
		
		public var col:int;
		public var row:int;
		
		public function MapEvent(type:String, row:int, col:int, bubbles:Boolean=false, cancelable:Boolean=false){
			this.row = row;
			this.col = col;
			super(type, bubbles, cancelable);
		}
	}
}//package scene.events
