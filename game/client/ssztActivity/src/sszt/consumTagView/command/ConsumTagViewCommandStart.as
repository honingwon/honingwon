package sszt.consumTagView.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.consumTagView.ConsumTagViewModule;
	import sszt.consumTagView.mediator.ConsumTagViewMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class ConsumTagViewCommandStart extends SimpleCommand
	{
		public function ConsumTagViewCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:ConsumTagViewModule = notification.getBody() as ConsumTagViewModule;
			facade.registerMediator(new ConsumTagViewMediator(tempModule));
		}
	}
}