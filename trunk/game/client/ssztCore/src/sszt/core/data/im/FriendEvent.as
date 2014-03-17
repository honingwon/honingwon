package sszt.core.data.im
{
	import flash.events.Event;
	
	public class FriendEvent extends Event
	{
		public static const ADD_FRIEND:String = "add friend";
		public static const DELETE_FRIEND:String = "delete friend";
		public static const ADD_BLACK:String = "add black";
		public static const DELETE_BLACK:String = "delete black";
		public static const ADD_ENEMY:String = "add enemy";
		public static const DELETE_ENEMY:String = "delete enemy";
		public static const CHATINFO_UPDATE:String = "chatinfo update";
		public static const ADD_GROUP:String = "add group";
		public static const GROUP_RENAME:String = "group rename";
		public static const DELETE_GROUP:String = "delete group";
		public static const FRIEDN_GROUP_MOVE:String = "friend group move";
//		public static const START_CHAT:String = "start chat";
		public static const SHOW_MOVE_PANEL:String ="show move panel";
		public static const QUERY_RETURN:String = "query return";
		public static const ONLINE_CHANGE:String = "online change";
		public static const SET_CHANGE:String = "set up change";
		public static const REMOVE_CHHATPANEL:String = "remove chatpanel";
		public static const ADD_STRANGER:String = "addStranger";
		public static const REMOVE_STRANGER:String = "removeStranger";
		public static const ADD_RECENR:String = "addRecent";
		public static const REMOVE_RECENT:String = "removeRecent";
		public static const SET_READ:String = "setRead";
		public static const NEW_RECENT:String = "newRecent";
		public static const CHAT_PLAYER_CHANGE:String = "chatPlayerChange";
		public static const DELETE_CHATPANEL:String = "deleteChatPanel";
		public static const ADD_FACE:String = "addFace";
		public var data:Object;
		public function FriendEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}