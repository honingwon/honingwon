package sszt.pvp.commands
{
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.pvp.PVPModule;
	import sszt.pvp.mediators.PVPMediator;
	
	public class PVPStartCommand extends SimpleCommand
	{
		public function PVPStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:PVPModule = notification.getBody() as PVPModule;
			facade.registerMediator(new PVPMediator(module));
		}
	}
}