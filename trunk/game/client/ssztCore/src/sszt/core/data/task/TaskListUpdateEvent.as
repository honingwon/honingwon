package sszt.core.data.task
{
	import flash.events.Event;
	
	public class TaskListUpdateEvent extends Event
	{
		public static const ADD_TASK:String = "addTask";
		public static const REMOVE_TASK:String = "removeTask";
		
		/**
		 * 第一次取数
		 */		
		public static const FIRST_GETDATA:String = "firstGetdata";
		
		public var data:Object;
		
		public function TaskListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}