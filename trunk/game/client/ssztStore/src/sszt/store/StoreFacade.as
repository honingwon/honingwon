package sszt.store
{
	import sszt.store.command.StoreEndCommand;
	import sszt.store.command.StoreStartCommand;
	import sszt.store.event.StoreMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class StoreFacade extends Facade
	{
		private var _key:String;
		public var _storeModule:StoreModule;
		
		public function StoreFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):StoreFacade
		{
			if(!(instanceMap[key] is StoreFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new StoreFacade(key);
			}
			return instanceMap[key];
			
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(StoreMediatorEvent.STORE_COMMAND_START,StoreStartCommand);
			registerCommand(StoreMediatorEvent.STORE_COMMAND_END,StoreEndCommand);
		}
		
		public function startup(module:StoreModule,data:Object):void
		{
			_storeModule= module;
			sendNotification(StoreMediatorEvent.STORE_COMMAND_START,_storeModule);
		}
		
		public function dispose():void
		{
		   sendNotification(StoreMediatorEvent.STORE_COMMAND_END);
		   sendNotification(StoreMediatorEvent.STORE_DISPOSE);
		   removeCommand(StoreMediatorEvent.STORE_COMMAND_START);
		   removeCommand(StoreMediatorEvent.STORE_COMMAND_END);
		   _storeModule = null;
		   instanceMap[_key] = null;
		}
	}
	
}