package sszt.ui.page
{
	import flash.events.Event;
	
	public class PageEvent extends Event
	{
		public static const PAGE_CHANGE:String = "pageChange";
		
		public var currentPage:int;
		public var lastPage:int;
		
		public function PageEvent(type:String,currentPage:int = 0,lastPage:int = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.currentPage = currentPage;
			this.lastPage = lastPage;
			super(type, bubbles, cancelable);
		}
	}
}