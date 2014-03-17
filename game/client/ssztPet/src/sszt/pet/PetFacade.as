package sszt.pet
{
	import sszt.pet.command.PetEndCommand;
	import sszt.pet.command.PetStartCommand;
	import sszt.pet.event.PetMediatorEvent;
	import sszt.pet.mediator.PetMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PetFacade extends Facade
	{
		private var _key:String;
		
		public function PetFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):PetFacade
		{
			if(!(instanceMap[key] is PetFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new PetFacade(key); 
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(PetMediatorEvent.PET_START_COMMAND,PetStartCommand);
			registerCommand(PetMediatorEvent.PET_END_COMMAND,PetEndCommand);
		}
		
		public function startup(module:PetModule):void
		{
			sendNotification(PetMediatorEvent.PET_START_COMMAND,module);
		}
		
		public function dispose():void
		{
			sendNotification(PetMediatorEvent.PET_DISPOSE);
			sendNotification(PetMediatorEvent.PET_END_COMMAND);
			removeCommand(PetMediatorEvent.PET_START_COMMAND);
			removeCommand(PetMediatorEvent.PET_END_COMMAND);
			delete instanceMap[_key];
		}
	}
}