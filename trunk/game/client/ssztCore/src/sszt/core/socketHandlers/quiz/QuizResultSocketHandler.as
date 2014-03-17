package sszt.core.socketHandlers.quiz
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.quiz.QuizQuestionResult;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.QuizModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class QuizResultSocketHandler extends BaseSocketHandler
	{
		public function QuizResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.QUIZ_RESULT;
		}
		
		override public function handlePackage():void
		{
			var questionResult:QuizQuestionResult = new QuizQuestionResult();
			questionResult.index = _data.readShort();
			questionResult.isOrNot = (_data.readByte() == 1);
			questionResult.expAward = _data.readInt();
			questionResult.bindYuanbao = _data.readInt();
			
			if(questionResult.isOrNot) GlobalData.quizInfo.totalRight ++;
			else GlobalData.quizInfo.totalWrong ++;
			
			GlobalData.quizInfo.addQuestionResultItem(questionResult);
			GlobalData.quizInfo.totalExpAward += questionResult.expAward;
			GlobalData.quizInfo.totalBindYuanbao += questionResult.bindYuanbao;
			
			var message:String;
			var id:String = questionResult.isOrNot ? 'ssztl.quiz.right' : 'ssztl.quiz.wrong';
			QuickTips.show(LanguageManager.getWord(id,questionResult.expAward,questionResult.bindYuanbao));
			
			handComplete();
		}
	}
}