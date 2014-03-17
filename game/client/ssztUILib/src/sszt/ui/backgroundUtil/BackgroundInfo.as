package sszt.ui.backgroundUtil
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class BackgroundInfo
	{
		public var source:Class;
		public var rect:Rectangle;
		/**
		 * t == -1时取display
		 */	
		public var display:DisplayObject;
		
		public function BackgroundInfo(source:Class,rectangle:Rectangle,display:DisplayObject = null)
		{
			this.source = source;
			rect = rectangle;
			this.display = display;
		}
	}
}
