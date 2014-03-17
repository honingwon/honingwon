package sszt.furnace
{
	import sszt.furnace.commands.FurnaceEndCommand;
	import sszt.furnace.commands.FurnaceStartCommand;
	import sszt.furnace.events.FurnaceMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class FurnaceFacade extends Facade
	{
		private var _key:String;
		public var furnaceModule:FurnaceModule;
		
		public static function getInstance(key:String):FurnaceFacade
		{
			if(!(instanceMap[key] is FurnaceFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new FurnaceFacade(key);
			}
			return instanceMap[key];
		}
		
		public function FurnaceFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(FurnaceMediatorEvent.FURNACE_COMMAND_START,FurnaceStartCommand);
			registerCommand(FurnaceMediatorEvent.FURNACE_COMMAND_END,FurnaceEndCommand);
		}
		
		public function startup(module:FurnaceModule):void
		{
			furnaceModule = module;
			sendNotification(FurnaceMediatorEvent.FURNACE_COMMAND_START,module);
//			if(furnaceModule.toData.selectIndex == 8)
//			{
//				sendNotification(FurnaceMediatorEvent.FURNACE_SHOW_FIREBOX);
//			}
//			else
//			{
//				sendNotification(FurnaceMediatorEvent.FURNACE_MEDIATOR_START);
//			}
		}
		
		public function dispose():void
		{
			sendNotification(FurnaceMediatorEvent.FURNACE_MEDIATOR_DISPOSE);
			sendNotification(FurnaceMediatorEvent.FURNACE_COMMAND_END);
			removeCommand(FurnaceMediatorEvent.FURNACE_COMMAND_START);
			removeCommand(FurnaceMediatorEvent.FURNACE_COMMAND_END);
			delete instanceMap[_key];
			furnaceModule = null;
		}
	}
}