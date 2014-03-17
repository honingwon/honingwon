package sszt.challenge.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.challenge.ChallengeModule;
	import sszt.challenge.components.ChallengePanel;
	import sszt.challenge.events.ChallengeMediaEvents;
	import sszt.core.data.GlobalAPI;
	
	public class ChallengeMediator extends Mediator
	{
		public static const NAME:String = "templateMediator";
		
		public function ChallengeMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case ChallengeMediaEvents.CHALLENGE_MEDIATOR_START:
					initialView(notification.getBody() as Number);
					break;
				case ChallengeMediaEvents.CHALLENGE_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [ChallengeMediaEvents.CHALLENGE_MEDIATOR_START,
				ChallengeMediaEvents.CHALLENGE_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(tempId:Number):void
		{
			if(challengeModule.challengePanel == null)
			{
				challengeModule.challengePanel=new ChallengePanel(this);
				GlobalAPI.layerManager.addPanel(challengeModule.challengePanel);
				challengeModule.challengePanel.addEventListener(Event.CLOSE,challPanelCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() == challengeModule.challengePanel)
				{
					challengeModule.challengePanel.dispose();
				}
				else
				{
					challengeModule.challengePanel.setToTop();
				}
			}
		}
		
		public function get challengeModule():ChallengeModule
		{
			return viewComponent as ChallengeModule;
		}
		
		private function challPanelCloseHandler(evt:Event):void
		{
			if(challengeModule.challengePanel)
			{
				challengeModule.challengePanel.removeEventListener(Event.CLOSE,challPanelCloseHandler);
				challengeModule.challengePanel = null;
				challengeModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}