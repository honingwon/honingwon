/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-26 下午3:52:29 
 * 
 */ 
package sszt.ui.progress
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ProgressBar1 extends ProgressBar
	{
		public function ProgressBar1(asset:DisplayObject, currentValue:int, totalValue:int, width:int, height:int, isShowTxt:Boolean, isShowPercent:Boolean, background:DisplayObject=null)
		{
			_mask = new Sprite();
			
			addChild(_mask);
			
			super(asset, currentValue, totalValue, width, height, isShowTxt, isShowPercent, background);
			_asset.mask = _mask;
		}
		
		override protected function updateAssetWidth():void
		{
			var mWidth:int = 0;
			if(_totalValue == 0)
				mWidth = _width;
			else 
				mWidth = (_currentValue/_totalValue)*_width;
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0,0,mWidth,_height);
			_mask.graphics.endFill();
			_mask.mouseEnabled = false;
			_mask.mouseChildren = true;
			
			
			
		}
		
	}
}