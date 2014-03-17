package sszt.task.commands
{
	import sszt.task.TaskModule;
	import sszt.task.mediators.TaskMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class TaskStartCommand extends SimpleCommand
	{
		public function TaskStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:TaskModule = notification.getBody() as TaskModule;
			facade.registerMediator(new TaskMediator(module));
		}
	}
}