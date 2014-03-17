package sszt.mounts.command
{
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.mounts.mediator.MountsMediator;
	
	public class MountsEndCommand extends SimpleCommand
	{
		public function MountsEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(MountsMediator.NAME);
		}
	}
}