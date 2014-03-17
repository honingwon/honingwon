package sszt.friends
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.module.ModuleType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.module.BaseModule;
	import sszt.events.FriendModuleEvent;
	import sszt.friends.component.ChatPanel;
	import sszt.friends.component.ConfigurePanel;
	import sszt.friends.component.MainPanel;
	import sszt.friends.component.MoveChosePanel;
	import sszt.friends.component.SearchPanel;
	import sszt.friends.component.friendship.FriendshipPanel;
	import sszt.friends.component.giveFlowers.GiveFlowersPanel;
	import sszt.friends.component.receiveRose.ReceiveRosePanel;
	import sszt.friends.events.FriendsMediatorEvent;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.module.IModule;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 锻造 
	 * @author chendong
	 * 
	 */	
	public class FriendsModule extends BaseModule
	{
		public var mainPanel:MainPanel;
		public var configurePanel:ConfigurePanel;
		public var searchPanel:SearchPanel;
		public var moveChosePanel:MoveChosePanel;
		public var chatPanelList:Dictionary;
		/**
		 *自动回复设置 
		 */		
		public var autoReply:Boolean;
		public var replyContext:String;
		public var facade:FriendsFacade;
		public var posX:int = 379;
		public var posY:int = 78;
		
		/**
		 * 好友度面板 
		 */		
		public var friendshipPanel:FriendshipPanel;
		/**
		 * 赠送鲜花面板 
		 */		
		public var giveFlowersPanel:GiveFlowersPanel;
		/**
		 * 回赠鲜花面板 
		 */		
		public var receiveRosePanel:ReceiveRosePanel;
			
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			chatPanelList = new Dictionary();
			autoReply = false;
			replyContext =LanguageManager.getWord("ssztl.friends.inbusyness");
			facade = FriendsFacade.getInstance(String(moduleId));			
			facade.startup(this,data);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.SHOW_IMPANEL,showImPanelHandler);
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.SHOW_CHATPANEL,showChatPanelHandler);
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.SHOW_MOVE_PANEL,showMovePanelHandler);
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.MAX_CHAT_PANEL,maxChatPanelHandler);
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.SHOW_GIVE_FLOWERS_PANEL,giveFlowersPanelHandler);
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.SHOW_RECEIVE_FLOWERS_PANEL,receiveRosePanelHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.SHOW_IMPANEL,showImPanelHandler);
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.SHOW_CHATPANEL,showChatPanelHandler);
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.SHOW_MOVE_PANEL,showMovePanelHandler);
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.MAX_CHAT_PANEL,maxChatPanelHandler);
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.SHOW_GIVE_FLOWERS_PANEL,giveFlowersPanelHandler);
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.SHOW_RECEIVE_FLOWERS_PANEL,receiveRosePanelHandler);
		}
		
		private function maxChatPanelHandler(evt:FriendModuleEvent):void
		{
//			var id:Number = evt.data as Number;
			facade.sendNotification(FriendsMediatorEvent.FRIENDS_MAX_CHATPANEL,{serverId:evt.data.serverId,id:evt.data.id,flag:1,nick:""});
		}
		
		private function giveFlowersPanelHandler(evt:FriendModuleEvent):void
		{
			facade.sendNotification(FriendsMediatorEvent.SHOW_GIVE_FLOWERS_PANEL,evt.data);
		}
		
		private function receiveRosePanelHandler(evt:FriendModuleEvent):void
		{
			facade.sendNotification(FriendsMediatorEvent.SHOW_RECEIVE_FLOWERS_PANEL,evt.data);
		}
		
		public function setChange(auto:Boolean,str:String):void
		{
			autoReply = auto;
			replyContext = str;
			dispatchEvent(new FriendEvent(FriendEvent.SET_CHANGE,{auto:auto,replyContext:replyContext}));
		}
		
		private function showImPanelHandler(evt:FriendModuleEvent):void
		{
			facade.sendNotification(FriendsMediatorEvent.FRIENDS_IMPANEL_START);
		}
		
		private function showChatPanelHandler(evt:FriendModuleEvent):void
		{
			facade.sendNotification(FriendsMediatorEvent.FRIENDS_CHATPANEL_START,evt.data);
		}
		
		private function showMovePanelHandler(evt:FriendModuleEvent):void
		{
			facade.sendNotification(FriendsMediatorEvent.FRIENDS_MOVEPANEL_START,evt.data);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.FRIENDS;
		}
		
		override public function dispose():void
		{
			if(mainPanel)
			{
				mainPanel.dispose();
				mainPanel = null;
			}
			if(configurePanel)
			{
				configurePanel.dispose();
				configurePanel = null;
			}
			if(searchPanel)
			{
				searchPanel.dispose();
				searchPanel = null;
			}
			if(chatPanelList)
			{
				for each(var i:ChatPanel in chatPanelList)
				{
					i.dispose();
				}
				chatPanelList = null;
			}
			if(moveChosePanel)
			{
				moveChosePanel.dispose();
				moveChosePanel = null;
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