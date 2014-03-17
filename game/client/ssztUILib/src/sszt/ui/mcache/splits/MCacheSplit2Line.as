package sszt.ui.mcache.splits
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import ssztui.ui.SplitLine2Asset;
	
	
	/**
	 * 水平分隔线。
	 * 废弃。
	 * */
	public class MCacheSplit2Line extends Bitmap
	{
		private static var _splitLine:BitmapData;
		
		public function MCacheSplit2Line(alpha:Number = 1,width:Number = -1,height:Number = -1)
		{
			if(_splitLine == null)
			{
				_splitLine = new SplitLine2Asset();
			}
			super(_splitLine, "auto", true);
			if(alpha != 1)
				this.alpha = alpha;
			if(width != -1)
				this.width = width;
			if(height != -1)
			{
				this.height = height;
			}
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}