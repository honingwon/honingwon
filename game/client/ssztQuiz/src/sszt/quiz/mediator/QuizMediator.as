package sszt.quiz.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.quiz.QuizModule;
	import sszt.quiz.component.QuizPanel;
	import sszt.quiz.component.QuizStartRemindingPanel;
	import sszt.quiz.event.QuizMediatorEvent;
	
	public class QuizMediator extends Mediator
	{
		public static const NAME:String = "quizMediator";
		
		public function QuizMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				QuizMediatorEvent.QUIZ_START,
				QuizMediatorEvent.QUIZ_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:ToQuizData = notification.getBody() as ToQuizData;
			switch(notification.getName())
			{
				case QuizMediatorEvent.QUIZ_START:
					
					switch(data.viewType)
					{
						case 0 :
							showQuizPanel();
							break;
						case 1 :
							showQuizStartRemindingPanel();
							break;
					}
					break;
					
				case QuizMediatorEvent.QUIZ_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function showQuizStartRemindingPanel():void
		{
			if(quizModule.quizStartRemindingPanel == null)
			{
				quizModule.quizStartRemindingPanel = new QuizStartRemindingPanel();
				quizModule.quizStartRemindingPanel.addEventListener(Event.CLOSE,quizStartRemindingPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(quizModule.quizStartRemindingPanel);
			}
		}
		
		private function quizStartRemindingPanelCloseHandler(evt:Event):void
		{
			if(quizModule.quizStartRemindingPanel)
			{
				quizModule.quizStartRemindingPanel.removeEventListener(Event.CLOSE,quizStartRemindingPanelCloseHandler);
				quizModule.quizStartRemindingPanel = null;
				if(!quizModule.mainPanel)
				{
					quizModule.dispose();
				}
			}
		}
		
		private function showQuizPanel():void
		{
			if(quizModule.mainPanel == null)
			{
				quizModule.mainPanel = new QuizPanel(this);
				quizModule.mainPanel.addEventListener(Event.CLOSE,quizPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(quizModule.mainPanel);
			}
		}
		
		private function quizPanelCloseHandler(evt:Event):void
		{
			if(quizModule.mainPanel)
			{
				quizModule.mainPanel.removeEventListener(Event.CLOSE,quizPanelCloseHandler);
				quizModule.mainPanel = null;
				
				if(!quizModule.quizStartRemindingPanel)
				{
					quizModule.dispose();
				}
			}
		}
		
		public function get quizModule():QuizModule
		{
			return viewComponent as QuizModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}