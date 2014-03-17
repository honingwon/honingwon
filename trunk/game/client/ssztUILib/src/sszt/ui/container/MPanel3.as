/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-24 上午9:42:09 
 * 
 */ 
package sszt.ui.container
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	
	import ssztui.ui.TitleBackgroundLeftAsset;
	import ssztui.ui.TitleBackgroundRightAsset;

	public class MPanel3 extends MPanel
	{
		public static const TITLE_HEIGHT:Number = 34;
		protected var _totalWidth:Number;
		protected var _totalHeight:Number;
		protected var _mode:Number;
		public function MPanel3(title:DisplayObject=null, dragable:Boolean=true,mode:Number = 0.5, closeable:Boolean=true, toCenter:Boolean=true)
		{
			super(title, dragable, mode, closeable, toCenter);
			_mode = mode;
			_titleTopOffset = 7;
		}
		
		
		override protected function createBg(bgWidth:Number,bgHeight:Number):IMovieWrapper
		{
			var list:Array = [
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,bgWidth,bgHeight),new AlertSkinAsset())
				new BackgroundInfo(BackgroundType.BORDER_1,new Rectangle(0,0,bgWidth,bgHeight)),
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(10,34,bgWidth-20,bgHeight-80)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,bgHeight-50,bgWidth-10,25),new MCacheCompartLine2()),
			];
			if(_title)
			{
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x-28,_title.y+2,28,18),new Bitmap(new TitleBackgroundLeftAsset())));
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x+_title.width,_title.y+2,28,18),new Bitmap(new TitleBackgroundRightAsset())));
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x,_title.y,_title.width,_title.height),_title));
			}
			return BackgroundUtils.setBackground(list);
		}
		
		override protected function drawLayout():void{
			super.drawLayout();
			if (this._mode >= 0){
				graphics.beginFill(0, this._mode);
				graphics.drawRect(-2000, -2000, 4000, 4000);
				graphics.endFill();
			}
		}
		
	}
}