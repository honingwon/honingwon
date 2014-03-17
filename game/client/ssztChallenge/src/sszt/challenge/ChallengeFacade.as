package sszt.challenge
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.challenge.command.ChallengeCommandEnd;
	import sszt.challenge.command.ChallengeCommandStart;
	import sszt.challenge.events.ChallengeMediaEvents;

	public class ChallengeFacade extends Facade
	{
		private var _key:String;
		public var challengeModule:ChallengeModule;
		
		public function ChallengeFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):ChallengeFacade
		{
			if(instanceMap[key] != ChallengeFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new ChallengeFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(ChallengeMediaEvents.CHALLENGE_COMMAND_START,ChallengeCommandStart);
			registerCommand(ChallengeMediaEvents.CHALLENGE_COMMADN_END,ChallengeCommandEnd);
		}
		
		public function setup(challenge:ChallengeModule):void
		{
			challengeModule = challenge;
			sendNotification(ChallengeMediaEvents.CHALLENGE_COMMAND_START,challengeModule);
			sendNotification(ChallengeMediaEvents.CHALLENGE_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(ChallengeMediaEvents.CHALLENGE_COMMADN_END);
			removeCommand(ChallengeMediaEvents.CHALLENGE_COMMAND_START);
			removeCommand(ChallengeMediaEvents.CHALLENGE_COMMADN_END);
			challengeModule = null;
			instanceMap[_key] = null;
		}
	}
}