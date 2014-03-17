package sszt.pvp
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.pvp.commands.PVPEndCommand;
	import sszt.pvp.commands.PVPStartCommand;
	import sszt.pvp.events.PVPMediatorEvent;
	
	public class PVPFacade extends Facade
	{
		private var _key:String;
		public var _pvpModule:PVPModule;
		
		public function PVPFacade(key:String)
		{
			_key = key;
			super(key);
		}
		public static function getInstance(key:String):PVPFacade
		{
			if(instanceMap[key] != PVPFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new PVPFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(PVPMediatorEvent.PVP_COMMAND_START,PVPStartCommand);
			registerCommand(PVPMediatorEvent.PVP_COMMAND_END,PVPEndCommand);
		}
		
		public function setup(pvpModule:PVPModule,topvpData:ToPvPData):void
		{
			_pvpModule = pvpModule;
			sendNotification(PVPMediatorEvent.PVP_COMMAND_START,_pvpModule);
			if(!topvpData || topvpData.openPanel == 0)
			{
				sendNotification(PVPMediatorEvent.PVP_MEDIATOR_START);
			}
			else if(topvpData.openPanel == 1)
			{
				sendNotification(PVPMediatorEvent.PVP_RESULT_PANEL_INIT,topvpData);
			}
			else if(topvpData.openPanel == 2)
			{
				sendNotification(PVPMediatorEvent.PVP_CLUE_PANEL_INIT);
			}
			
		}
		
		public function dispose():void
		{
			sendNotification(PVPMediatorEvent.PVP_COMMAND_END);
			removeCommand(PVPMediatorEvent.PVP_COMMAND_START);
			removeCommand(PVPMediatorEvent.PVP_COMMAND_END);
			_pvpModule = null;
			instanceMap[_key] = null;
			
		}
	}
}