package sszt.swordsman.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.swordsman.SwordsmanModule;
	import sszt.swordsman.mediator.SwordsmanMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class SwordsmanCommandStart extends SimpleCommand
	{
		public function SwordsmanCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:SwordsmanModule = notification.getBody() as SwordsmanModule;
			facade.registerMediator(new SwordsmanMediator(tempModule));
		}
	}
}