package sszt.role
{
	import sszt.role.command.RoleCommandEnd;
	import sszt.role.command.RoleCommandStart;
	import sszt.role.events.RoleMediaEvents;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class RoleFacade extends Facade
	{
		public var _key:String;
		public var _roleModule:RoleModule;
		public function RoleFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):RoleFacade
		{
			if(instanceMap[key] !=RoleFacade)
			{
				delete 	instanceMap[key];
				instanceMap[key] = new RoleFacade(key);
			}
			return instanceMap[key];
		}
			
		public function setup(roleModule:RoleModule):void
		{
			_roleModule = roleModule;
			sendNotification(RoleMediaEvents.ROLE_COMMAND_START,roleModule);
//			sendNotification(RoleMediaEvents.ROLE_MEDIATOR_START);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(RoleMediaEvents.ROLE_COMMAND_START,RoleCommandStart);
			registerCommand(RoleMediaEvents.ROLE_COMMADN_END,RoleCommandEnd);
		}
		
		public function dispose():void
		{
			sendNotification(RoleMediaEvents.ROLE_MEDIATOR_DISPOSE);
			sendNotification(RoleMediaEvents.ROLE_COMMADN_END);
			removeCommand(RoleMediaEvents.ROLE_COMMAND_START);
			removeCommand(RoleMediaEvents.ROLE_COMMADN_END);
			delete instanceMap[_key];
			_roleModule = null;
		}
	}
}