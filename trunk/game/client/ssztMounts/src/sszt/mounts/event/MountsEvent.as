package sszt.mounts.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MountsEvent extends Event
	{
		public var data:Object;
		public static var CELL_QUALITY_UPDATE:String = "cellQualityUpdate";
		public static var CELL_QUALITY_ADD:String = "cellQualityAdd";
		public static var CELL_QUALITY_DELETE:String = "cellQualityDelete";
		
		public static var CELL_ALL_CLEAR:String = "cellAllClear";
		public static var CELL_MIDDLE_CLEAR:String = "cellMiddleClear";
		public static var CELL_CLICK:String = "cellClick";
		public static var CELL_PUTAGAIN:String = "cellPutAgain";
		public static var CELL_REFINING_CLEAR:String = "cellRefiningClear";
		
		public static var CELL_QUICKBUY_INITIAL:String = "cellQuickBuyInitial";
		
		public static var MOUNTS_CELL_UPDATE:String = "mountsCellUpdate";
		
		public static var ITEMINFO_CELL_UPDATE:String = "itemInfoCellUpdate";
		
		public static var MOUNTS_ID_UPDATE:String = "mountsIdUpdate";
		
		public static var GET_SKILL_BOOK_LIST:String = "mountsGetSkillBookList";
		
		public static var GET_SKILL_BOOK_SUCCESSED:String = "mountsGetSkillBookSuccessed";
		
		
		
		public function MountsEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data =obj;
			super(type, bubbles, cancelable);
		}
	}
}