package sszt.chat
{
	import flash.events.Event;
	
	import sszt.chat.components.ChatController;
	import sszt.chat.components.ChatPanel;
	import sszt.chat.components.ChatSpeakerPanel;
	import sszt.chat.components.SysMessagePanel;
	import sszt.chat.components.SysNoticePanel;
	import sszt.chat.components.clubChat.ClubChatIconView;
	import sszt.chat.components.clubChat.ClubChatPanel;
	import sszt.chat.components.sec.PrivateChatPanel;
	import sszt.chat.events.ChatMediatorEvent;
	import sszt.chat.mediators.ChatMediator;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.data.systemMessage.SystemMessageType;
	import sszt.core.module.BaseModule;
	import sszt.events.ChatModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.module.IModule;
	import sszt.module.ModuleEventDispatcher;
	
	public class ChatModule extends BaseModule
	{
		public var chatPanel:ChatPanel;
		public var chatController:ChatController;
		public var chatSpeakerPanel:ChatSpeakerPanel;
		public var privatePanel:PrivateChatPanel;
		public var sysMessagePanel:SysMessagePanel;
		public var sysNoticePanel:SysNoticePanel;
		
		public var clubChatPanel:ClubChatPanel;
		public var clubChatIcon:ClubChatIconView;
		
		public var facade:ChatFacade;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			
			mouseEnabled = false;
			
			facade = ChatFacade.getInstance(String(moduleId));
			facade.setup(this);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addChatEventListener(ChatModuleEvent.ADD_ITEM,addItemHandler);
			ModuleEventDispatcher.addChatEventListener(ChatModuleEvent.APPEND_MESSAGE,appendMessageHandler);
			ModuleEventDispatcher.addChatEventListener(ChatModuleEvent.ADD_PET,addPetHandler);
			ModuleEventDispatcher.addChatEventListener(ChatModuleEvent.ADD_MOUNT,addMountHandler);
			ModuleEventDispatcher.addChatEventListener(ChatModuleEvent.ADD_PLAYER_NOTICE,addPlayerNoticeHandler);
			ModuleEventDispatcher.addChatEventListener(ChatModuleEvent.NEW_CLUB_MESSAGE, newClubMessageHandler);
			ModuleEventDispatcher.addChatEventListener(ChatModuleEvent.SHOW_CLUB_CHAT, showClubChatHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			ModuleEventDispatcher.removeChatEventListener(ChatModuleEvent.ADD_ITEM,addItemHandler);
			ModuleEventDispatcher.removeChatEventListener(ChatModuleEvent.APPEND_MESSAGE,appendMessageHandler);
			ModuleEventDispatcher.removeChatEventListener(ChatModuleEvent.ADD_PET,addPetHandler);
			ModuleEventDispatcher.removeChatEventListener(ChatModuleEvent.ADD_MOUNT,addMountHandler);
			ModuleEventDispatcher.removeChatEventListener(ChatModuleEvent.ADD_PLAYER_NOTICE,addPlayerNoticeHandler);
			ModuleEventDispatcher.removeChatEventListener(ChatModuleEvent.NEW_CLUB_MESSAGE, newClubMessageHandler);
			ModuleEventDispatcher.removeChatEventListener(ChatModuleEvent.SHOW_CLUB_CHAT, showClubChatHandler);
		}
		
		private function newClubMessageHandler(event:ChatModuleEvent) : void
		{
			facade.sendNotification(ChatMediatorEvent.NEW_CLUB_MESSAGE, event.data);
		}
		
		private function showClubChatHandler(event:ChatModuleEvent) : void
		{
			facade.sendNotification(ChatMediatorEvent.SHOW_CLUB_CHAT);
		}
		private function addPetHandler(evt:ChatModuleEvent):void
		{
			facade.sendNotification(ChatMediatorEvent.ADD_PET,evt.data);
		}
		
		private function addMountHandler(evt:ChatModuleEvent):void
		{
			facade.sendNotification(ChatMediatorEvent.ADD_MOUNT,evt.data);
		}
		
		private function addPlayerNoticeHandler(evt:ChatModuleEvent):void
		{
			facade.sendNotification(ChatMediatorEvent.ADD_PLAYER_NOTICE,evt.data);
		}
		
		private function addItemHandler(e:ChatModuleEvent):void
		{
			facade.sendNotification(ChatMediatorEvent.ADD_ITEM,e.data);
		}
		
		private function appendMessageHandler(e:ChatModuleEvent):void
		{
			facade.sendNotification(ChatMediatorEvent.APPEND_MESSAGE,e.data);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.CHAT;
		}
		
		override public function dispose():void
		{
			if(chatPanel)
			{
				chatPanel.dispose();
				chatPanel = null;
			}
			if(chatController)
			{
				chatController.dispose();
				chatController = null;
			}
			if(chatSpeakerPanel)
			{
				chatSpeakerPanel.dispose();
				chatSpeakerPanel = null;
			}
			if(privatePanel)
			{
				privatePanel.dispose();
				privatePanel = null;
			}
			if(sysNoticePanel)
			{
				sysNoticePanel.dispose();
				sysNoticePanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			super.dispose();
		}
	}
}