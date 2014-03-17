package sszt.core.data.quiz
{
	import flash.utils.Dictionary;
	
	import sszt.events.QuizModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class QuizInfo
	{
		public var hasBegun:Boolean;
		public var totalExpAward:int = 0;
		public var totalBindYuanbao:int = 0;
		public var totalRight:int = 0;
		public var totalWrong:int = 0;
		
		/**
		 * 最新的一道题目
		 * */
		public var lastQuestion:QuizQuestion;
		public var questions:Dictionary = new Dictionary();
		public var questionsResult:Dictionary = new Dictionary();
		
		public function addQuestionItem(quizQuestion:QuizQuestion):void
		{
			questions[quizQuestion.index] = quizQuestion;
			ModuleEventDispatcher.dispatchQuizEvent(new QuizModuleEvent(QuizModuleEvent.QUIZ_PUSH));
		}
		
		public function addQuestionResultItem(result:QuizQuestionResult):void
		{
			questionsResult[result.index] = result;
			ModuleEventDispatcher.dispatchQuizEvent(new QuizModuleEvent(QuizModuleEvent.QUIZ_RESULT, result));
		}
	}
}