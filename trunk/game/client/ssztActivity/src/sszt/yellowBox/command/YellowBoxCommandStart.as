package sszt.yellowBox.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.yellowBox.YellowBoxModule;
	import sszt.yellowBox.mediator.YellowBoxMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class YellowBoxCommandStart extends SimpleCommand
	{
		public function YellowBoxCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:YellowBoxModule = notification.getBody() as YellowBoxModule;
			facade.registerMediator(new YellowBoxMediator(tempModule));
		}
	}
}