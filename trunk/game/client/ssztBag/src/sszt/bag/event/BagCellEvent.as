package sszt.bag.event
{
	import flash.events.Event;
	
	public class BagCellEvent extends Event
	{		
		/**
		 * 通知服务器更新格子
		 */		
		public static const CELL_MOVE:String = "cellMove";
		
		public static const ITEM_RECYCLE:String ="itemRecycle";
		
		public static const ITEM_SPLIT:String = "itemSplit";
		
		public static const ITEM_DROP:String ="itemDrop";
		
		
		public var data:Object;
		
		public function BagCellEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}