package sszt.duplicateStore.command
{
	import sszt.duplicateStore.DuplicateStoreModule;
	import sszt.duplicateStore.mediator.StoreMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class StoreStartCommand extends SimpleCommand
	{
		public function StoreStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var storeModule:DuplicateStoreModule =notification.getBody() as DuplicateStoreModule
			facade.registerMediator(new StoreMediator(storeModule));
		}
		
	}
}