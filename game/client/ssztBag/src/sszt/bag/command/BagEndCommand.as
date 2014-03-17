package sszt.bag.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import sszt.bag.mediator.BagMediator;

	public class BagEndCommand extends SimpleCommand
	{
		public function BagEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(BagMediator.NAME);
		}
	}
}