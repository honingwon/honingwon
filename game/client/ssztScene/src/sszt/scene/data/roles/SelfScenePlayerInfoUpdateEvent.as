package sszt.scene.data.roles
{
	import flash.events.Event;
	
	public class SelfScenePlayerInfoUpdateEvent extends Event
	{
//		/**
//		 * 玩家状态改变，主要用于挂机
//		 */		
//		public static const ATTACKSTATE_UPDATE:String = "attackStateUpdate";
//		/**
//		 * 挂机攻击状态更新
//		 */		
//		public static const HANGUPSTATE_UPDATE:String = "hangupStateUpdate";
		/**
		 * 攻击返回
		 */		
		public static const ATTACKBACK:String = "attackBack";
		/**
		 * 采集更新
		 */		
		public static const COLLECT_UPDATE:String = "collectUpdate";
		/**
		 * 停止采集 
		 */		
		public static const STOP_COLLECT:String = "stopCollect";
//		/**
//		 * 自动寻路中
//		 */		
//		public static const AUTO_WALK:String = "autoWalk";
		
		public var data:Object;
		
		public function SelfScenePlayerInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}