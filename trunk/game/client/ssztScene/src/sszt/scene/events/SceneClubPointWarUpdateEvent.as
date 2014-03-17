package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneClubPointWarUpdateEvent extends Event
	{
		public static const CLUB_MAIN_INFO_UPDATE:String = "clubMainInfoUpdate";
		public static const CLUB_MAIN_INFO_PERSONALINFO_UPDATE:String = "clubMainInfoPersonalInfoUpdate";
		
		public static const CLUB_SCORE_INFO_UPDATE:String = "clubScoreInfoUpdate";
		public static const CLUB_LEFT_TIME_UPDATE:String = "clubLeftTimeUpdate";
		public var data:Object;
		public function SceneClubPointWarUpdateEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}