package sszt.events
{
	import flash.events.Event;
	
	public class FriendModuleEvent extends Event
	{
		public static const SHOW_IMPANEL:String = "showIMPannel";
		
		public static const SHOW_CHATPANEL:String = "showChatPanel";
		
		public static const SHOW_MOVE_PANEL:String ="showMovePanel";
		
		public static const MAX_CHAT_PANEL:String = "maxChatPanel";
		
		public static const SHOW_GIVE_FLOWERS_PANEL:String = "showGiveFlowers";
		
		public static const SHOW_RECEIVE_FLOWERS_PANEL:String = "showReceiveFlowers";
		
		/**
		 * 购买鲜花 
		 */		
		public static const BUY_FLOWERS:String = "buyFlowers";
		
		/**
		 * 赠送鲜花 
		 */		
		public static const GIVE_FLOWERS:String = "giveFlowers"; 
		
		public var data:Object;
		
		public function FriendModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}