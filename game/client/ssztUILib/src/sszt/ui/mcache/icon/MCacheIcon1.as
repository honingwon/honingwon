/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-28 上午10:45:38 
 * 
 */ 
package sszt.ui.mcache.icon
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import ssztui.ui.IconAsset1;
	import ssztui.ui.RightArrowAsset
	
	public class MCacheIcon1 extends Bitmap
	{
		private static const _array:Array = new Array(1);
		private static const _classes:Array = [IconAsset1,RightArrowAsset];
		
		public function MCacheIcon1(type:int,width:Number = -1,height:Number = -1)
		{
			var _icon:BitmapData;
			_icon = _array[type];
			if(_icon == null)
			{
				_icon = new _classes[type]();
				_array[type] = _icon;
			}
			
			super(_icon, "auto", true);
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