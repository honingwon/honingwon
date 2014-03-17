package sszt.task
{
	import sszt.task.commands.TaskEndCommand;
	import sszt.task.commands.TaskStartCommand;
	import sszt.task.events.TaskMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class TaskFacade extends Facade
	{
		public static function getInstance(key:String):TaskFacade
		{
			if(!(instanceMap[key] is TaskFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new TaskFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var taskModule:TaskModule;
		
		public function TaskFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(TaskMediatorEvent.TASK_COMMAND_START,TaskStartCommand);
			registerCommand(TaskMediatorEvent.TASK_COMMAND_END,TaskEndCommand);
		}
		
		public function startup(module:TaskModule):void
		{
			taskModule = module;
			sendNotification(TaskMediatorEvent.TASK_COMMAND_START,taskModule);
			sendNotification(TaskMediatorEvent.TASK_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(TaskMediatorEvent.TASK_MEDIATOR_DISPOSE);
			sendNotification(TaskMediatorEvent.TASK_COMMAND_END);
			removeCommand(TaskMediatorEvent.TASK_COMMAND_START);
			removeCommand(TaskMediatorEvent.TASK_COMMAND_END);
			delete instanceMap[_key];
			taskModule = null;
		}
	}
}