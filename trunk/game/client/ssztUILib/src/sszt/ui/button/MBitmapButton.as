package sszt.ui.button
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class MBitmapButton extends MAssetButton
	{
		public function MBitmapButton(source:Object, label:String="", width:Number=-1, height:Number=-1, xscale:Number=1, yscale:Number=1, scale9Grid:Rectangle=null)
		{
			super(source, label, width, height, xscale, yscale, scale9Grid);
		}
		
		override protected function createAsset():DisplayObject
		{
			return new Bitmap(_source as BitmapData);
		}
		
		
//		override public function dispose():void
//		{
//			if(_asset && _asset is Bitmap)
//			{
//				(_asset as Bitmap).bitmapData.dispose();
//				_asset = null;
//			}
//			super.dispose();
//		}
	}
}