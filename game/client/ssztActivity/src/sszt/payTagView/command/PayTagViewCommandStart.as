package sszt.payTagView.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.payTagView.PayTagViewModule;
	import sszt.payTagView.mediator.PayTagViewMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class PayTagViewCommandStart extends SimpleCommand
	{
		public function PayTagViewCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:PayTagViewModule = notification.getBody() as PayTagViewModule;
			facade.registerMediator(new PayTagViewMediator(tempModule));
		}
	}
}