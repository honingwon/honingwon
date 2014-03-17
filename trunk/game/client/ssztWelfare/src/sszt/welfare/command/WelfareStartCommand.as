package sszt.welfare.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.welfare.WelfareModule;
	import sszt.welfare.mediator.WelfareMediator;
	
	public class WelfareStartCommand extends SimpleCommand
	{
		public function WelfareStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var welfareModule:WelfareModule =notification.getBody() as WelfareModule;
			facade.registerMediator(new WelfareMediator(welfareModule));
		}
	}
}