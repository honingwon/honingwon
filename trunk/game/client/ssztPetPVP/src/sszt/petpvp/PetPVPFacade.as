package sszt.petpvp
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.petpvp.commands.PetPVPCommandEnd;
	import sszt.petpvp.commands.PetPVPCommandStart;
	import sszt.petpvp.events.PetPVPMediatorEvent;
	
	public class PetPVPFacade extends Facade
	{
		public function PetPVPFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):PetPVPFacade
		{
			if(!(instanceMap[key] is PetPVPFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new PetPVPFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var petPVPModule:PetPVPModule;
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(PetPVPMediatorEvent.PET_PVP_COMMAND_START,PetPVPCommandStart);
			registerCommand(PetPVPMediatorEvent.PET_PVP_COMMAND_END,PetPVPCommandEnd);
		}
		
		public function startup(module:PetPVPModule,data:Object):void
		{
			petPVPModule = module;
			sendNotification(PetPVPMediatorEvent.PET_PVP_COMMAND_START,module);
			sendNotification(PetPVPMediatorEvent.PET_PVP_START,data);
		}
		
		public function dispose():void
		{
			sendNotification(PetPVPMediatorEvent.PET_PVP_DISPOSE);
			sendNotification(PetPVPMediatorEvent.PET_PVP_COMMAND_END);
			removeCommand(PetPVPMediatorEvent.PET_PVP_COMMAND_END);
			removeCommand(PetPVPMediatorEvent.PET_PVP_COMMAND_START);
			petPVPModule = null;
			instanceMap[_key] = null;
		}
	}
}