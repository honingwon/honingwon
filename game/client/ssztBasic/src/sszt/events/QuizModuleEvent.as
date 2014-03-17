package sszt.events
{
	import flash.events.Event;
	
	public class QuizModuleEvent extends Event
	{
		/**
		 * 答题活动结束
		 */
		public static const QUIZ_END:String = "quizEnd";
		
		/**
		 * 答题活动准备
		 */
		public static const QUIZ_PREPARE:String = "quizPrepare";
		
		/**
		 * 答题活动推送
		 */
		public static const QUIZ_PUSH:String = "quizPush";
		
		/**
		 * 答题结果
		 */
		public static const QUIZ_RESULT:String = "quizResult";
		
		public var data:Object;
		
		public function QuizModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}