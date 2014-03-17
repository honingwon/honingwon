package sszt.store.command
{
	import sszt.store.mediator.StoreMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class StoreEndCommand extends SimpleCommand
	{
		public function StoreEndCommand()
		{
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(StoreMediator.NAME);
		}
	}
}