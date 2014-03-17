package sszt.challenge
{
	import sszt.challenge.components.ChallengePanel;
	import sszt.challenge.events.ChallengeMediaEvents;
	import sszt.challenge.socketHandlers.ChallengeSetSocketHandlers;
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.challenge.ChallengeInfoSocketHandler;
	import sszt.interfaces.module.IModule;

	public class ChallengeModule extends BaseModule
	{
		public var challengeFacade:ChallengeFacade;
		public var challengePanel:ChallengePanel;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(challengePanel)
			{
				challengePanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			ChallengeSetSocketHandlers.add(this);
			ChallengeInfoSocketHandler.send();
			if(challengePanel)
				challengePanel.dispose();
			else
				challengeFacade.sendNotification(ChallengeMediaEvents.CHALLENGE_MEDIATOR_START);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			ChallengeSetSocketHandlers.remove();
			if(challengePanel)
			{
				challengePanel.dispose();
				challengePanel = null;
			}
			if(challengeFacade)
			{
				challengeFacade.dispose();
				challengeFacade = null;
			}
			super.dispose();
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.Challenge;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			ChallengeSetSocketHandlers.add(this);
			ChallengeInfoSocketHandler.send();
			challengeFacade = ChallengeFacade.getInstance(moduleId.toString());
			challengeFacade.setup(this);
		}
	}
}