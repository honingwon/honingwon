package sszt.openActivity.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.openActivity.mediator.OpenActivityMediator;
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class OpenActivityCommandEnd extends SimpleCommand
	{
		public function OpenActivityCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(OpenActivityMediator.NAME);
		}
	}
}