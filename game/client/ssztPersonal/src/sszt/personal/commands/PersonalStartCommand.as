package sszt.personal.commands
{
	import sszt.personal.PersonalModule;
	import sszt.personal.mediators.PersonalMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PersonalStartCommand extends SimpleCommand
	{
		public function PersonalStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:PersonalModule = notification.getBody() as PersonalModule;
			facade.registerMediator(new PersonalMediator(module));
		}
	}
}