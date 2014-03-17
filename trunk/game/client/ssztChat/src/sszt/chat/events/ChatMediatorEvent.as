package sszt.chat.events
{
	public class ChatMediatorEvent
	{
		public static const CHAT_COMMAND_START:String = "chatCommandStart";
		public static const CHAT_COMMAND_END:String = "chatCommandEnd";
		
		public static const CHAT_MEDIATOR_START:String = "chatMediatorStart";
		public static const CHAT_MEDIATOR_DISPOSE:String = "chatMediatorDispose";
		/**
		 * 添加物品展示
		 */		
		public static const ADD_ITEM:String = "addItem";
		/**
		 * 添加宠物展示 
		 */
		public static const ADD_PET:String = "addPet";
		/**
		 * 添加坐骑展示 
		 */
		public static const ADD_MOUNT:String = "addMount";
		/**
		 * 添加聊天消息
		 */		
		public static const APPEND_MESSAGE:String = "appendMessage";
		/**
		 * 添加玩家行为公告
		 */
		public static const ADD_PLAYER_NOTICE:String = "addPlayerNotice";
		
		/**
		 * 显示帮会聊天 
		 */		
		public static const SHOW_CLUB_CHAT:String = "showClubChat";
		
		public static const NEW_CLUB_MESSAGE:String = "newClubMessage";
		
		public function ChatMediatorEvent()
		{
		}
	}
}