package sszt.marriage.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.marriage.mediator.MarriageManageMediator;
	import sszt.marriage.mediator.MarriageMediator;
	
	public class MarriageEndCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(MarriageMediator.NAME);
			facade.removeMediator(MarriageManageMediator.NAME);
		}
	}
}