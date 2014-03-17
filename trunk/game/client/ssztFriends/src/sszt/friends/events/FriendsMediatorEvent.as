package sszt.friends.events
{
	import flash.events.Event;
	
	public class FriendsMediatorEvent extends Event
	{
		public static const FRIENDS_MOVEPANEL_START:String = "friensMovePanelStart"
		public static const FRIENDS_CHATPANEL_START:String = "friendChatPanelStart";
		public static const FRIENDS_MAX_CHATPANEL:String = "friendsMaxChatPanel";
		public static const FRIENDS_IMPANEL_START:String = "friendsImPanelstart";
		public static const FRIENDS_START_COMMAND:String = "friendsStartCommand";
		public static const FRIENDS_END_COMMAND:String = "friendsEndCommand";
		public static const FRIENDS_DISPOSE:String = "friendsDispose";
		public static const SHOW_GIVE_FLOWERS_PANEL:String = "showGiveFlowers";
		public static const SHOW_RECEIVE_FLOWERS_PANEL:String = "showReceiveFlowers";
		public function FriendsMediatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}