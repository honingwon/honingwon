package sszt.midAutumnActivity
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.midAutumnActivity.command.MidAutumnActivityEndCommand;
	import sszt.midAutumnActivity.command.MidAutumnActivityStartCommand;
	import sszt.midAutumnActivity.event.MidAutumnActivityMediatorEvent;
	
	public class MidAutumnActivityFacade extends Facade
	{
		public static function getInstance(key:String):MidAutumnActivityFacade
		{
			if(!(instanceMap[key] is MidAutumnActivityFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new MidAutumnActivityFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		
		public function MidAutumnActivityFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_COMMAND_START,MidAutumnActivityStartCommand);
			registerCommand(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_COMMAND_END,MidAutumnActivityEndCommand);
		}
		
		public function startup(module:MidAutumnActivityModule,data:Object):void
		{
			sendNotification(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_COMMAND_START,module);
		}
		
		public function dispose():void
		{
			sendNotification(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_DISPOSE);
			sendNotification(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_COMMAND_END);
			removeCommand(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_COMMAND_END);
			removeCommand(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_COMMAND_START);
			instanceMap[_key] = null;
		}
	}
}