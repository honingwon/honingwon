package sszt.quiz
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.quiz.command.QuizEndCommand;
	import sszt.quiz.command.QuizStartCommand;
	import sszt.quiz.event.QuizMediatorEvent;
	
	public class QuizFacade extends Facade
	{
		public static function getInstance(key:String):QuizFacade
		{
			if(!(instanceMap[key] is QuizFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new QuizFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		
		public function QuizFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(QuizMediatorEvent.QUIZ_COMMAND_START,QuizStartCommand);
			registerCommand(QuizMediatorEvent.QUIZ_COMMAND_END,QuizEndCommand);
		}
		
		public function startup(module:QuizModule,data:Object):void
		{
			sendNotification(QuizMediatorEvent.QUIZ_COMMAND_START,module);
//			sendNotification(QuizMediatorEvent.QUIZ_START,data);
		}
		
		public function dispose():void
		{
			sendNotification(QuizMediatorEvent.QUIZ_DISPOSE);
			sendNotification(QuizMediatorEvent.QUIZ_COMMAND_END);
			removeCommand(QuizMediatorEvent.QUIZ_COMMAND_END);
			removeCommand(QuizMediatorEvent.QUIZ_COMMAND_START);
			instanceMap[_key] = null;
		}
	}
}