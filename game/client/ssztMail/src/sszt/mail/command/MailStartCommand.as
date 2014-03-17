package sszt.mail.command
{
	import sszt.mail.MailModule;
	import sszt.mail.mediator.MailMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class MailStartCommand extends SimpleCommand
	{
		public function MailStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:MailModule = notification.getBody() as MailModule;
			facade.registerMediator(new MailMediator(module));
		}
	}
}