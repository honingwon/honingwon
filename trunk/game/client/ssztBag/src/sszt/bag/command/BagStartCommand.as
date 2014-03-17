package sszt.bag.command
{
	import sszt.bag.BagModule;
	import sszt.bag.mediator.BagMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class BagStartCommand extends SimpleCommand
	{
		public function BagStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{ 
			var module:BagModule=notification.getBody() as BagModule;
			facade.registerMediator(new BagMediator(module));
		}
	}
}