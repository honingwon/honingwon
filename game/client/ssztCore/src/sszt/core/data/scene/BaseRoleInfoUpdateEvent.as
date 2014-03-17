package sszt.core.data.scene
{
	import flash.events.Event;
	
	public class BaseRoleInfoUpdateEvent extends Event
	{
//		public static const ROLESTATE_UPDATE:String = "roleStateUpdate";
		
		public static const ADDACTION:String = "addAction";
		
		public static const ADDBUFF:String = "addBuff";
		public static const UPDATEBUFF:String = "updateBuff";
		public static const REMOVEBUFF:String = "removeBuff";
		
		public static const INFO_UPDATE:String = "infoUpdate";
		
		public static const TOTALHP_UPDATE:String = "totalHpUpdate";
		public static const TOTALMP_UPDATE:String = "totalMpUpdate";
		
		/**
		 * 升级
		 */		
		public static const UPGRADE:String = "upgrade";
		/**
		 * 运镖剩余时间更新
		 */		
		public static const INDARTS_UPDATE:String = "indartsUpdate";
		/**
		 * 运镖状态更新
		 */		
		public static const TRANSPORT_UPDATE:String = "transportUpdate";
		
		
		/**********走路事件**************************/
		public static const DIR_UPDATE:String = "dirUpdate";
		public static const DO_WALK_ACTION:String = "doWalkAction";
		public static const WALK_COMPLETE:String = "walkComplete";
		
		public var data:Object;
		
		
		public function BaseRoleInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}