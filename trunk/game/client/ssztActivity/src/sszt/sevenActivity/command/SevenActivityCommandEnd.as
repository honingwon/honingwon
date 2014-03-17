package sszt.sevenActivity.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.sevenActivity.mediator.SevenActivityMediator;
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class SevenActivityCommandEnd extends SimpleCommand
	{
		public function SevenActivityCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(SevenActivityMediator.NAME);
		}
	}
}