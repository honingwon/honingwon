package sszt.activity.events
{
	import flash.events.Event;
	
	public class ActivityInfoEvents extends Event
	{
		/**
		 * 活跃度奖励领取状态信息更新
		 */
		public static const ACTIVE_REWARDS_STATE_UPDATE:String = "activeRewardsStateUpdate";
		
		/**
		 * 活跃度信息更新
		 */
		public static const ACTIVE_DATA_UPDATE:String = "activeDataUpdate";
		
		/**
		 * 活跃度奖励领取成功
		 */
		public static const GET_REWARDS_SUCCESS:String = "getRewardsSucess";
		
		public static const UPDATE_BOSS_INFO:String = "updateBOssInfo";
		
		
		
		public static const ACTIVE_ITEM_UPDATE:String = "activeItemUpdate";
		public static const ACTIVE_ITEMLIST_INITIAL:String = "activeItemListInitial";
		public static const ACTIVE_ITEMLIST_CLEAR:String = "activeItemListClear";
		public static const WELFSTATECHANGE:String = "welfStateChange";
		public static const LUCKSTATECHANGE:String = "luckStateChange";
		public static const CHANGE_STATE:String = "stateChange";
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public var data:Object;
		
		public function ActivityInfoEvents(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}