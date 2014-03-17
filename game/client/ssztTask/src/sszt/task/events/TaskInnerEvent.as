package sszt.task.events
{
	import flash.events.Event;
	
	public class TaskInnerEvent extends Event
	{
		public static const TASK_ENTRUST_INFOUPDATE:String = "taskEntrustInfoUpdate";
		
		public static const TASK_ENTRUST_REMOVE:String = "taskEntrustRemove";
		
		public static const TASK_FOLLOWITEM_UPDATE:String = "taskFollowItemUpdate";
		
		public static const TASK_FOLLOW_UPDATE:String = "taskFollowUpdate";
		
		public static const TASK_ENTRUSTFINISH_UPDATE:String = "taskEntrustFinishUpdate";
		
		public static const TASK_GROUP_UPDATE:String = "taskGroupUpdate";
		
		public var data:Object;
		
		public function TaskInnerEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}