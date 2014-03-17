package sszt.payTagView.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.payTagView.mediator.PayTagViewMediator;
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class PayTagViewCommandEnd extends SimpleCommand
	{
		public function PayTagViewCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(PayTagViewMediator.NAME);
		}
	}
}