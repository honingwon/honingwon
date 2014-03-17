package sszt.navigation
{
	import sszt.navigation.commands.NavigationEndCommand;
	import sszt.navigation.commands.NavigationStartCommand;
	import sszt.navigation.events.NavigationMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class NavigationFacade extends Facade
	{
		public static function getInstance(key:String):NavigationFacade
		{
			if(!(instanceMap[key] is NavigationFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new NavigationFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var navigationModule:NavigationModule;
		
		public function NavigationFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(NavigationMediatorEvent.NAVIGATION_COMMAND_START,NavigationStartCommand);
			registerCommand(NavigationMediatorEvent.NAVIGATION_COMMAND_END,NavigationEndCommand);
		}
		
		public function startup(module:NavigationModule):void
		{
			navigationModule = module;
			sendNotification(NavigationMediatorEvent.NAVIGATION_COMMAND_START,navigationModule);
		}
		
		public function dispose():void
		{
			sendNotification(NavigationMediatorEvent.NAVIGATION_MEDIATOR_DISPOSE);
			sendNotification(NavigationMediatorEvent.NAVIGATION_COMMAND_END);
			removeCommand(NavigationMediatorEvent.NAVIGATION_COMMAND_START);
			removeCommand(NavigationMediatorEvent.NAVIGATION_COMMAND_END);
			delete instanceMap[_key];
			navigationModule = null;
		}
	}
}