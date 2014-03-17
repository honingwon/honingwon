package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneShenMoWarUpdateEvent extends Event
	{
		/**荣誉面板战场列表更新**/
		public static const SHENMO_HONOR_LIST_UPDATE:String = "shenMoHonorListUpdate";
		/**荣誉信息更新**/
		public static const SHENMO_HONOR_INFO_UPDATE:String = "shenMoHonorInfoUpdate";
		/**我的战报信息更新**/
		public static const SHENMO_MYWAR_INFO_UPDATE:String = "shenMoMyWarInfoUpdate";
		/**人员列表初始化**/
		public static const SHENMO_MEMBERS_LIST_INIT:String = "shenMoMembersListInit";
		/**增加成员数据**/
//		public static const SHENMO_MEMBERS_LIST_ADD:String = "shenMoMembersListAdd";
		/**删除成员数据**/
//		public static const SHENMO_MEMBERS_LIST_REMOVE:String = "shenMoMembersListRemove";
		/**成员列表更新**/
		public static const SHENMO_MENBERS_LIST_UPDATE:String = "shenMoMembersListUpdate";
		/**乱斗结果更新**/
		public static const SHENMO_RESULT_UPDATE:String = "shenMoResultUpdate";
		/**是否发送了领取奖励**/
		public static const SHENMO_SEND_GET_AWARD:String = "shenMoSendGetAward";
		
		public var data:Object;
		
		public function SceneShenMoWarUpdateEvent(type:String,obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}