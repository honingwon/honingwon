package sszt.sevenActivity.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.sevenActivity.SevenActivityModule;
	import sszt.sevenActivity.mediator.SevenActivityMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class SevenActivityCommandStart extends SimpleCommand
	{
		public function SevenActivityCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:SevenActivityModule = notification.getBody() as SevenActivityModule;
			facade.registerMediator(new SevenActivityMediator(tempModule));
		}
	}
}