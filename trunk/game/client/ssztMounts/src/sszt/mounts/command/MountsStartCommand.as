package sszt.mounts.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.mounts.MountsModule;
	import sszt.mounts.mediator.MountsMediator;
	
	public class MountsStartCommand extends SimpleCommand
	{
		public function MountsStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:MountsModule = notification.getBody() as MountsModule;
			facade.registerMediator(new MountsMediator(module));
		}
	}
}