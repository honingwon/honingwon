package sszt.welfare.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.welfare.mediator.WelfareMediator;
	
	public class WelfareEndCommand extends SimpleCommand
	{
		public function WelfareEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(WelfareMediator.NAME);
		}
		
		
	}
}