package sszt.stall.command
{
	import sszt.stall.StallModule;
	import sszt.stall.mediator.StallMediator;
	import sszt.stall.proxy.StallProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class StallCommandStart extends SimpleCommand
	{
		public function StallCommandStart()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var stallModule:StallModule = notification.getBody() as StallModule;
			facade.registerMediator(new StallMediator(stallModule));
			facade.registerProxy(new StallProxy());
		}
	}
}