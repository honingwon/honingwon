package sszt.openActivity.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.openActivity.OpenActivityModule;
	import sszt.openActivity.mediator.OpenActivityMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class OpenActivityCommandStart extends SimpleCommand
	{
		public function OpenActivityCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:OpenActivityModule = notification.getBody() as OpenActivityModule;
			facade.registerMediator(new OpenActivityMediator(tempModule));
		}
	}
}