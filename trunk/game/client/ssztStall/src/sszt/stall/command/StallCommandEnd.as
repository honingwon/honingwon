package sszt.stall.command
{
	import sszt.stall.mediator.StallMediator;
	import sszt.stall.proxy.StallProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class StallCommandEnd extends SimpleCommand
	{
		public function StallCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(StallMediator.NAME);
			facade.removeProxy(StallProxy.NAME);
		}
	}
}