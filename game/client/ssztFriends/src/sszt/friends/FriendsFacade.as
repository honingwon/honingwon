package sszt.friends
{
	import sszt.friends.command.FriendsEndCommand;
	import sszt.friends.command.FriendsStartCommand;
	import sszt.friends.events.FriendsMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class FriendsFacade extends Facade
	{
		public var _key:String;
		public var _friendsModule:FriendsModule;
		
		public function FriendsFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):FriendsFacade
		{
			if(!instanceMap[key])
			{
				instanceMap[key] = new FriendsFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(FriendsMediatorEvent.FRIENDS_START_COMMAND,FriendsStartCommand);
			registerCommand(FriendsMediatorEvent.FRIENDS_END_COMMAND,FriendsEndCommand);
		}
		
		public function startup(module:FriendsModule,data:Object):void
		{
			_friendsModule = module;
			sendNotification(FriendsMediatorEvent.FRIENDS_START_COMMAND,module);
//			sendNotification(FriendsMediatorEvent.FRIENDS_START,data);			
		}
		
		public function dispose():void
		{
			sendNotification(FriendsMediatorEvent.FRIENDS_END_COMMAND);
			sendNotification(FriendsMediatorEvent.FRIENDS_DISPOSE);
			removeCommand(FriendsMediatorEvent.FRIENDS_START_COMMAND);
			removeCommand(FriendsMediatorEvent.FRIENDS_END_COMMAND);
			_friendsModule = null;
			instanceMap[_key] = null;
		}		
		
	}
}