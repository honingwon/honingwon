package sszt.core.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class RotateUtils
	{
		public static function setRotation(target:DisplayObject,registerPoint:Point = null,rotation:int = 0):void
		{
			if(registerPoint == null)registerPoint = new Point(target.x,target.y);
			
			var dx:Number = registerPoint.x - target.x;
			var dy:Number = registerPoint.y - target.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			
			var a:Number = Math.atan2(dy,dx) * 180 / Math.PI;
			var offset:Number = 180 - a + target.rotation;
			
			var tp:Point = new Point(target.x,target.y);
			var ra:Number = (rotation - offset) * Math.PI / 180;
			target.x = registerPoint.x + Math.cos(ra) * dist;
			target.y = registerPoint.y + Math.sin(ra) * dist;
			
			target.rotation = rotation;
		}
	}
}