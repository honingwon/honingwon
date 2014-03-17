package sszt.mail.command
{
	import sszt.mail.mediator.MailMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class MailEndCommand extends SimpleCommand
	{
		public function MailEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(MailMediator.NAME);
		}
	}
}