package sszt.events
{
	import flash.events.Event;
	
	
	public class TargetMediaEvents extends ModuleEvent
	{
		public static const TARGET_COMMAND_START:String = "targetCommandStart";
		public static const TARGET_COMMADN_END:String = "targetCommandEnd";
		
		public static const TARGET_MEDIATOR_START:String = "targetMediatorStart";
		public static const TARGET_MEDIATOR_DISPOSE:String = "targetMediatorDispose";
		
		/**
		 * 选择目标类型 
		 */		
		public static const CLICK_TARGET_TYPE:String = "clickTargetType";
		
		/**
		 * 选择目标 
		 */		
		public static const CLICK_TARGET:String = "clickTarget";
		
		/**
		 * 更新目标列表数据 
		 */		
		public static const UPDATE_TARGET_LIST:String = "updateTargetList";
		
		/**
		 * 获得目标奖励
		 */		
		public static const GET_TARGET_AWARD:String = "getTargetAward";
		
		/**
		 * 完成成就
		 */		
		public static const FINISH_TARGET:String = "finishTarget";
		
		/**
		 * 成就历史记录
		 */		
		public static const TARGET_HISTORY:String = "targetHistory";
		
		/**
		 * 一定时间内，清楚完成成就面板
		 */		
		public static const CLEAR_FINISH_TARGET:String = "clearFinishTarget";
		
		
		
		public function TargetMediaEvents(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,obj, bubbles, cancelable);
		}
	}
}