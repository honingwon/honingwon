package sszt.consign
{
	import sszt.consign.command.ConsignCommandEnd;
	import sszt.consign.command.ConsignCommandStart;
	import sszt.consign.components.quickConsign.QuickConsignPanel;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.events.ConsignMediatorEvents;
	import sszt.consign.mediator.ConsignMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ConsignFacade extends Facade
	{
		private var _key:String;
		public function ConsignFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):ConsignFacade
		{
			if(instanceMap[key]!=ConsignFacade)
			{
				delete instanceMap[key];
				instanceMap[key] = new ConsignFacade(key);
			}
			return instanceMap[key];
		}
		
		public function setup(consignModule:ConsignModule):void
		{
			sendNotification(ConsignMediatorEvents.CONSIGN_COMMAND_START,consignModule);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(ConsignMediatorEvents.CONSIGN_COMMAND_START,ConsignCommandStart);
			registerCommand(ConsignMediatorEvents.CONSIGN_COMMAND_END,ConsignCommandEnd);
		}
		
		public function dispose():void
		{
			sendNotification(ConsignMediatorEvents.CONSIGN_MEDIATOR_DISPOSE);
			sendNotification(ConsignMediatorEvents.CONSIGN_COMMAND_END);
			removeCommand(ConsignMediatorEvents.CONSIGN_COMMAND_START);
			removeCommand(ConsignMediatorEvents.CONSIGN_COMMAND_END);
			delete instanceMap[_key];
		}
		
	}
}