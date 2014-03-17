package sszt.rank.components.treeView.event
{
	import flash.events.Event;
	
	public class TreeItemEvent extends Event
	{
		public static const ITEM_SELECT_CHANGE:String = "itemSelectChange";
		public static const GROUP_SELECT_CHANGE:String = "groupSelectChange";
		public var data:Object;
		public function TreeItemEvent(type:String,obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}