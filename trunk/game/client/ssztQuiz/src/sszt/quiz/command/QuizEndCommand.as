package sszt.quiz.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.quiz.mediator.QuizMediator;
	
	public class QuizEndCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(QuizMediator.NAME);
		}
	}
}