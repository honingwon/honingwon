package sszt.ui.mcache.splits
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mhqy.ui.SplitLine4Asset;
	
	public class MCacheSplit4Line extends Bitmap
	{
		private static var _splitLine:BitmapData;
		
		public function MCacheSplit4Line(alpha:Number = 1)
		{
			if(_splitLine == null)
			{
				_splitLine = new SplitLine4Asset();
			}
			super(_splitLine, "auto", true);
			if(alpha != 1)
				this.alpha = alpha;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}