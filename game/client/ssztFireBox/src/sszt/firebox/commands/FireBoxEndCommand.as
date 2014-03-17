package sszt.firebox.commands
{
	import sszt.firebox.mediators.FireBoxMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FireBoxEndCommand extends SimpleCommand
	{
		public function FireBoxEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(FireBoxMediator.NAME);
		}
	}
}