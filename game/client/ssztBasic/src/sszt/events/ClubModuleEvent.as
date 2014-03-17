package sszt.events
{
	import flash.events.Event;
	
	public class ClubModuleEvent extends Event
	{
		/**
		 * 打开创建帮会面板
		 */		
		public static const SHOW_CREATE_CLUB:String = "showCreateClub";
		/**
		 * 打开帮会列表
		 */		
		public static const SHOW_CLUBLIST:String = "showClubList";
		/**
		 *宣战请求 
		 */		
		public static const SHOW_CLUB_WAR_REQUEST:String = "showClubWarRequest";
		/**
		 *踢出帮会 
		 */		
		public static const CLUB_KICK:String = "clubKickOut";
		/**
		 *帮会转移 
		 */		
		public static const CLUB_TRANSFER:String = "clubTransfer";
		
		public static const CLUB_UPDATE_NOTICE:String = "clubUpdateNotice";
		
		public var data:Object;
		
		public function ClubModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}