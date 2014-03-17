package sszt.core.socketHandlers.quiz
{
	import flash.utils.getTimer;
	
	import sszt.constData.MapType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.data.quiz.QuizQuestion;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	
	public class QuizPushSocketHandler extends BaseSocketHandler
	{
		/**
		 * 答题活动问题推送
		 * */
		public function QuizPushSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.QUIZ_START;
		}
		
		override public function handlePackage():void
		{
			var quizQuestion:QuizQuestion = new QuizQuestion();
			quizQuestion.index = _data.readShort();
			quizQuestion.questionContent = _data.readUTF();
			var option:Array = _data.readUTF().split('|');
			quizQuestion.optionA = option[0];
			quizQuestion.optionB = option[1];
			quizQuestion.endingTime = (new Date()).getTime() + 10 * 1000;
			
			GlobalData.quizInfo.hasBegun = true;
			GlobalData.quizInfo.lastQuestion = quizQuestion;
			
			if(GlobalData.currentMapId == MapType.QUIZ)
			{
				SetModuleUtils.addQuiz(new ToQuizData(0));
			}
			
			GlobalData.quizInfo.addQuestionItem(quizQuestion);
			
			handComplete();
		}
	}
}