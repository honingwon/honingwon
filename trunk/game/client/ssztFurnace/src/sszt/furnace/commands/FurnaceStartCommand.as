package sszt.furnace.commands
{
	import sszt.furnace.FurnaceModule;
	import sszt.furnace.mediators.FurnaceMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FurnaceStartCommand extends SimpleCommand
	{
		public function FurnaceStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:FurnaceModule = notification.getBody() as FurnaceModule;
			facade.registerMediator(new FurnaceMediator(module));
		}
	}
}