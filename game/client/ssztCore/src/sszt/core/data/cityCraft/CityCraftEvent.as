package sszt.core.data.cityCraft
{
	import flash.events.Event;
	
	public class CityCraftEvent extends Event
	{
		public static const RANK_LIST_UPDATE:String = "rankListUpdate";
		public static const RESULT_UPDATE:String = "resultUpdate";
		public static const RELOAD_UPDATE:String = "reloadUpdate";
		public static const NICK_UPDATE:String = "nickUpdate";
		public static const UPDATE_ICON_VIEW:String = "updateIconView";
		public static const DAYS_UPDATE:String = "daysUpdate";
		public static const SHOW_ENTER:String = "showEnter";
		public static const MASTER_UPDATE:String = "masterUpdate";
		public static const GUARD_UPDATE:String = "guardUpdate";
		
		public function CityCraftEvent(type:String,obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}