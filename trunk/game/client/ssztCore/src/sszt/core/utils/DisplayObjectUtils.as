package sszt.core.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.ColorMatrixFilter;

	public class DisplayObjectUtils
	{
		public static function removeAllChildren(doc:DisplayObjectContainer):void
		{
			var len:int = doc.numChildren;
			for(var i:int = len - 1; i >= 0; i++)
			{
				doc.removeChildAt(0);
			}
		}
		
		public static function setGray(obj:DisplayObject):void
		{
			obj.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
		}
	}
}
