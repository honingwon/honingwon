package sszt.constData
{
	import flash.geom.Point;

	public class DirectType
	{
		//五个方向
		public static const DIRECT_5:int = 0;
		//二个方向
		public static const DIRECT_2:int = 1;
		//一个方向		
		public static const DIRECT_1:int = 2;
		
		public static const LEFT_TOP:int = 1;
		public static const RIGHT_TOP:int = 2;
		public static const LEFT_BOTTOM:int = 3;
		public static const RIGHT_BOTTOM:int = 4;
		
		public static const TOP:int = 5;
		public static const BOTTOM:int = 6;
		public static const LEFT:int = 7;
		public static const RIGHT:int = 8;
		
		public static const DIR_ARR:Array = [1,2,3,4,5,6,7,8];
		
		public static function checkDir(p1:Point,p2:Point):int
		{
			var t:Number = getDegrees(p1,p2);
			if(t > -105 && t < -75)return TOP;
			else if(t >= -75 && t <= -25)return RIGHT_TOP;
			else if(t > -25 && t < 25)return RIGHT;
			else if(t >= 25 && t <= 75)return RIGHT_BOTTOM;
			else if(t > 75 && t < 105)return BOTTOM;
			else if(t >= 105 && t <= 165)return LEFT_BOTTOM;
			else if(t > 165 && t <= 180)return LEFT;
			else if(t < -165)return LEFT;
			else if(t >= -165 && t <= -105)return LEFT_TOP;
			return LEFT_TOP;
		}
		
		public static function isTop(type:int):Boolean
		{
			return type == LEFT_TOP || type == RIGHT_TOP || type == TOP;
		}
		
		public static function isBottom(type:int):Boolean
		{
			return type == LEFT_BOTTOM || type == RIGHT_BOTTOM || type == BOTTOM;
		}
		
		public static function isLeft(type:int):Boolean
		{
			return type == LEFT_TOP || type == LEFT_BOTTOM || type == LEFT;
		}
		
		public static function isRight(type:int):Boolean
		{
			return type == RIGHT_TOP || type == RIGHT_BOTTOM || type == RIGHT;
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
		
		public static function getRandomDir():int
		{
			return DIR_ARR[int(Math.random() * DIR_ARR.length)];
		}
	}
}