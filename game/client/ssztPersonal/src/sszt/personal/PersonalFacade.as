package sszt.personal
{
	import sszt.personal.commands.PersonalEndCommand;
	import sszt.personal.commands.PersonalStartCommand;
	import sszt.personal.events.PersonalMediatorEvents;
	import sszt.personal.mediators.PersonalMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PersonalFacade extends Facade
	{
		private var _key:String;
		
		public function PersonalFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):PersonalFacade
		{
			if(!(instanceMap[key] is PersonalFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new PersonalFacade(key);
			}
			return instanceMap[key];
		}
		
		public function setup(argPersonalModule:PersonalModule):void
		{
			sendNotification(PersonalMediatorEvents.PERSONAL_COMMAND_START,argPersonalModule);
//			sendNotification(PersonalMediatorEvents.PERSONAL_MEDIATOR_START);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(PersonalMediatorEvents.PERSONAL_COMMAND_START,PersonalStartCommand);
			registerCommand(PersonalMediatorEvents.PERSONAL_COMMAND_END,PersonalEndCommand);
		}
		
		public function dispose():void
		{
			sendNotification(PersonalMediatorEvents.PERSONAL_MEDIATOR_DISPOSE);
			sendNotification(PersonalMediatorEvents.PERSONAL_COMMAND_END);
			removeCommand(PersonalMediatorEvents.PERSONAL_COMMAND_START);
			removeCommand(PersonalMediatorEvents.PERSONAL_COMMAND_END);
			delete instanceMap[_key];
		}
	}
}