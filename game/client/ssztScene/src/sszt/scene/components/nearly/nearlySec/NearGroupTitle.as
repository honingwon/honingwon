package sszt.scene.components.nearly.nearlySec
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.BarAsset1;
	import sszt.ui.label.MAssetLabel;
	
	public class NearGroupTitle extends Sprite
	{
		private var _bg:BarAsset1;
		private var _title:MAssetLabel;
		private var _titleValue:String;
		private var _selected:Boolean;
		private var _shape:Shape;
		
		public function NearGroupTitle(title:String)
		{
			_titleValue = title;
			super();
			init();
		}
		
		private function init():void
		{
			_bg = new BarAsset1();
			_bg.width = 281;
			_bg.height = 29;
			addChild(_bg);
			_title = new MAssetLabel(_titleValue,MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT);
			_title.move(23,10);
			addChild(_title);
			mouseChildren = mouseEnabled = false;
		}
		
		override public function get height():Number
		{
			return 29;
		}
	}
}