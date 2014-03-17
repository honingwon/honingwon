package sszt.marriage.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.marriage.MarriageModule;
	import sszt.marriage.mediator.MarriageManageMediator;
	import sszt.marriage.mediator.MarriageMediator;
	
	public class MarriageStartCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{ 
			var module:MarriageModule =notification.getBody() as MarriageModule;
			facade.registerMediator(new MarriageMediator(module));
			facade.registerMediator(new MarriageManageMediator(module));
		}
	}
}