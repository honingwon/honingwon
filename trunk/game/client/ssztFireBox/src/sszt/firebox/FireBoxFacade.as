package sszt.firebox
{
	import sszt.firebox.commands.FireBoxEndCommand;
	import sszt.firebox.commands.FireBoxStartCommand;
	import sszt.firebox.events.FireBoxMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class FireBoxFacade extends Facade
	{
		private var _key:String;
		public var fireBoxModule:FireBoxModule;
		
		public static function getInstance(key:String):FireBoxFacade
		{
			if(!(instanceMap[key] is FireBoxFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new FireBoxFacade(key);
			}
			return instanceMap[key];
		}
		
		public function FireBoxFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(FireBoxMediatorEvent.FIREBOX_COMMAND_START,FireBoxStartCommand);
			registerCommand(FireBoxMediatorEvent.FIREBOX_COMMAND_END,FireBoxEndCommand);
		}
		
		public function startup(module:FireBoxModule):void
		{
			fireBoxModule = module;
			sendNotification(FireBoxMediatorEvent.FIREBOX_COMMAND_START,module);
		}
		
		public function dispose():void
		{
			sendNotification(FireBoxMediatorEvent.FIREBOX_MEDIATOR_DISPOSE);
			sendNotification(FireBoxMediatorEvent.FIREBOX_COMMAND_END);
			removeCommand(FireBoxMediatorEvent.FIREBOX_COMMAND_START);
			removeCommand(FireBoxMediatorEvent.FIREBOX_COMMAND_END);
			delete instanceMap[_key];
			fireBoxModule = null;
		}
	}
}