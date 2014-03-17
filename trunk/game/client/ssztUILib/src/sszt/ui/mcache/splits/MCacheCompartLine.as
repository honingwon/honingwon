package sszt.ui.mcache.splits
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import ssztui.ui.SplitCompartLine;
	
	
	/**
	 * 水平分隔线。
	 * */
	public class MCacheCompartLine extends Bitmap
	{
		private static var _splitLine:BitmapData;
		
		public function MCacheCompartLine(x:Number = 0,y:Number = 0,width:Number = -1,height:Number = -1,alpha:Number = 1)
		{
			if(_splitLine == null)
			{
				_splitLine = new SplitCompartLine();
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
			move(x,y);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}