package sszt.core.utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class ColorUtils
	{
		/**
		 * 灰度滤镜
		 */		
		public static var grayMatrix:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0]);
		
		
		/**
		 * 设为绿色，中毒
		 * @param dis
		 * 
		 */		
		public static function setGreen(dis:DisplayObject):void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([0.4, 0, 0, 0, 0]);
			matrix = matrix.concat([0, 1, 0, 0, 30]);
			matrix = matrix.concat([0, 0, 0.4, 0, 0]);
			matrix = matrix.concat([0, 0, 0, 1, 0]);
			dis.filters = [new ColorMatrixFilter(matrix)];
		}
		
		public static function setGray(dis:DisplayObject):void
		{
			dis.filters = [grayMatrix];
		}
	}
}