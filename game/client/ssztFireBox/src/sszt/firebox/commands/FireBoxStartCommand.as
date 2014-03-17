package sszt.firebox.commands
{
	import sszt.firebox.FireBoxModule;
	import sszt.firebox.mediators.FireBoxMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FireBoxStartCommand extends SimpleCommand
	{
		public function FireBoxStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:FireBoxModule = notification.getBody() as FireBoxModule;
			facade.registerMediator(new FireBoxMediator(module));
		}
	}
}