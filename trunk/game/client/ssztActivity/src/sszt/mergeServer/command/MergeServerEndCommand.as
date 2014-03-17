package sszt.mergeServer.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.mergeServer.mediator.MergeServerMediator;
	
	public class MergeServerEndCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(MergeServerMediator.NAME);
		}
	}
}