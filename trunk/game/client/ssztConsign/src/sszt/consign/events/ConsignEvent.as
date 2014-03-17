package sszt.consign.events
{
	import flash.events.Event;
	
	public class ConsignEvent extends Event
	{
		public static const DELETE:String = "delete";
		public static const ADD_GOLD_ITEM:String = "addGoldItem";
		public static const REMOVE_GOILD_ITEM:String = "removeGoldItem";
		public static const GOLD_ITEM_UPDATE:String = "goldItemUpdate";
		public static const SEARCHLIST_UPDATE:String = "searchListUpdate";
		public static const MYLIST_UPDATE:String = "myListUpdate";	
		public static const PAGE_UPDATE:String = "pageUpdate";
		public static const QUICKCONSIGN_INDEX_CHANGE:String = "quickConsignIndexChange";
		
		public static const MYCONSIGN_PAGE_UPDATE:String = "myConsignPageUpdate";
		
		public static const INFO_PLACE_UPDATE:String = "infoPlaceUpdate";
		
		public var data:Object;
		
		public function ConsignEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}