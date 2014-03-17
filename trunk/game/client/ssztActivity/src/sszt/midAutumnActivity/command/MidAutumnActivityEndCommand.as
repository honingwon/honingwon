package sszt.midAutumnActivity.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.midAutumnActivity.mediator.MidAutumnActivityMediator;
	
	public class MidAutumnActivityEndCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(MidAutumnActivityMediator.NAME);
		}
	}
}