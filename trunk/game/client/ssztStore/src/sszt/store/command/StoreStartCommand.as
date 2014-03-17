package sszt.store.command
{
	import sszt.store.StoreModule;
	import sszt.store.mediator.StoreMediator;
	
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
			var storeModule:StoreModule =notification.getBody() as StoreModule
			facade.registerMediator(new StoreMediator(storeModule));
		}
		
	}
}