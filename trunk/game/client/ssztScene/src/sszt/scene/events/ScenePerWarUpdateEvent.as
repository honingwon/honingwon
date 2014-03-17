package sszt.scene.events
{
	import flash.events.Event;
	
	public class ScenePerWarUpdateEvent extends Event
	{
		/**个人乱斗主面板信息更新**/
		public static const PERWAR_MAINLIST_UPDATE:String = "perWarMainListUpdate";
		/**我的战报信息更新**/
		public static const PERWAR_MYWAR_INFO_UPDATE:String = "perWarMyWarInfoUpdate";
		/**人员列表初始化**/
		public static const PERWAR_MEMBERS_LIST_INIT:String = "perWarMembersListInit";
		/**成员列表更新**/
		public static const PERWAR_MENBERS_LIST_UPDATE:String = "perWarMembersListUpdate";
		/**个人乱斗结果更新**/
		public static const PERWAR_RESULT_UPDATE:String = "perWarResultUpdate";
		/**发送获取奖励更新**/
		public static const PERWAR_SEND_GET_AWARD:String = "perWarSendGetAward";
		
		public var data:Object;
		
		public function ScenePerWarUpdateEvent(type:String,obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}