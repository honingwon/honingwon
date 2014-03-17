package sszt.quiz.command
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.quiz.QuizModule;
	import sszt.quiz.mediator.QuizMediator;
	
	public class QuizStartCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{ 
			var module:QuizModule =notification.getBody() as QuizModule;
			facade.registerMediator(new QuizMediator(module));
		}
	}
}