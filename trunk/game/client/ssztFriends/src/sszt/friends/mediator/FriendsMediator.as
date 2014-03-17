package sszt.friends.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.ImMessage;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.FlashIcon;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.friends.FriendsModule;
	import sszt.friends.component.ChatPanel;
	import sszt.friends.component.ConfigurePanel;
	import sszt.friends.component.MainPanel;
	import sszt.friends.component.MoveChosePanel;
	import sszt.friends.component.SearchPanel;
	import sszt.friends.component.friendship.FriendshipPanel;
	import sszt.friends.component.giveFlowers.GiveFlowersPanel;
	import sszt.friends.component.receiveRose.ReceiveRosePanel;
	import sszt.friends.events.FriendsMediatorEvent;
	import sszt.ui.event.CloseEvent;
	
	public class FriendsMediator extends Mediator
	{
		public static const NAME:String = "friends mediator";
		public function FriendsMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get friendsModule():FriendsModule
		{
			return viewComponent as FriendsModule;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				FriendsMediatorEvent.FRIENDS_DISPOSE,
				FriendsMediatorEvent.FRIENDS_IMPANEL_START,
				FriendsMediatorEvent.FRIENDS_CHATPANEL_START,
				FriendsMediatorEvent.FRIENDS_MOVEPANEL_START,
				FriendsMediatorEvent.FRIENDS_MAX_CHATPANEL,
				FriendsMediatorEvent.SHOW_GIVE_FLOWERS_PANEL,
				FriendsMediatorEvent.SHOW_RECEIVE_FLOWERS_PANEL
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch (notification.getName())
			{
				case FriendsMediatorEvent.FRIENDS_CHATPANEL_START:
					showChatPanel(data.serverId,data.id,data.flag,data.nick,data.level,data.career);
					break;
				case FriendsMediatorEvent.FRIENDS_IMPANEL_START:
					showMainPanel();
					break;
				case FriendsMediatorEvent.FRIENDS_MOVEPANEL_START:
					showMoveChosePanel(data.gid,data.id);
					break;
				case FriendsMediatorEvent.FRIENDS_DISPOSE:
					dispose();
					break;
				case FriendsMediatorEvent.FRIENDS_MAX_CHATPANEL:
					showChatPanel(data.serverId,data.id,data.flag,data.nick,data.level);
					break;
				case FriendsMediatorEvent.SHOW_GIVE_FLOWERS_PANEL:
					showGiveFlowersPanel(data.id,data.nick);
					break;
				case FriendsMediatorEvent.SHOW_RECEIVE_FLOWERS_PANEL:
					showReceiveRosePanel(data.senderId,data.sender,data.type,data.count);
					break;
			}
		}
		
		public function showMainPanel():void
		{
			if(friendsModule.mainPanel == null)
			{
				friendsModule.mainPanel = new MainPanel(this);
				GlobalAPI.layerManager.addPanel(friendsModule.mainPanel);
				friendsModule.mainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
			}else
			{
				friendsModule.mainPanel.dispose();
				friendsModule.mainPanel = null;
			}
		}
		
		private function mainPanelCloseHandler(evt:Event):void
		{
			if(friendsModule.mainPanel)
			{
				friendsModule.mainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
				friendsModule.mainPanel = null;
			}
		}
		
		/**
		 * 
		 * @param id 玩家ID
		 * @param flag  0是被动弹框，1是主动弹框
		 * @param nick  玩家昵称
		 * 
		 */		
		public function showChatPanel(serverId:int,id:Number,flag:int,nick:String = "",level:int=0,career:int=1):void
		{
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				return;
			}
			var player:ImPlayerInfo = GlobalData.imPlayList.getPlayer(id);
			if(player == null)
			{
				player = new ImPlayerInfo();
				player.friendState = (1<<11);
				player.info.serverId = serverId;
				player.info.userId = id;
				player.info.nick = nick;
				player.info.level = level;
				player.online = 1;
				player.career = career;
				GlobalData.imPlayList.addStranger(player);
//				GlobalData.imPlayList.addRecent(player);
			}
			else
				player.info.level = level;
			if(!GlobalData.imPlayList.getRecent(id))
			{
				GlobalData.imPlayList.addRecent(player);
			}
			if(flag == 1)
			{
				if(friendsModule.chatPanelList[player.info.userId] == null)
				{
					friendsModule.chatPanelList[player.info.userId] = new ChatPanel(this,player);
					friendsModule.chatPanelList[player.info.userId].addEventListener(FriendEvent.REMOVE_CHHATPANEL,chatPanelCloseHandler);
//					GlobalData.friendIconList.removeIcon(player.info.userId);
					player.setRead();
				}
				GlobalAPI.layerManager.addPanel(friendsModule.chatPanelList[player.info.userId]);
				GlobalData.friendIconList.removeIcon(id);
			}else
			{
				if(friendsModule.chatPanelList[player.info.userId] && friendsModule.chatPanelList[player.info.userId].parent)
				{
					player.records[player.records.length -1].type = ImMessage.READ;
				}
				else if(friendsModule.chatPanelList[player.info.userId])
				{
					player.records[player.records.length -1].type = ImMessage.UNREAD_ONE;
					var icon:FlashIcon = new FlashIcon(player.info.serverId,player.info.userId,player.info.nick);
					GlobalData.friendIconList.addItem(icon);
					icon.isRead = false;
				}else
				{
					player.records[player.records.length -1].type = ImMessage.UNREAD_TWO;
					icon = new FlashIcon(player.info.serverId,player.info.userId,player.info.nick);
					GlobalData.friendIconList.addItem(icon);
					icon.isRead = false;
				}
			}
		}
		
		private function chatPanelCloseHandler(evt:FriendEvent):void
		{
			var id:Number = evt.data as Number;
			if(friendsModule.chatPanelList[id])
			{
				friendsModule.chatPanelList[id].removeEventListener(FriendEvent.REMOVE_CHHATPANEL,chatPanelCloseHandler);
				friendsModule.chatPanelList[id] = null;
			}
		}
		
		public function showConfigurePanel():void
		{
			if(friendsModule.configurePanel == null)
			{
				friendsModule.configurePanel = new ConfigurePanel(this);
				GlobalAPI.layerManager.addPanel(friendsModule.configurePanel);
				friendsModule.configurePanel.addEventListener(Event.CLOSE,configurePanelCloseHandler);
			}
		}
		
		private function configurePanelCloseHandler(evt:Event):void
		{
			if(friendsModule.configurePanel)
			{
				friendsModule.configurePanel.removeEventListener(Event.CLOSE,configurePanelCloseHandler);
				friendsModule.configurePanel = null;
			}
		}
		
		public function showSearchPanel():void
		{
			if(friendsModule.searchPanel == null)
			{
				friendsModule.searchPanel = new SearchPanel(this);
				GlobalAPI.layerManager.addPanel(friendsModule.searchPanel);
				friendsModule.searchPanel.addEventListener(Event.CLOSE,searchPanelCloseHandler);
			}
		}
		
		private function searchPanelCloseHandler(evt:Event):void
		{
			if(friendsModule.searchPanel)
			{
				friendsModule.searchPanel.removeEventListener(Event.CLOSE,searchPanelCloseHandler);
				friendsModule.searchPanel = null;
			}
		}
		
		public function showFriendShipPanel():void
		{
			if(friendsModule.friendshipPanel == null)
			{
				friendsModule.friendshipPanel = new FriendshipPanel(this);
				GlobalAPI.layerManager.addPanel(friendsModule.friendshipPanel);
				friendsModule.friendshipPanel.addEventListener(Event.CLOSE,friendshipPanelCloseHandler);
			}
		}
		
		private function friendshipPanelCloseHandler(evt:Event):void
		{
			if(friendsModule.friendshipPanel)
			{
				friendsModule.friendshipPanel.removeEventListener(Event.CLOSE,friendshipPanelCloseHandler);
				friendsModule.friendshipPanel = null;
			}
		}
		
		public function showGiveFlowersPanel(id:Number,nick:String):void
		{
			if(friendsModule.giveFlowersPanel == null)
			{
				var player:ImPlayerInfo = GlobalData.imPlayList.getPlayer(id);
				friendsModule.giveFlowersPanel = new GiveFlowersPanel(this,player);
				GlobalAPI.layerManager.addPanel(friendsModule.giveFlowersPanel);
				friendsModule.giveFlowersPanel.addEventListener(Event.CLOSE,giveFlowersPanelCloseHandler);
			}
			else
			{
				friendsModule.giveFlowersPanel.removeEventListener(Event.CLOSE,giveFlowersPanelCloseHandler);
				friendsModule.giveFlowersPanel.dispose();
				friendsModule.giveFlowersPanel = null;
			}
		}
		
		private function giveFlowersPanelCloseHandler(evt:Event):void
		{
			if(friendsModule.giveFlowersPanel)
			{
				friendsModule.giveFlowersPanel.removeEventListener(Event.CLOSE,giveFlowersPanelCloseHandler);
				friendsModule.giveFlowersPanel.dispose();
				friendsModule.giveFlowersPanel = null;
			}
		}
		
		public function showReceiveRosePanel(senderId:int,sender:String,type:int,count:int):void
		{
			if(friendsModule.receiveRosePanel == null)
			{
				friendsModule.receiveRosePanel = new ReceiveRosePanel(senderId,sender,type,count);
				GlobalAPI.layerManager.addPanel(friendsModule.receiveRosePanel);
				friendsModule.receiveRosePanel.addEventListener(Event.CLOSE,receiveRosePanelCloseHandler);
			}
			else
			{
				friendsModule.receiveRosePanel.removeEventListener(Event.CLOSE,receiveRosePanelCloseHandler);
				friendsModule.receiveRosePanel = null;
			}
		}
		
		private function receiveRosePanelCloseHandler(evt:Event):void
		{
			if(friendsModule.receiveRosePanel)
			{
				friendsModule.receiveRosePanel.removeEventListener(Event.CLOSE,receiveRosePanelCloseHandler);
				friendsModule.receiveRosePanel = null;
			}
		}
		
		public function showMoveChosePanel(gid:int,id:Number):void
		{
			friendsModule.moveChosePanel = new MoveChosePanel(this,gid,id);
			GlobalAPI.layerManager.addPanel(friendsModule.moveChosePanel);
			friendsModule.moveChosePanel.addEventListener(Event.CLOSE,moveChosePanelCloseHandler);
		}
		
		private function moveChosePanelCloseHandler(evt:Event):void
		{
			if(friendsModule.moveChosePanel)
			{
				friendsModule.moveChosePanel.removeEventListener(Event.CLOSE,moveChosePanelCloseHandler);
				friendsModule.moveChosePanel = null;
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
		
	}
}