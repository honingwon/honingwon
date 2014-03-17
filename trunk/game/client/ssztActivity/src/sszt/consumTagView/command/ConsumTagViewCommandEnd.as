package sszt.consumTagView.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.consumTagView.mediator.ConsumTagViewMediator;
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class ConsumTagViewCommandEnd extends SimpleCommand
	{
		public function ConsumTagViewCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(ConsumTagViewMediator.NAME);
		}
	}
}