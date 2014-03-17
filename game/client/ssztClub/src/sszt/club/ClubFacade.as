package sszt.club
{
	import sszt.club.commands.ClubEndCommand;
	import sszt.club.commands.ClubStartCommand;
	import sszt.club.events.ClubMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ClubFacade extends Facade
	{
		public static function getInstance(key:String):ClubFacade
		{
			if(!(instanceMap[key] is ClubFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new ClubFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var clubModule:ClubModule;
		
		public function ClubFacade(key:String)
		{
			_key = key;
			super(_key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(ClubMediatorEvent.CLUB_COMMAND_START,ClubStartCommand);
			registerCommand(ClubMediatorEvent.CLUB_COMMAND_END,ClubEndCommand);
		}
		
		public function setup(module:ClubModule):void
		{
			clubModule = module;
			sendNotification(ClubMediatorEvent.CLUB_COMMAND_START,module);
		}
		
		public function dispose():void
		{
			sendNotification(ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE);
			sendNotification(ClubMediatorEvent.CLUB_COMMAND_END);
			removeCommand(ClubMediatorEvent.CLUB_COMMAND_START);
			removeCommand(ClubMediatorEvent.CLUB_COMMAND_END);
			delete instanceMap[_key];
			clubModule = null;
		}
	}
}