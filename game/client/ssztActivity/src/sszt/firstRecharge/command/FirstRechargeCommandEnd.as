package sszt.firstRecharge.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.firstRecharge.mediator.FirstRechargeMediator;
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class FirstRechargeCommandEnd extends SimpleCommand
	{
		public function FirstRechargeCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(FirstRechargeMediator.NAME);
		}
	}
}