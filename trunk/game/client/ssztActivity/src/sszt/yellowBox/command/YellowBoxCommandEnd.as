package sszt.yellowBox.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.yellowBox.mediator.YellowBoxMediator;
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class YellowBoxCommandEnd extends SimpleCommand
	{
		public function YellowBoxCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(YellowBoxMediator.NAME);
		}
	}
}