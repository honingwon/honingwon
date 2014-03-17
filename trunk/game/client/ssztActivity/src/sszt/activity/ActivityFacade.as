package sszt.activity
{
	import flash.events.ActivityEvent;
	import flash.sampler.DeleteObjectSample;
	
	import sszt.activity.commands.ActivityEndCommand;
	import sszt.activity.commands.ActivityStartCommand;
	import sszt.activity.events.ActivityMediatorEvents;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ActivityFacade extends Facade
	{
		private var _key:String;
		public function ActivityFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):ActivityFacade
		{
			if(!instanceMap[key])
			{
				delete instanceMap[key];
				instanceMap[key] = new ActivityFacade(key);
			}
			return instanceMap[key];
		}
		
		public function setup(activityModule:ActivityModule,data:Object):void
		{
			sendNotification(ActivityMediatorEvents.ACTIVITY_COMMAND_START,activityModule);
		}
		
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(ActivityMediatorEvents.ACTIVITY_COMMAND_START,ActivityStartCommand);
			registerCommand(ActivityMediatorEvents.ACTIVITY_COMMAND_END,ActivityEndCommand);
		}
		
		public function dispose():void
		{
			sendNotification(ActivityMediatorEvents.ACTIVITY_MEDIATRO_DISPOSE);
			sendNotification(ActivityMediatorEvents.ACTIVITY_COMMAND_END);
			removeCommand(ActivityMediatorEvents.ACTIVITY_COMMAND_START);
			removeCommand(ActivityMediatorEvents.ACTIVITY_COMMAND_END);
			delete instanceMap[_key];
		}
	}
}