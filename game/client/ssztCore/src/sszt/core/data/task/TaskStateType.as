package sszt.core.data.task
{
	public class TaskStateType
	{
		public static const ERROR:int = 0;
		
		/**
		 * 不可接
		 */		
		public static const CANNOTACCEPT:int = 1;
		/**
		 * 可接
		 */		
		public static const CANACCEPT:int = 2;
		/**
		 * 已接未完成
		 */		
		public static const ACCEPTNOTFINISH:int = 3;
		/**
		 * 完成未提交
		 */		
		public static const FINISHNOTSUBMIT:int = 4;
		/**
		 * 已提交
		 */		
		public static const SUBMITED:int = 5;
		/**
		 * 过期
		 */		
		public static const OUTOFDATE:int = 6;
	}
}