package sszt.chat.mediators
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.chat.ChatModule;
	import sszt.chat.components.ChatController;
	import sszt.chat.components.ChatPanel;
	import sszt.chat.components.ChatSpeakerPanel;
	import sszt.chat.components.SysMessagePanel;
	import sszt.chat.components.SysNoticePanel;
	import sszt.chat.components.clubChat.ClubChatIconView;
	import sszt.chat.components.clubChat.ClubChatPanel;
	import sszt.chat.components.sec.PrivateChatPanel;
	import sszt.chat.events.ChatMediatorEvent;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.socketHandlers.chat.ChatSockethandler;
	
	public class ChatMediator extends Mediator
	{
		public static const NAME:String = "chatMediator";
		
		public function ChatMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ChatMediatorEvent.CHAT_MEDIATOR_START,
				ChatMediatorEvent.ADD_ITEM,
				ChatMediatorEvent.ADD_PET,
				ChatMediatorEvent.ADD_MOUNT,
				ChatMediatorEvent.APPEND_MESSAGE,
				ChatMediatorEvent.ADD_PLAYER_NOTICE,
				ChatMediatorEvent.SHOW_CLUB_CHAT,
				ChatMediatorEvent.NEW_CLUB_MESSAGE,
				ChatMediatorEvent.CHAT_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ChatMediatorEvent.CHAT_MEDIATOR_START:
					init();
					break;
				case ChatMediatorEvent.ADD_ITEM:
					addItem(notification.getBody() as ItemInfo);
					break;
				case ChatMediatorEvent.ADD_MOUNT:
					addMount(notification.getBody() as MountsItemInfo);
					break;
				case ChatMediatorEvent.ADD_PET:
					addPet(notification.getBody() as PetItemInfo);
					break;
				case ChatMediatorEvent.APPEND_MESSAGE:
					appendMessage(notification.getBody() as ChatItemInfo);
					break;
				case ChatMediatorEvent.ADD_PLAYER_NOTICE:
					appendPlayerNotice(notification.getBody() as String);
					break;
				case ChatMediatorEvent.SHOW_CLUB_CHAT:
					showClubChat();
					break;
				case ChatMediatorEvent.NEW_CLUB_MESSAGE:
				{
					newClubMessageHandler();
					break;
				}
				case ChatMediatorEvent.CHAT_MEDIATOR_DISPOSE:
					dispose();
					break;
				
			}
		}
		
		private function init():void
		{
			if(chatModule.chatPanel == null)
			{
				chatModule.chatPanel = new ChatPanel(this);
				chatModule.addChild(chatModule.chatPanel);
			}
			if(chatModule.chatController == null)
			{
				chatModule.chatController = new ChatController(this);
				chatModule.addChild(chatModule.chatController);
			}
			if(chatModule.chatSpeakerPanel == null)
			{
				chatModule.chatSpeakerPanel = new ChatSpeakerPanel(this,GlobalAPI.layerManager.getTipLayer());
			}
			if(chatModule.sysMessagePanel == null)
			{
				chatModule.sysMessagePanel = new SysMessagePanel(GlobalAPI.layerManager.getTipLayer());
			}
			if(chatModule.sysNoticePanel == null)
			{
				chatModule.sysNoticePanel = new SysNoticePanel(GlobalAPI.layerManager.getTipLayer());
			}
		}
		
		public function showPrivatePanel():void
		{
			if(chatModule.privatePanel == null)
			{
				chatModule.privatePanel = new PrivateChatPanel(this);
				chatModule.privatePanel.addEventListener(Event.CLOSE,privateCloseHandler);
				GlobalAPI.layerManager.addPanel(chatModule.privatePanel);
			}
		}
		private function privateCloseHandler(e:Event):void
		{
			if(chatModule.privatePanel)
			{
				chatModule.privatePanel.removeEventListener(Event.CLOSE,privateCloseHandler);
				chatModule.privatePanel = null;
			}
		}
		
		public function showClubChatIcon(isFlash:Boolean):void{
			if (chatModule.clubChatIcon == null){
				chatModule.clubChatIcon = new ClubChatIconView(this);
			}
			if (chatModule.clubChatIcon.parent == null){
				chatModule.clubChatIcon.show(isFlash);
			}
		}
		private function showClubChat():void{
			if (chatModule.clubChatPanel == null)
			{
				chatModule.clubChatPanel = new ClubChatPanel(this);
				chatModule.clubChatPanel.addEventListener(Event.CLOSE, clubChatPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(chatModule.clubChatPanel);
			} 
			else 
			{
				GlobalAPI.layerManager.addPanel(chatModule.clubChatPanel);
			}
			if (chatModule.clubChatIcon && chatModule.clubChatIcon.parent)
			{
				chatModule.clubChatIcon.hide();
			}
		}
		
		private function newClubMessageHandler():void{
			if (!(chatModule.clubChatPanel && chatModule.clubChatPanel.parent))
			{
				if (chatModule.clubChatIcon == null){
					chatModule.clubChatIcon = new ClubChatIconView(this);
				}
				GlobalData.clubChatInfo.unReadCount++;
				if (chatModule.clubChatIcon.parent == null){
					chatModule.clubChatIcon.show(GlobalData.clubChatInfo.isFlash, 1);
				} 
				else {
					chatModule.clubChatIcon.setUnReadCount(GlobalData.clubChatInfo.unReadCount);
				}
			}
		}
		private function clubChatPanelCloseHandler(evt:Event):void{
			if (chatModule.clubChatPanel){
				chatModule.clubChatPanel.addEventListener(Event.CLOSE, clubChatPanelCloseHandler);
				chatModule.clubChatPanel = null;
			}
		}
		
		public function sendMessage(channel:int,message:String,toNick:String = "",toId:Number = 0):void
		{
			ChatSockethandler.sendMessage(channel,message,toNick,toId);
		}
		
		private function addItem(item:ItemInfo):void
		{
			chatModule.chatController.addItemToField(item);
		}
		
		private function addMount(mount:MountsItemInfo):void
		{
			chatModule.chatController.addMountToField(mount);
		}
		
		private function addPet(pet:PetItemInfo):void
		{
			chatModule.chatController.addPetToField(pet);
		}
		
//		private function appendMessage(info:ChatItemInfo):void
//		{
//			GlobalData.chatInfo.appendMessage(info);
//			if(info.type == MessageType.SYSTEM && chatModule.sysMessagePanel)
//				chatModule.sysMessagePanel.appendMessage(info.message);
//			else if(info.type == MessageType.NOTICE && chatModule.sysNoticePanel)
//				chatModule.sysNoticePanel.appendMessage(info.message);
//		}
		
		private function appendMessage(info:ChatItemInfo) : void
		{
			if (info.type == MessageType.SYSTEM_FLOAT)
			{
				if (chatModule.sysMessagePanel)
				{
					chatModule.sysMessagePanel.appendMessage(info.message);
				}
			}
			else
			{
				GlobalData.chatInfo.appendMessage(info);
				if (info.type == MessageType.SYSTEM && chatModule.sysMessagePanel)
				{
					chatModule.sysMessagePanel.appendMessage(info.message);
				}
				else
				{
					if (info.type == MessageType.SYSTEM_WORLD && chatModule.sysMessagePanel)
					{
						chatModule.sysMessagePanel.appendMessage(info.message);
					}
					else
					{
						
						if (info.type == MessageType.NOTICE && chatModule.sysNoticePanel)
						{
							chatModule.sysNoticePanel.appendMessage(info.message);
						}
					}
				}
			}
		}
		
		
		//玩家行为公告
		private function appendPlayerNotice(info:String):void
		{
			chatModule.sysMessagePanel.appendMessage(info);
		}
		
		public function updatePanelVisible(value:Boolean):void
		{
			if(chatModule.chatPanel)
			{
				chatModule.chatPanel.updatePanelVisible(value);
			}
			if(chatModule.chatSpeakerPanel)
				chatModule.chatSpeakerPanel.updatePanelVisible(value);
		}
		
		
		public function setPanelSize(value:Boolean):void
		{
			if(chatModule.chatPanel)
				chatModule.chatPanel.setPanelSize(value);
			if(chatModule.chatSpeakerPanel)
				chatModule.chatSpeakerPanel.setPanelSize(value);
		}
		
		
		
		public function setToNick(nick:String):void
		{
			chatModule.chatController.setToNick(nick);
		}
		
		public function get chatModule():ChatModule
		{
			return viewComponent as ChatModule;
		}
		
		private function dispose():void
		{
			viewComponent = null;
		}
	}
}