package sszt.core.utils
{
	import flash.geom.Point;
	
	public class Geometry
	{
		public static function getNextPoint(p:Point,angle:Number,disance:Number):Point
		{
			return new Point(p.x + Math.cos(angle) * disance,p.y + Math.sin(angle) * disance);
		}
		
		/**
		 * 返回两点间角度
		 * @param p1
		 * @param p2
		 * 
		 */		
		public static function getDegrees(p1:Point,p2:Point):Number
		{
			return getRadian(p1,p2) / Math.PI * 180;
		}
		
		/**
		 * 返回两点间弧度
		 * 一二象限为正，三象限为负
		 * @return 
		 * 
		 */		
		public static function getRadian(p1:Point,p2:Point):Number
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			return Math.atan2(dy, dx);
		}
	}
}