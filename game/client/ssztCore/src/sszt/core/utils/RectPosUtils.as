package sszt.core.utils
{
	import sszt.constData.CommonConfig;
	
	import flash.geom.Point;

	/**
	 * 通过Tips坐标和大小计算实际的Tips坐标 
	 * @author Administrator
	 * 
	 */
	public class RectPosUtils
	{
		public static function getRectPos(x:Number,y:Number,width:Number,height:Number):Point
		{
			var xx:Number = x + 10;
			var yy:Number = y + 10;
			if(x + width > CommonConfig.GAME_WIDTH) xx = x - width - 10;
			if(xx < 0) xx = x - width / 2;
			if(y + height > CommonConfig.GAME_HEIGHT) yy = y - height - 10;
			if(yy < 0) yy = y - height / 2;
			return new Point(xx,yy);
		}
	}
}