package sszt.target
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.events.TargetMediaEvents;
	import sszt.target.command.TargetCommandEnd;
	import sszt.target.command.TargetCommandStart;

	public class TargetFacade extends Facade
	{
		private var _key:String;
		public var targetModule:TargetModule;
		
		public function TargetFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):TargetFacade
		{
			if(instanceMap[key] != TargetFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new TargetFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(TargetMediaEvents.TARGET_COMMAND_START,TargetCommandStart);
			registerCommand(TargetMediaEvents.TARGET_COMMADN_END,TargetCommandEnd);
		}
		
		public function setup(templateModule:TargetModule,toTD:ToTargetData):void
		{
			targetModule = templateModule;
			sendNotification(TargetMediaEvents.TARGET_COMMAND_START,targetModule);
			sendNotification(TargetMediaEvents.TARGET_MEDIATOR_START,toTD);
		}
		
		public function dispose():void
		{
			sendNotification(TargetMediaEvents.TARGET_COMMADN_END);
			removeCommand(TargetMediaEvents.TARGET_COMMAND_START);
			removeCommand(TargetMediaEvents.TARGET_COMMADN_END);
			targetModule = null;
			instanceMap[_key] = null;
		}
	}
}