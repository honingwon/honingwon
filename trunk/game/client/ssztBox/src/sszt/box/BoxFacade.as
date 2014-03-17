package sszt.box
{
	import sszt.box.commands.BoxCommandEnd;
	import sszt.box.commands.BoxCommandStart;
	import sszt.box.events.BoxMediatorEvents;
	import sszt.box.mediators.BoxMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class BoxFacade extends Facade
	{
		private var _key:String;
		public function BoxFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):BoxFacade
		{
			if(!(instanceMap[key] is BoxFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new BoxFacade(key);
			}
			return instanceMap[key];
		}
		
		public function setup(boxModule:BoxModule):void
		{
			sendNotification(BoxMediatorEvents.BOX_COMMAND_START, boxModule);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(BoxMediatorEvents.BOX_COMMAND_START, BoxCommandStart);
			registerCommand(BoxMediatorEvents.BOX_COMMAND_END, BoxCommandEnd);
		}
		
		public function dispose():void
		{
			sendNotification(BoxMediatorEvents.BOX_MEDIATOR_DISPOSE);
			sendNotification(BoxMediatorEvents.BOX_COMMAND_END);
			removeCommand(BoxMediatorEvents.BOX_COMMAND_START);
			removeCommand(BoxMediatorEvents.BOX_COMMAND_END);
			delete instanceMap[_key];
		}
	}
}