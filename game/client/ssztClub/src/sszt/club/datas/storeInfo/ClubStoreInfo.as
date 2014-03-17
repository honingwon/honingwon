package sszt.club.datas.storeInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.club.events.ClubStoreUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	
	public class ClubStoreInfo extends EventDispatcher
	{
//		public var storeList:Vector.<ItemInfo>;
//		public var storeEventList:Vector.<StoreEventItemInfo>;
		public var storeList:Array;
		public var storeEventList:Array;
		public var appliedItemRecords:Array;
		public var appliedItemRecordsTotal:int;
		public var examineAndVerify:Array;
		public var examineAndVerifyTotal:int;
		
		private const MAX_SIZE:int = 50*3;
		private const PAGE_SIZE:int = 50;		
		private const APPLIED_ITEM_RECORDS_PAGE_SIZE:int = 5;
		
		public function ClubStoreInfo()
		{
//			storeList = new Vector.<ItemInfo>(PAGE_SIZE);
			storeList = new Array(PAGE_SIZE);
			appliedItemRecords = new Array(APPLIED_ITEM_RECORDS_PAGE_SIZE);
			examineAndVerify = new Array(APPLIED_ITEM_RECORDS_PAGE_SIZE);
			super();
		}
		
		public function updateAppliedItemRecords(total:int, list:Array):void
		{
			appliedItemRecordsTotal = total;
			appliedItemRecords = list;
			dispatchEvent(new ClubStoreUpdateEvent(ClubStoreUpdateEvent.APPLIED_ITEM_RECORDS_UPDATE));
		}
		
		public function updateExamineAndVerify(total:int, list:Array):void
		{
			examineAndVerifyTotal = total;
			examineAndVerify = list;
			dispatchEvent(new ClubStoreUpdateEvent(ClubStoreUpdateEvent.EXAMINE_AND_VERIFY_UPDATE));
		}
		
//		public function updateEventList(list:Vector.<StoreEventItemInfo>):void
		public function updateEventList(list:Array):void
		{
			storeEventList = list;
			dispatchEvent(new ClubStoreUpdateEvent(ClubStoreUpdateEvent.EVENTLIST_UPDATE));
		}
		
		public function addItem(item:ItemInfo):void
		{
			for(var i:int = 0; i < storeList.length; i++)
			{
				if(storeList[i] == null)
				{
					storeList[i] = item;
					dispatchEvent(new ClubStoreUpdateEvent(ClubStoreUpdateEvent.ITEM_UPDATE));
					break;
				}
			}
		}
		
		public function removeItem(item:ItemInfo):void
		{
			if(storeList.indexOf(item) != -1)
			{
				storeList[storeList.indexOf(item)] = null;
				dispatchEvent(new ClubStoreUpdateEvent(ClubStoreUpdateEvent.ITEM_UPDATE));
			}
		}
		
//		public function updateItems(list:Vector.<ItemInfo>):void
		public function updateItems(list:Array):void
		{
			storeList = list;
			dispatchEvent(new ClubStoreUpdateEvent(ClubStoreUpdateEvent.ITEM_UPDATE));
		}
		
		public function dispose():void
		{
			storeList = null;
		}
	}
}