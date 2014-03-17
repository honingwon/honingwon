package sszt.core.data.quickIcon
{
	import flash.events.Event;
	
	public class QuickIconInfoEvent extends Event
	{
		public static const CLUB_NEWCOMER_ICON_ADD:String = "clubNewcomerIconAdd";
		public static const CLUB_NEWCOMER_ICON_REMOVE:String = "clubNewcomerIconRemove";
//		public static const CLUB_NEWCOMER_ICON_CHANGE:String = "clubNewcomerListChange";
		
		public static const FRIEND_ICON_ADD:String = "friendIconAdd";
		public static const FRIEND_ICON_REMOVE:String = "friendIconRemove";
		public static const FRIEND_ICON_CHANGE:String = "friendListChange";
		
		public static const TRADE_ICON_ADD:String = "tradeIconAdd";
		public static const TRADE_ICON_REMOVE:String = "tradeIconRemove";
		
		public static const DOUBLESIT_ICON_ADD:String = "doubleSitIconAdd";
		public static const DOUBLESIT_REMOVE:String = "doubleSitIconRemove";
		
		public static const CLUB_ICON_ADD:String = "clubIconAdd";
		public static const CLUB_ICON_REMOVE:String = "clubIconRemove";
		
		public static const TEAM_ICON_ADD:String = "teamIconAdd";
		public static const TEAM_ICON_REMOVE:String = "teamIconRemove";
		
		
		public static const CLUB_WAR_ICON_ADD:String = "clubWarIconAdd";
		public static const CLUB_WAR_ICON_REMOVE:String = "clubWarIconRemove";
		
		public static const SKILL_ICON_REMOVE:String = "skillIconRemove";
		public static const VEINS_ICON_REMOVE:String = "veinsIconRemove";
		
		public static const PETPVP_ICON_REMOVE:String = "petPVPIconRemove";
		public static const MAIL_ICON_REMOVE:String = "mailIconRemove";
		
		public static const MEDICINE_ICON_REMOVE:String = "medicineIconRemove";
		
		public function QuickIconInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}