package sszt.payTagView
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.payTagView.command.PayTagViewCommandEnd;
	import sszt.payTagView.command.PayTagViewCommandStart;
	import sszt.payTagView.events.PayTagViewMediaEvents;

	public class PayTagViewFacade extends Facade
	{
		private var _key:String;
		public var payTagViewModule:PayTagViewModule;
		
		public function PayTagViewFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):PayTagViewFacade
		{
			if(instanceMap[key] != PayTagViewFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new PayTagViewFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(PayTagViewMediaEvents.PTW_COMMAND_START,PayTagViewCommandStart);
			registerCommand(PayTagViewMediaEvents.PTW_COMMADN_END,PayTagViewCommandEnd);
		}
		
		public function setup(argModule:PayTagViewModule):void
		{
			payTagViewModule = argModule;
			sendNotification(PayTagViewMediaEvents.PTW_COMMAND_START,payTagViewModule);
			sendNotification(PayTagViewMediaEvents.PTW_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(PayTagViewMediaEvents.PTW_COMMADN_END);
			removeCommand(PayTagViewMediaEvents.PTW_COMMAND_START);
			removeCommand(PayTagViewMediaEvents.PTW_COMMADN_END);
			payTagViewModule = null;
			instanceMap[_key] = null;
		}
	}
}