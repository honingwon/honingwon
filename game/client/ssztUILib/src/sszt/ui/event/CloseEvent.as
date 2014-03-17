package sszt.ui.event
{
	import flash.events.Event;
	
	public class CloseEvent extends Event
	{
		public static const CLOSE:String = "close";
		
		public var detail:int;
		public var isSelected:Boolean;
		public var data:Object;
		
		public function CloseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,detail1:int = 0x0004,isSelected1:Boolean=false, ndata1:Object=null)
		{
			detail = detail1;
			isSelected = isSelected1;
			data = ndata1;
			super(type, bubbles, cancelable);
		}
	}
}