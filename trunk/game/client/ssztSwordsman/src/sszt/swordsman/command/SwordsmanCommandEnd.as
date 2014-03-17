package sszt.swordsman.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.swordsman.mediator.SwordsmanMediator;
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class SwordsmanCommandEnd extends SimpleCommand
	{
		public function SwordsmanCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(SwordsmanMediator.NAME);
		}
	}
}