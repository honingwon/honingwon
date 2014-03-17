package  sszt.events
{
	public class SwordsmanMediaEvents extends ModuleEvent
	{
		public static const TEMPLATE_COMMAND_START:String = "swordsmanCommandStart";
		public static const TEMPLATE_COMMADN_END:String = "swordsmanCommandEnd";
		
		public static const TEMPLATE_MEDIATOR_START:String = "swordsmanMediatorStart";
		public static const TEMPLATE_MEDIATOR_DISPOSE:String = "swordsmanMediatorDispose";
		
		public static const UPDATE_TOKEN_NUM:String =  "updateTokenNum";
		public static const UPDATE_ACCEPT:String =  "updateAccept";
		public static const UPDATE_PUBLISH:String =  "updatePublish";
		public static const UPDATE_TOKEN_PUBLISH:String =  "updateTokenPublish";
		public static const RIGHT_NOW_COMPLETE:String =  "rightNowComplete";
		/**
		 * 完成任务 
		 */		
		public static const COMPLETE_TASK:String =  "completeTask";
		public static const TOKEN_TASK_ACCEPT:String =  "tokenTaskAccept";
		/**
		 * 刷新接受江湖令时用到
		 */
		public static const TO_SHOW_RELEASE_SOWRDMAN_NUM:String =  "toShowReleaseSwordmanNum";
		
		public function SwordsmanMediaEvents(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}