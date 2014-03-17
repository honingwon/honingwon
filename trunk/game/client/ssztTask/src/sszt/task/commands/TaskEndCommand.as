package sszt.task.commands
{
	import sszt.task.mediators.TaskMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class TaskEndCommand extends SimpleCommand
	{
		public function TaskEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(TaskMediator.NAME);
		}
	}
}