package sszt.events
{
	public class ActiveStartEvents extends ModuleEvent
	{
		/**
		 * 活动开始时间更新 
		 */		
		public static const ACTIVE_START_UPDATE:String = "activeStartUpdate";
		
		public static const ACTIVE_FINISH:String = "activeFinish";
		
		public function ActiveStartEvents(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}