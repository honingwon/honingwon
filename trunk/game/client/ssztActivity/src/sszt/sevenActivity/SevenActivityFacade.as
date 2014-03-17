package sszt.sevenActivity
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.sevenActivity.command.SevenActivityCommandEnd;
	import sszt.sevenActivity.command.SevenActivityCommandStart;
	import sszt.sevenActivity.events.SevenActivityMediaEvents;

	public class SevenActivityFacade extends Facade
	{
		private var _key:String;
		public var sevenActivityModule:SevenActivityModule;
		
		public function SevenActivityFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):SevenActivityFacade
		{
			if(instanceMap[key] != SevenActivityFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new SevenActivityFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(SevenActivityMediaEvents.SEVEN_COMMAND_START,SevenActivityCommandStart);
			registerCommand(SevenActivityMediaEvents.SEVEN_COMMADN_END,SevenActivityCommandEnd);
		}
		
		public function setup(templateModule:SevenActivityModule):void
		{
			sevenActivityModule = templateModule;
			sendNotification(SevenActivityMediaEvents.SEVEN_COMMAND_START,sevenActivityModule);
			sendNotification(SevenActivityMediaEvents.SEVEN_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(SevenActivityMediaEvents.SEVEN_COMMADN_END);
			removeCommand(SevenActivityMediaEvents.SEVEN_COMMAND_START);
			removeCommand(SevenActivityMediaEvents.SEVEN_COMMADN_END);
			sevenActivityModule = null;
			instanceMap[_key] = null;
		}
	}
}