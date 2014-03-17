package sszt.task.events
{
	public class TaskMediatorEvent
	{
		public static const TASK_COMMAND_START:String = "taskCommandStart";
		public static const TASK_COMMAND_END:String = "taskCommandEnd";
		
		/**
		 * 
		 */		
		public static const TASK_MEDIATOR_START:String = "taskMediatorStart";
		/**
		 * 弹开NPC对话框
		 */		
		public static const TASK_MEDIATOR_SHOWNPCPANEL:String = "taskMediatorshowNpcPanel";
		/**
		 * 弹出任务主面板
		 */		
		public static const TASK_MEDIATOR_SHOWMAINPANEL:String = "taskMediatorShowMainPanel";
		/**
		 * 显示任务追踪面板
		 */		
		public static const TASK_MEDIATOR_SHOWFOLLOWPANEL:String = "taskMediatorShowFollowPanel";
		public static const TASK_MEDIATOR_DISPOSE:String = "taskMediatorDispose";
		
		/**
		 * 显示追踪
		 */		
		public static const SHOW_FOLLOW:String = "showFollow";
		/**
		 * 隐藏追踪
		 */		
		public static const HIDE_FOLLOW:String = "hideFollow";
		/**
		 *完全显示追踪面板 
		 */		
		public static const SHOW_FOLLOW_COMPLETE:String = "showFollowComplete";
		/**
		 *完全隐藏追踪面板 
		 */		
		public static const CLOSE_FOLLOW_COMPLETE:String = "closeFollowComplete";
	}
}