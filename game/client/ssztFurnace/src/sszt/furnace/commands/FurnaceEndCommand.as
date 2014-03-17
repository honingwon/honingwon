package sszt.furnace.commands
{
	import sszt.furnace.mediators.FurnaceMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FurnaceEndCommand extends SimpleCommand
	{
		public function FurnaceEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(FurnaceMediator.NAME);
		}
	}
}