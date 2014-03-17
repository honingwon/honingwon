package sszt.exStore.command
{
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.exStore.mediator.ExStoreMediator;

	public class StoreEndCommand extends SimpleCommand
	{
		public function StoreEndCommand()
		{
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(ExStoreMediator.NAME);
		}
	}
}