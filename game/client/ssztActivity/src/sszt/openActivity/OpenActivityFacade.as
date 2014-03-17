package sszt.openActivity
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.openActivity.command.OpenActivityCommandEnd;
	import sszt.openActivity.command.OpenActivityCommandStart;
	import sszt.openActivity.events.OpenActivityMediaEvents;

	public class OpenActivityFacade extends Facade
	{
		private var _key:String;
		public var openActivityModule:OpenActivityModule;
		
		public function OpenActivityFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):OpenActivityFacade
		{
			if(instanceMap[key] != OpenActivityFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new OpenActivityFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(OpenActivityMediaEvents.OPEN_ACTIVITY_COMMAND_START,OpenActivityCommandStart);
			registerCommand(OpenActivityMediaEvents.OPEN_ACTIVITY_COMMADN_END,OpenActivityCommandEnd);
		}
		
		public function setup(activityModule:OpenActivityModule):void
		{
			openActivityModule = activityModule;
			sendNotification(OpenActivityMediaEvents.OPEN_ACTIVITY_COMMAND_START,openActivityModule);
			sendNotification(OpenActivityMediaEvents.OPEN_ACTIVITY_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(OpenActivityMediaEvents.OPEN_ACTIVITY_COMMADN_END);
			removeCommand(OpenActivityMediaEvents.OPEN_ACTIVITY_COMMAND_START);
			removeCommand(OpenActivityMediaEvents.OPEN_ACTIVITY_COMMADN_END);
			openActivityModule = null;
			instanceMap[_key] = null;
		}
	}
}