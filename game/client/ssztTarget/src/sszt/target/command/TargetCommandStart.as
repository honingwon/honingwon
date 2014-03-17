package sszt.target.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.target.TargetModule;
	import sszt.target.mediator.TargetMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class TargetCommandStart extends SimpleCommand
	{
		public function TargetCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:TargetModule = notification.getBody() as TargetModule;
			facade.registerMediator(new TargetMediator(tempModule));
		}
	}
}