package sszt.constData
{
	/**
	 * 拖动类型
	 * @author Administrator
	 * 
	 */	
	public class DragActionType
	{
		/**
		 * 没有拖动
		 */		
		public static const UNDRAG:int = 0;
		
		/**
		 * 拖动失败
		 */		
		public static const NONE:int = 1;
		/**
		 * 放到自己上
		 */		
		public static const ONSELF:int = 2;
		/**
		 * 被iacceptable接收，成功拖入
		 */		
		public static const DRAGIN:int = 3;
	}
}