package sszt.consumTagView
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.consumTagView.command.ConsumTagViewCommandEnd;
	import sszt.consumTagView.command.ConsumTagViewCommandStart;
	import sszt.consumTagView.events.ConsumTagViewMediaEvents;

	public class ConsumTagViewFacade extends Facade
	{
		private var _key:String;
		public var consumViewModule:ConsumTagViewModule;
		
		public function ConsumTagViewFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):ConsumTagViewFacade
		{
			if(instanceMap[key] != ConsumTagViewFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new ConsumTagViewFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(ConsumTagViewMediaEvents.CON_COMMAND_START,ConsumTagViewCommandStart);
			registerCommand(ConsumTagViewMediaEvents.CON_COMMADN_END,ConsumTagViewCommandEnd);
		}
		
		public function setup(argModule:ConsumTagViewModule):void
		{
			consumViewModule = argModule;
			sendNotification(ConsumTagViewMediaEvents.CON_COMMAND_START,consumViewModule);
			sendNotification(ConsumTagViewMediaEvents.CON_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(ConsumTagViewMediaEvents.CON_COMMADN_END);
			removeCommand(ConsumTagViewMediaEvents.CON_COMMAND_START);
			removeCommand(ConsumTagViewMediaEvents.CON_COMMADN_END);
			consumViewModule = null;
			instanceMap[_key] = null;
		}
	}
}