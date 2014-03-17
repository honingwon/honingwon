package sszt.stall
{
	import sszt.stall.command.StallCommandEnd;
	import sszt.stall.command.StallCommandStart;
	import sszt.stall.events.StallMediatorEvents;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class StallFacade extends Facade
	{
		public var _key:String;
		public var _stallModule:StallModule;
		
		public function StallFacade(key:String)
		{
			_key = key;
			super(_key);
		}
		
		public function setup(stallModule:StallModule):void
		{
			_stallModule = stallModule;
			sendNotification(StallMediatorEvents.STALL_COMMAND_START,_stallModule);
			sendNotification(StallMediatorEvents.STALL_MEDIATOR_START);
		}
		
		//构造函数super里面调用
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(StallMediatorEvents.STALL_COMMAND_START,StallCommandStart);
			registerCommand(StallMediatorEvents.STALL_COMMAND_END,StallCommandEnd);
		}
		
		
		//单例模式
		public static function getInstance(key:String):StallFacade
		{
			if(instanceMap[key] != StallFacade)
			{
				delete instanceMap[key];
				instanceMap[key] = new StallFacade(key);
			}
			return instanceMap[key];
		}
		
		public function dispose():void
		{
			sendNotification(StallMediatorEvents.STALL_MEDIATOR_DISPOSE);
			sendNotification(StallMediatorEvents.STALL_COMMAND_END);
			removeCommand(StallMediatorEvents.STALL_COMMAND_START);
			removeCommand(StallMediatorEvents.STALL_COMMAND_END);
			delete instanceMap[_key];
			_stallModule = null;
		}
	}
}