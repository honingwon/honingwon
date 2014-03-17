package sszt.marriage
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.marriage.command.MarriageEndCommand;
	import sszt.marriage.command.MarriageStartCommand;
	import sszt.marriage.event.MarriageMediatorEvent;
	
	public class MarriageFacade extends Facade
	{
		public static function getInstance(key:String):MarriageFacade
		{
			if(!(instanceMap[key] is MarriageFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new MarriageFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		
		public function MarriageFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(MarriageMediatorEvent.MARRIAGE_COMMAND_START,MarriageStartCommand);
			registerCommand(MarriageMediatorEvent.MARRIAGE_COMMAND_END,MarriageEndCommand);
		}
		
		public function startup(module:MarriageModule,data:Object):void
		{
			sendNotification(MarriageMediatorEvent.MARRIAGE_COMMAND_START,module);
		}
		
		public function dispose():void
		{
			sendNotification(MarriageMediatorEvent.MARRIAGE_DISPOSE);
			sendNotification(MarriageMediatorEvent.MARRIAGE_COMMAND_END);
			removeCommand(MarriageMediatorEvent.MARRIAGE_COMMAND_END);
			removeCommand(MarriageMediatorEvent.MARRIAGE_COMMAND_START);
			instanceMap[_key] = null;
		}
	}
}