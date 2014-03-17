package sszt.ui.container
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	
	import ssztui.ui.TitleBackgroundLeftAsset;
	import ssztui.ui.TitleBackgroundRightAsset;
	
	public class MPanel2 extends MPanel
	{
		public function MPanel2(title:DisplayObject=null, dragable:Boolean=true, mode:Number=0.5, closeable:Boolean=true, toCenter:Boolean=true)
		{
			super(title, dragable, mode, closeable, toCenter);
			_titleTopOffset = 2;
		}
		
		
		override protected function createBg(bgWidth:Number, bgHeight:Number):IMovieWrapper
		{
			var list:Array = [
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,bgWidth,bgHeight))
			];
			if(_title)
			{
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x-28,_title.y+2,28,18),new Bitmap(new TitleBackgroundLeftAsset())));
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x+_title.width,_title.y+2,28,18),new Bitmap(new TitleBackgroundRightAsset())));
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x,_title.y,_title.width,_title.height),_title));
			}
			return BackgroundUtils.setBackground(list);
		}
	}
}