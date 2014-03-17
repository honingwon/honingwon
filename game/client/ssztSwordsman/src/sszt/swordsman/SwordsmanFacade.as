package sszt.swordsman
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.core.data.module.changeInfos.ToSwordsmanData;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.swordsman.command.SwordsmanCommandEnd;
	import sszt.swordsman.command.SwordsmanCommandStart;

	public class SwordsmanFacade extends Facade
	{
		public var _key:String;
		public var _swordsmanModule:SwordsmanModule;
		
		public function SwordsmanFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):SwordsmanFacade
		{
			if(instanceMap[key] != SwordsmanFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new SwordsmanFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(SwordsmanMediaEvents.TEMPLATE_COMMAND_START,SwordsmanCommandStart);
			registerCommand(SwordsmanMediaEvents.TEMPLATE_COMMADN_END,SwordsmanCommandEnd);
		}
		
		public function setup(swordsmanModule:SwordsmanModule,toSD:ToSwordsmanData):void
		{
			_swordsmanModule = swordsmanModule;
			sendNotification(SwordsmanMediaEvents.TEMPLATE_COMMAND_START,_swordsmanModule);
			sendNotification(SwordsmanMediaEvents.TEMPLATE_MEDIATOR_START,toSD);
		}
		
		public function dispose():void
		{
			sendNotification(SwordsmanMediaEvents.TEMPLATE_COMMADN_END);
			removeCommand(SwordsmanMediaEvents.TEMPLATE_COMMAND_START);
			removeCommand(SwordsmanMediaEvents.TEMPLATE_COMMADN_END);
			delete instanceMap[_key];
			_swordsmanModule = null;
		}
	}
}