package sszt.constData
{
	/**
	 * 场景图层
	 * @author Administrator
	 * 
	 */	
	public class LayerIndex
	{
		/**
		 * 地图层
		 */		
		public static const MAPLAYER:int = 0;
//		/**
//		 * 路径层
//		 */		
//		public static const PATHLAYER:int = 1;
		/**
		 * 场景物品层
		 */		
		public static const SCENEOBJLAYER:int = 1;
		/**
		 * 控制层
		 */		
		public static const CONTROLLER:int = 2;
		/**
		 * 效果层
		 */		
		public static const EFFECTLAYER:int = 3;
		
		
		public static function getLayers():Array
		{
			return [MAPLAYER,SCENEOBJLAYER,CONTROLLER,EFFECTLAYER];
		}
		public static function getMouseEnableds():Array
		{
			return [true,false,false,false];
		}
		public static function getMouseChildrens():Array
		{
			return [false,true,true,false];
		}
	}
}