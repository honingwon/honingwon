package sszt.events
{
	import sszt.events.ModuleEvent;
	
	public class ActivityEvent extends ModuleEvent
	{
		/**
		 * 选择活动分类按钮 
		 */		
		public static const SELECT_ACT_TYPE_BTN:String = "selectActivityTypeBtn";
		
		/**
		 * 获得开服相关活动数据
		 */		
		public static const GET_OPEN_SERVER_DATA:String = "getOpenServerData";
		
		/**
		 * 领取活动奖励
		 */		
		public static const GET_AWARD:String = "getAward";
		
		
		/**
		 * 获得用户数据
		 */		
		public static const SEVEN_ACTIVITY_INFO:String = "sevenActivityInfo";
		
		/**
		 * 获得奖励
		 */		
		public static const SEVEN_ACTIVITY_GET_RED:String = "sevenActivityGetReward";
		
		public function ActivityEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}