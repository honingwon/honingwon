package sszt.club.events
{
	public class ClubMediatorEvent
	{
		public static const CLUB_COMMAND_START:String = "clubCommandStart";
		public static const CLUB_COMMAND_END:String = "clubCommandEnd";
		
		public static const CLUB_MEDIATOR_START:String = "clubMediatorStart";
		public static const CLUB_MEDIATOR_DISPOSE:String = "clubMediatorDispose";
		
		
		public static const SHOW_CREATEPANEL:String = "showCreatePanel";
		public static const SHOW_CLUBLIST:String = "showClubList";
		public static const SHOW_CLUBMAIN:String = "showClubMain";
		public static const SHOW_CLUBSHOP:String = "showClubShop";
		public static const SHOW_CLUBSTORE:String = "showClubStore";
		
//		public static const CLUB_KICK:String = "clubKick";
		public static const CLUB_TRANSFER:String = "clubTransfer";
		/**
		 *显示对应面板 
		 */		
		public static const SHOW_CLUBPANEL:String = "showClubPanel";
		
		public static const SHOW_CLUB_WAR_PANEL:String = "showClubWarPanel";
		
		
		
		/////////////////////////////////	
		//		帮会营地子模块		//
		/////////////////////////////
		/**
		 * 显示【召唤帮会BOSS面板 】
		 */
		public static const SHOW_CLUB_BOSS_PANEL:String = 'showClubBossPanel';
		
		/**
		 * 显示【开启帮会采集物面板 】
		 */
		public static const SHOW_CLUB_COLLECTION_PANEL:String = 'showClubCollectionPanel';
	}
}