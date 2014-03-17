package sszt.chat
{
	import sszt.chat.commands.ChatEndCommand;
	import sszt.chat.commands.ChatStartCommand;
	import sszt.chat.events.ChatMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ChatFacade extends Facade
	{
		public static function getInstance(key:String):ChatFacade
		{
			if(!(instanceMap[key] is ChatFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new ChatFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var chatModule:ChatModule;
		
		public function ChatFacade(key:String)
		{
			_key = key;
			super(_key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(ChatMediatorEvent.CHAT_COMMAND_START,ChatStartCommand);
			registerCommand(ChatMediatorEvent.CHAT_COMMAND_END,ChatEndCommand);
		}
		
		public function setup(module:ChatModule):void
		{
			chatModule = module;
			sendNotification(ChatMediatorEvent.CHAT_COMMAND_START,module);
			sendNotification(ChatMediatorEvent.CHAT_MEDIATOR_START);
		}
		
		public function dispose():void
		{
			sendNotification(ChatMediatorEvent.CHAT_MEDIATOR_DISPOSE);
			sendNotification(ChatMediatorEvent.CHAT_COMMAND_END);
			removeCommand(ChatMediatorEvent.CHAT_COMMAND_START);
			removeCommand(ChatMediatorEvent.CHAT_COMMAND_END);
			delete instanceMap[_key];
			chatModule = null;
		}
	}
}