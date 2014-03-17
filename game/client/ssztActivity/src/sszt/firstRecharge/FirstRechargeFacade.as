package sszt.firstRecharge
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.firstRecharge.command.FirstRechargeCommandEnd;
	import sszt.firstRecharge.command.FirstRechargeCommandStart;
	import sszt.firstRecharge.events.FirstRechargeMediaEvents;

	public class FirstRechargeFacade extends Facade
	{
		private var _key:String;
		public var firstRechargeModule:FirstRechargeModule;
		
		public function FirstRechargeFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):FirstRechargeFacade
		{
			if(instanceMap[key] != FirstRechargeFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new FirstRechargeFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(FirstRechargeMediaEvents.FIRSTRECH_COMMAND_START,FirstRechargeCommandStart);
			registerCommand(FirstRechargeMediaEvents.FIRSTRECH_COMMADN_END,FirstRechargeCommandEnd);
		}
		
		public function setup(templateModule:FirstRechargeModule):void
		{
			firstRechargeModule = templateModule;
			sendNotification(FirstRechargeMediaEvents.FIRSTRECH_COMMAND_START,templateModule);
			sendNotification(FirstRechargeMediaEvents.FIRSTRECH_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(FirstRechargeMediaEvents.FIRSTRECH_COMMADN_END);
			removeCommand(FirstRechargeMediaEvents.FIRSTRECH_COMMAND_START);
			removeCommand(FirstRechargeMediaEvents.FIRSTRECH_COMMADN_END);
			firstRechargeModule = null;
			instanceMap[_key] = null;
		}
	}
}