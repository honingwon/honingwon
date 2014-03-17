package sszt.midAutumnActivity.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.midAutumnActivity.MidAutumnActivityModule;
	import sszt.midAutumnActivity.mediator.MidAutumnActivityMediator;
	
	public class MidAutumnActivityStartCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{ 
			var module:MidAutumnActivityModule =notification.getBody() as MidAutumnActivityModule;
			facade.registerMediator(new MidAutumnActivityMediator(module));
		}
	}
}