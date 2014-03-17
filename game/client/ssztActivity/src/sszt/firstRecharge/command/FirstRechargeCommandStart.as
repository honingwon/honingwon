package sszt.firstRecharge.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.firstRecharge.FirstRechargeModule;
	import sszt.firstRecharge.mediator.FirstRechargeMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class FirstRechargeCommandStart extends SimpleCommand
	{
		public function FirstRechargeCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:FirstRechargeModule = notification.getBody() as FirstRechargeModule;
			facade.registerMediator(new FirstRechargeMediator(tempModule));
		}
	}
}