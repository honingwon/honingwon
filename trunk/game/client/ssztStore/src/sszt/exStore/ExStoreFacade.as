package sszt.exStore
{
	import sszt.exStore.command.StoreEndCommand;
	import sszt.exStore.command.StoreStartCommand;
	import sszt.exStore.event.StoreMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class ExStoreFacade extends Facade
	{
		private var _key:String;
		public var _storeModule:ExStoreModule;
		
		public function ExStoreFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):ExStoreFacade
		{
			if(!(instanceMap[key] is ExStoreFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new ExStoreFacade(key);
			}
			return instanceMap[key];
			
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(StoreMediatorEvent.STORE_COMMAND_START,StoreStartCommand);
			registerCommand(StoreMediatorEvent.STORE_COMMAND_END,StoreEndCommand);
		}
		
		public function startup(module:ExStoreModule,data:Object):void
		{
			_storeModule= module;
			sendNotification(StoreMediatorEvent.STORE_COMMAND_START,_storeModule);
			sendNotification(StoreMediatorEvent.STORE_START,data);
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