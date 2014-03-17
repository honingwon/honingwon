package sszt.ui.mcache.labelField
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import mhsm.ui.BarAsset1;
	import mhsm.ui.SplitLine3Asset;
	
	public class MLabelField1Bg extends Sprite
	{
		private var _totalWidth:int;
		private var _valueWidth:int;
		private var _asset1:BarAsset1;
		private var _split:Bitmap;
		
		public function MLabelField1Bg(totalWidth:int,valueWidth:int)
		{
			_totalWidth = totalWidth;
			_valueWidth = valueWidth;
			super();
			init();
		}
		
		private function init():void
		{
			_asset1 = new BarAsset1();
			_asset1.width = _totalWidth;
			addChild(_asset1);
			_split = new Bitmap(new SplitLine3Asset());
			_split.x = _totalWidth - _valueWidth;
			_split.y = 3;
			addChild(_split);
		}
	}
}