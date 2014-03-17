package sszt.exStore.command
{
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.exStore.ExStoreModule;
	import sszt.exStore.mediator.ExStoreMediator;

	public class StoreStartCommand extends SimpleCommand
	{
		public function StoreStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var storeModule:ExStoreModule =notification.getBody() as ExStoreModule
			facade.registerMediator(new ExStoreMediator(storeModule));
		}
		
	}
}