package sszt.ui.backgroundUtil
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.UIManager;

	public class BackgroundUtils
	{
		public static function setBackground(bgs:Array):IMovieWrapper
		{
			var size:Point = new Point(0,0);
			var m:MovieClip = changeToMc(bgs,size);
			var result:IMovieWrapper = UIManager.movieWrapperApi.getMovieWrapper(m,size.x,size.y);
			result.gotoAndStop(1);
			return result;
		}
		
		public static function changeToMc(bgs:Array,size:Point = null):MovieClip
		{
			var m:MovieClip = new MovieClip();
			var mcw:Number = 0,mch:Number = 0;
			var bgsource:Array = [];
			for each(var i:BackgroundInfo in bgs)
			{
				var t:DisplayObject;
				if(i.source == BackgroundType.DISPLAY)
				{
					if(i.display == null)continue;
					t = i.display;
				}
				else
				{
					t = new i.source();
				}
				t.x = i.rect.x;
				t.y = i.rect.y;
				t.width = i.rect.width;
				t.height = i.rect.height;
				if(mcw < t.width + t.x)mcw = t.width + t.x;
				if(mch < t.height + t.y)mch = t.height + t.y;
				m.addChild(t);
			}
			if(size != null)
			{
				size.x = mcw;
				size.y = mch;
			}
			return m;
		}
		
		public static function changeToBitmapData(bgs:Array):BitmapData
		{
			var size:Point = new Point(0,0);
			var m:MovieClip = changeToMc(bgs,size);
			return UIManager.movieWrapperApi.doRemance(UIManager.movieWrapperApi.getRemanceParam(m,1,size.x,size.y));
		}
	}
}