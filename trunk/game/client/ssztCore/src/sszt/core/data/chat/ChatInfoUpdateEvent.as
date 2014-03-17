package sszt.core.data.chat
{
	import flash.events.Event;
	
	public class ChatInfoUpdateEvent extends Event
	{
		/**
		 * 添加消息
		 */		
		public static const ADD_MESSAGE:String = "addMessage";
		
		
		public static const CHANNEL_CHANGE:String = "channelChange";
		
		public static const SPEAKERPANEL_UPDATE:String = "speakerPanelUpdate";
		
		public static const ADD_GROUP_CHATINFO:String = "addGroupChatInfo";
		
		public static const ADD_CLUB_CHATINFO:String = "addClubChatInfo";
		
		public var data:Object;
		
		public function ChatInfoUpdateEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}