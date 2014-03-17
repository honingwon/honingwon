package sszt.constData
{
	/**
	 * 资源清除类型
	 * @author Administrator
	 * 
	 */	
	public class SourceClearType
	{
		/**
		 * 不清除（图标，装备等）
		 */		
		public static const NEVER:int = 1;
		/**
		 * 地图
		 */		
		public static const TIME:int = 2;
		/**
		 * 立即释放
		 */		
		public static const IMMEDIAT:int = 3;
		/**
		 * 切场景时清除
		 */		
		public static const CHANGE_SCENE:int = 4;
		
		/**
		 * 切场景时删，没有引用时时间删
		 */		
		public static const CHANGESCENE_AND_TIME:int = 5;
	}
}