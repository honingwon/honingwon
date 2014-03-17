package sszt.target.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.target.mediator.TargetMediator;
	
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class TargetCommandEnd extends SimpleCommand
	{
		public function TargetCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(TargetMediator.NAME);
		}
	}
}