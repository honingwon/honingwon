package sszt.scene.utils
{
	import flash.geom.Point;
	
	import sszt.core.utils.Geometry;

	public class PathUtils
	{
		/**
		 * 截掉路径最后一段距离
		 * @param path
		 * @param distance
		 * @return 
		 * 
		 */		
		public static function cutPathEnd(paths:Array,distance:int,target:Point):Array
		{
//			var path:Array = paths.slice(0);
//			if(path.length >= 2 && distance > 0)
//			{
//				var angle:Number = Geometry.getRadian(path[path.length - 2],path[path.length - 1]);
//				var dx:Number = Math.cos(angle) * distance;
//				var dy:Number = Math.sin(angle) * distance;
//				var target:Point = (path[path.length - 1] as Point).clone();
//				target.x -= dx;
//				target.y -= dy;
//				path[path.length - 1] = target;
//			}
//			return path;
			
			var path:Array = paths.slice(0);
			if(distance > 0 && paths.length >= 2)
			{
				if(Point.distance(path[path.length - 2],target) > distance)
				{
					var angle:Number = Geometry.getRadian(path[path.length - 2],path[path.length - 1]);
					var dx:Number = Math.cos(angle) * distance;
					var dy:Number = Math.sin(angle) * distance;
					var target:Point = (path[path.length - 1] as Point).clone();
					target.x -= dx;
					target.y -= dy;
					path[path.length - 1] = target;
				}
				else
				{
					path = path.slice(0,path.length - 1);
				}
			}
			return path;
		}
		
		public static function updatePath(path:Array,currentX:int,currentY:int,index:int):Array
		{
			path.splice(0,index);
			path.unshift(new Point(currentX,currentY));
			return path;
		}
	}
}