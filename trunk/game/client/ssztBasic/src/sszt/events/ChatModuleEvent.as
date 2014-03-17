package sszt.events
{
	import flash.events.Event;
	
	public class ChatModuleEvent extends Event
	{
		/**
		 * 聊天界面添加物品展示
		 */		
		public static const ADD_ITEM:String = "addItem";
		/**
		 * 添加聊天消息
		 */		
		public static const APPEND_MESSAGE:String = "appendMessage";
		/**
		 * 聊天界面添加宠物展示
		 */
		public static const ADD_PET:String = "addPet";
		
		/**
		 * 聊天界面添加坐骑展示
		 */
		public static const ADD_MOUNT:String = "addMount";
		
		/**
		 * 添加玩家行为公告
		 */
		public static const ADD_PLAYER_NOTICE:String = "addPlayerNotice";
		
		
		public static const NEW_CLUB_MESSAGE:String =  "newClubMessage";
		
		public static const SHOW_CLUB_CHAT:String =  "showClubChat";
		
		public var data:Object;
		
		public function ChatModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}