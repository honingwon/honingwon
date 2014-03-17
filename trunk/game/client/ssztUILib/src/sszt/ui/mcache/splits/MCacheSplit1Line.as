package sszt.ui.mcache.splits
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import ssztui.ui.SplitLine1Asset;
	
	
	
	public class MCacheSplit1Line extends Bitmap
	{
		private static var _splitLine:BitmapData;
		
		public function MCacheSplit1Line(width:Number = -1,height:Number = -1)
		{
			if(_splitLine == null)
			{
				_splitLine = new SplitLine1Asset();
			}
			super(_splitLine, "auto", true);
			if(width != -1)
			{
				this.width = width;
			}
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