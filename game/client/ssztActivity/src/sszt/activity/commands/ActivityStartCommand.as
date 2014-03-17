package sszt.activity.commands
{
	import sszt.activity.ActivityModule;
	import sszt.activity.mediators.ActivityMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActivityStartCommand extends SimpleCommand
	{
		public function ActivityStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:ActivityModule = notification.getBody() as ActivityModule;
			facade.registerMediator(new ActivityMediator(module));
		}
	}
}