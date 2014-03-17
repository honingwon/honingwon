package sszt.core.utils
{
	import flash.geom.Point;
	
	import sszt.core.data.GlobalAPI;

	public class LineUtils
	{
		
		/**
		 * 根据当前位置。将全路径截取出来
		 * @param path
		 * @param current
		 * @return 
		 * 
		 */		
		public static function checkPath(path:Array,current:Point):Array
		{
			if(path.length <= 1)return path;
			for(var i:int = 1; i < path.length; i++)
			{
				if(isInLine(path[i - 1],path[i],current))
				{
					return path.slice(i);
				}
			}
			return path;
		}
		
		public static function isInLine(start:Point,end:Point,current:Point):Boolean
		{
			if(start.x == current.x && start.y == current.y || end.x == current.x && end.y == current.y)return true;
			if((current.x <= start.x && current.x >= end.x || current.x <= end.x && current.x >= start.x) && 
				(current.y <= start.y && current.y >= end.y || current.y <= end.y && current.y >= start.y))
			{
				return Math.abs(Math.atan2((end.y - start.y),(end.x - start.x)) - Math.atan2((current.y - start.y),(current.x - start.x))) < 0.04;
			}
			return false;
		}
	}
}