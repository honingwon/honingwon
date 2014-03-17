package sszt.core.utils
{
	import flash.geom.Point;

	public class MathUtil
	{
		public static function getAngleBetweenPoint(p1:Point,p2:Point):Number
		{
			return Math.floor(radianToAngle(Math.atan2((p2.y - p1.y),(p2.x - p1.x))));
		}
		
		public static function radianToAngle(radian:Number):Number
		{
			return (radian / Math.PI) * 180;
		}
		
		public static function angleToRadian(angle:Number):Number
		{
			return (angle / 180) * Math.PI;
		}
	}
}
