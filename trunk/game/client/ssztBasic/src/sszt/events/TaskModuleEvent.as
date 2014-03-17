package sszt.events
{
	import flash.events.Event;
	
	public class TaskModuleEvent extends Event
	{
		public static const SHOW_NPCTASKPANEL:String = "showNpcTaskPanel";
		
		public static const SHOW_MAINPANEL:String = "showMainPanel";
		
		public static const SHOW_FOLLOWPANEL:String = "showFollowPanel";
		
		public static const TASK_CHECKSTATE:String = "taskCheckState";
		
		public static const TASK_FINISH:String = "taskFinish";
		
		public static const TASK_ADD:String = "taskAdd";
		
		public static const TASK_ENTRUST_UPDATE:String = "taskEntrustUpdate";
		
		public static const CLOSE_NPCTASKPANEL:String = "closeNpcTaskPanel";
		
		public static const SHOW_FOLLOW:String = "showFollow";
		
		public static const HIDE_FOLLOW:String = "hideFollow";
		
		public static const GET_CLUB_WAR_REWARDS:String = "getClubWarRewards";
		
		public static const UPDATE_CLUB_TASK:String = "updateClubTask";
		
		public static const TASK_STATE_UPDATE:String = "taskStateUpdate";
		
		public static const TASK_CLOSE_FOLLOW_COMPLETE:String = "taskCloseFollowComplete";
		
		public static const TASK_SHOW_FOLLOW_COMPLETE:String = "taskShowFollowComplete";
		
		public var data:Object;
		
		public function TaskModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}