package sszt.challenge.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.challenge.ChallengeModule;
	import sszt.challenge.mediator.ChallengeMediator;
	
	/**
	 * 开始指令 
	 * @author chendong
	 */	
	public class ChallengeCommandStart extends SimpleCommand
	{
		public function ChallengeCommandStart()
		{
			//TODO: implement function
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			var tempModule:ChallengeModule = notification.getBody() as ChallengeModule;
			facade.registerMediator(new ChallengeMediator(tempModule));
		}
	}
}