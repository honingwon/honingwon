package sszt.core.data.task
{
	import flash.events.Event;
	
	public class TaskItemInfoUpdateEvent extends Event
	{
		public static const TASKINFO_UPDATE:String = "taskInfoUpdate";
		
		public static const TASK_ENTRUST_UPDATE:String = "taskEntrustUpdate";
		
		public var data:Object;
		
		public function TaskItemInfoUpdateEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}