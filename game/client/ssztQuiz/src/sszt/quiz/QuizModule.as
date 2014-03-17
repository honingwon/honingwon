package sszt.quiz
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.quiz.component.QuizPanel;
	import sszt.quiz.component.QuizStartRemindingPanel;
	import sszt.quiz.event.QuizMediatorEvent;
	
	public class QuizModule extends BaseModule
	{
		public var facade:QuizFacade;
		public var mainPanel:QuizPanel;
		public var quizStartRemindingPanel:QuizStartRemindingPanel;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev, data);
			var toBagData:ToQuizData = data as ToQuizData;
			facade = QuizFacade.getInstance(String(moduleId));
			facade.startup(this,data);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			facade.sendNotification(QuizMediatorEvent.QUIZ_START,data);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
		}
		
		override public function assetsCompleteHandler():void
		{
			super.assetsCompleteHandler();
		}
		
		override public function get moduleId():int
		{
			return ModuleType.QUIZ;
		}

		override public function dispose():void
		{
			super.dispose();
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
		}
	}
}