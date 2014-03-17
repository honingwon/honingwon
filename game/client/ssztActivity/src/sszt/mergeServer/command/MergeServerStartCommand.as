package sszt.mergeServer.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.mergeServer.MergeServerModule;
	import sszt.mergeServer.mediator.MergeServerMediator;
	
	public class MergeServerStartCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{ 
			var module:MergeServerModule =notification.getBody() as MergeServerModule;
			facade.registerMediator(new MergeServerMediator(module));
		}
	}
}