package sszt.consign.command
{
	import sszt.consign.mediator.ConsignMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ConsignCommandEnd extends SimpleCommand
	{
		public function ConsignCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(ConsignMediator.NAME);
		}
	}
}