package sszt.ui.label
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundType;

	public class MBackgroundLabel
	{
		public function MBackgroundLabel(){}
		
		public static function getDisplayObject(argRect:Rectangle,argDisplayObject:DisplayObject = null):DisplayObject
		{
			if(!argDisplayObject){return null}
			argDisplayObject.x = argRect.x;
			argDisplayObject.y = argRect.y;
			argDisplayObject.width = argRect.width;
			argDisplayObject.height = argRect.height;
			return argDisplayObject;
		}
	}
}