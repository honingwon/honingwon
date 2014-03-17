package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubStoreUpdateEvent extends Event
	{
		public static const ITEM_UPDATE:String = "itemUpdate";
		
		public static const EVENTLIST_UPDATE:String = "eventListUpdate";
		
		public static const APPLIED_ITEM_RECORDS_UPDATE:String = "appliedItemRecordsUpdate";
		
		public static const EXAMINE_AND_VERIFY_UPDATE:String = "examineAndVerifyUpdate";
		
		
		public var data:Object;
		
		public function ClubStoreUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}