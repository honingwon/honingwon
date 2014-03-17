package sszt.ui.mcache.splits
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mhsm.ui.SplitLine3Asset;
	
	public class MCacheSplit3Line extends Bitmap
	{
		private static var _splitLine:BitmapData;
		
		public function MCacheSplit3Line(alpha:Number = 1)
		{
			if(_splitLine == null)
			{
				_splitLine = new SplitLine3Asset();
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