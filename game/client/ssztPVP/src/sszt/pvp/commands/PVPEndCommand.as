package sszt.pvp.commands
{
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.pvp.mediators.PVPMediator;
	
	public class PVPEndCommand extends SimpleCommand
	{
		public function PVPEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(PVPMediator.NAME);
		}
	}
}