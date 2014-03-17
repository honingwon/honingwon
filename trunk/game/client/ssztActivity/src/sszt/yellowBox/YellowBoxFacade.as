package sszt.yellowBox
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.yellowBox.command.YellowBoxCommandEnd;
	import sszt.yellowBox.command.YellowBoxCommandStart;
	import sszt.yellowBox.events.YellowBoxMediaEvents;

	public class YellowBoxFacade extends Facade
	{
		private var _key:String;
		public var yellowBoxModule:YellowBoxModule;
		
		public function YellowBoxFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):YellowBoxFacade
		{
			if(instanceMap[key] != YellowBoxFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new YellowBoxFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(YellowBoxMediaEvents.YELLOW_COMMAND_START,YellowBoxCommandStart);
			registerCommand(YellowBoxMediaEvents.YELLOW_COMMADN_END,YellowBoxCommandEnd);
		}
		
		public function setup(argModule:YellowBoxModule):void
		{
			yellowBoxModule = argModule;
			sendNotification(YellowBoxMediaEvents.YELLOW_COMMAND_START,yellowBoxModule);
			sendNotification(YellowBoxMediaEvents.YELLOW_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(YellowBoxMediaEvents.YELLOW_COMMADN_END);
			removeCommand(YellowBoxMediaEvents.YELLOW_COMMAND_START);
			removeCommand(YellowBoxMediaEvents.YELLOW_COMMADN_END);
			yellowBoxModule = null;
			instanceMap[_key] = null;
		}
	}
}