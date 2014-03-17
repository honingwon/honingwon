package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneCopyIslandUpdateEvent extends Event
	{
		public static const COPY_ISLAND_BEFORE_INIT:String = "copyIslandBeforeInit";
		public static const COPY_ISLAND_BEFORE_ITEMUPDATE:String = "copyIslandBeforeItemUpdate";
		/**可以进入副本**/
		public static const COPY_ISLAND_BEFORE_CANENTER:String = "copyIslandBeforeCanEnter";
		
		public static const COPY_ISLAND_MAININFO_UPDATE:String = "copyIslandMainInfoUpdate";
		public static const COPY_ISLAND_LEFTTIME_UPDATE:String = "copyIslandLeftTimeUpdate";
		
		public static const COPY_ISLAND_KINGTIME_UPDATE:String = "copyIslandKingTimeUpdate";
		public static const COPY_ISLAND_MONSTERCOUNT:String = "copyIslandMonsterCount";
		
//		public static const COPY_ISLAND_CONDITION_UPDATE:String = "copyIslandConditionUpdate";
//		public static const COPY_ISLAND_REWARDS_UPDATE:String = "copyIslandRewardsUpdate";
		public var data:Object;
		public function SceneCopyIslandUpdateEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}