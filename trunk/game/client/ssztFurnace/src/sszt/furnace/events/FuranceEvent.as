package sszt.furnace.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class FuranceEvent extends Event
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
		
		public static var CELL_MATERIAL_UPDATE:String = "cellMaterialUpdate";
		public static var CELL_MATERIAL_ADD:String = "cellMaterialAdd";
		public static var CELL_MATERIAL_DELETE:String = "cellMaterialDelete";
		public static var CELL_MATERIAL_CLEAR:String = "cellMaterialClear";
		
		public static var CELL_QUICKBUY_INITIAL:String = "cellQuickBuyInitial";
		
		public static var FURANCE_CELL_UPDATE:String = "furanceCellUpdate";
		
		public static var ITEMINFO_CELL_UPDATE:String = "itemInfoCellUpdate";
		
		public static var CELL_EQUIP_UPDATE:String = "cellEquipUpdate";
		
		public static var CELL_REPLACE_REBUILD:String = "cellReplaceRebuild";
		
		// 特效触发
		public static var STRENGTH_SUCCESS:String = "strengthSuccess";
		public static var UPGRADE_SUCCESS:String = "upgradeSuccess";
		public static var UPLEVEL_SUCCESS:String = "uplevelSuccess";
		public static var REBUILD_SUCCESS:String = "rebuildSuccess";
		public static var COMPOSE_SUCCESS:String = "composeSuccess";
		public static var QUENCHING_SUCCESS:String = "quenchingSuccess";
		public static var ENCHASE_SUCCESS:String = "enchaseSuccess";
		public static var REMOVE_SUCCESS:String = "removeSuccess";
		public static var TRANSFORM_SUCCESS:String = "transformSuccess";
		public static var FUSE_SUCCESS:String = "transformSuccess";
		
		public function FuranceEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data =obj;
			super(type, bubbles, cancelable);
		}
	}
}