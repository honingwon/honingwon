package sszt.ui.mcache.labelField
{
	import flash.display.Sprite;
	
	import mhsm.ui.BarAsset2;
	import mhsm.ui.BarAsset3;
	
	public class MLabelField2Bg extends Sprite
	{
		private var _totalWidth:int;
		private var _valueWidth:int;
		private var _bgAsset:BarAsset3;
		private var _fgAsset:BarAsset2;
		
		public function MLabelField2Bg(totalWidth:int,valueWidth:int)
		{
			_totalWidth = totalWidth;
			_valueWidth = valueWidth;
			super();
			init();
		}
		
		private function init():void
		{
			_bgAsset = new BarAsset3();
			_bgAsset.width = _totalWidth;
			addChild(_bgAsset);
			_fgAsset = new BarAsset2();
			_fgAsset.width = _valueWidth;
			_fgAsset.x = _totalWidth - _valueWidth - 2;
			_fgAsset.y = 2;
			addChild(_fgAsset);
		}
	}
}