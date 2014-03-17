package sszt.consign.command
{
	import sszt.consign.ConsignModule;
	import sszt.consign.mediator.ConsignMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ConsignCommandStart extends SimpleCommand
	{
		public function ConsignCommandStart()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var consignModule:ConsignModule = notification.getBody() as ConsignModule;
			facade.registerMediator(new ConsignMediator(consignModule));
		}
	}
}