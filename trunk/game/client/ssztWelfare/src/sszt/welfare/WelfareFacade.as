package sszt.welfare
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.welfare.command.WelfareEndCommand;
	import sszt.welfare.command.WelfareStartCommand;
	import sszt.welfare.event.WelfareMediatorEvent;
	
	public class WelfareFacade extends Facade
	{
		private var _key:String;
		public var _welfareModule:WelfareModule;
		
		public function WelfareFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):WelfareFacade
		{
			if(!(instanceMap[key] is WelfareFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new WelfareFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(WelfareMediatorEvent.START,WelfareStartCommand);
			registerCommand(WelfareMediatorEvent.DISPOSE,WelfareEndCommand);
		}
		
		public function startup(module:WelfareModule,data:Object):void
		{
			_welfareModule= module;
			sendNotification(WelfareMediatorEvent.START,_welfareModule);
			sendNotification(WelfareMediatorEvent.INIT);
		}
		
		public function dispose():void
		{
			sendNotification(WelfareMediatorEvent.DISPOSE);
			removeCommand(WelfareMediatorEvent.INIT);
			removeCommand(WelfareMediatorEvent.DISPOSE);
			_welfareModule = null;
			instanceMap[_key] = null;
		}
	}
}