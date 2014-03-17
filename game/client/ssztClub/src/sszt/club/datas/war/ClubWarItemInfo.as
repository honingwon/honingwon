package sszt.club.datas.war
{
	import flash.events.EventDispatcher;
	
	import sszt.club.events.ClubWarInfoUpdateEvent;

	public class ClubWarItemInfo extends EventDispatcher
	{
		public var clubListId:Number;
		public var clubName:String;
		public var masterName:String;
		public var level:int;
		public var clubTotalNum:int;
		public var clubCurrentNum:int;
		public var warState:int;
		public function ClubWarItemInfo()
		{
		}
		
//		public function updateState(argState:int):void
//		{
//			warState = argState;
//			dispatchEvent(new ClubWarInfoUpdateEvent(ClubWarInfoUpdateEvent.WAR_DECLEAR_ITEM_INFO_UPDATE));
//		}
	}
}