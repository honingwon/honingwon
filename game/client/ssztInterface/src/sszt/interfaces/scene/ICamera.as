package sszt.interfaces.scene
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface ICamera
	{
		/**
		 * 获取投影位置
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		function getProjectPosition(x:int,y:int):Point;
		/**
		 * 根据投影的位置，获取场景中的位置
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		function getScenePosition(x:int,y:int):Point;
		/**
		 * 投影后区域位置
		 * @param w
		 * @param h
		 * @return 
		 * 
		 */		
		function getSceneRect(w:uint,h:uint):Rectangle;
//		function getViewTiles():Object;
//		function getViewTiles(rect:Rectangle,tileW:Number,tileH:Number):Object
	}
}




			