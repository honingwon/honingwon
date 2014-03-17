package sszt.bag
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import sszt.bag.event.BagMediatorEvent;
	import sszt.bag.command.BagEndCommand;
	import sszt.bag.command.BagStartCommand;
	

	public class BagFacade extends Facade
	{
		public static function getInstance(key:String):BagFacade
		{
			if(!(instanceMap[key] is BagFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new BagFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var bagModule:BagModule;
		
		public function BagFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(BagMediatorEvent.BAG_COMMAND_START,BagStartCommand);
			registerCommand(BagMediatorEvent.BAG_COMMAND_END,BagEndCommand);
		}
		
		public function startup(module:BagModule,data:Object):void
		{
			bagModule = module;
			sendNotification(BagMediatorEvent.BAG_COMMAND_START,module);
			sendNotification(BagMediatorEvent.BAG_START,data);
		}
		
		public function dispose():void
		{
			sendNotification(BagMediatorEvent.BAG_DISPOSE);
			sendNotification(BagMediatorEvent.BAG_COMMAND_END);
			removeCommand(BagMediatorEvent.BAG_COMMAND_END);
			removeCommand(BagMediatorEvent.BAG_COMMAND_START);
			bagModule = null;
			instanceMap[_key] = null;
		}
	}
}