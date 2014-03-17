package sszt.challenge.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.challenge.mediator.ChallengeMediator;
	
	
	
	/**
	 * 结束指令 
	 * @author chendong
	 * 
	 */	
	public class ChallengeCommandEnd extends SimpleCommand
	{
		public function ChallengeCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			facade.removeMediator(ChallengeMediator.NAME);
		}
	}
}