package sszt.activity.commands
{
	import sszt.activity.mediators.ActivityMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActivityEndCommand extends SimpleCommand
	{
		public function ActivityEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(ActivityMediator.NAME);
		}
	}
}