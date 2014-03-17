package sszt.personal.commands
{
	import sszt.personal.mediators.PersonalMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PersonalEndCommand extends SimpleCommand
	{
		public function PersonalEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(PersonalMediator.NAME);
		}
	}
}