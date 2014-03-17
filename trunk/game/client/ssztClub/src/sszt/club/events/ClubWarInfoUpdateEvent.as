package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubWarInfoUpdateEvent extends Event
	{
		public static const WAR_DECLEAR_INFO_INIT:String = "warDeclearInfoInit";
		
		public static const WAR_DEAL_INFO_INIT:String = "warDealInfoInit";
		
		public static const WAR_DEAL_INFO_DELETE:String = "warDealInfoDelete";
		
		public static const WAR_ENEMY_INFO_INIT:String = "warEnemyInfoInit";
		
		public static const WAR_ENEMY_INFO_DELETE:String = "warEnemyInfoDelete";
		
//		public static const WAR_DECLEAR_ITEM_INFO_UPDATE:String = "warDeclearItemInfoUpdate";
		
		public var data:Object;
		
		public function ClubWarInfoUpdateEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}