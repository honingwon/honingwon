package sszt.ui.mcache.titles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.TitleAsset1;
	
	public class MCacheTitle1 extends Sprite
	{
		private static var TITLE_TEXTFORMAT:TextFormat = new TextFormat("SimSun",12,0xd4b560,true,null,null,null,null,TextFormatAlign.CENTER);
		private static var TITLE_FILTER:GlowFilter = new GlowFilter(0x000000,1,2,2,10);
		
		private static var _title1Source:BitmapData;
		public static function getTitleSource():BitmapData
		{
			if(_title1Source == null)
				_title1Source = new TitleAsset1();
			return _title1Source;
		}
		
		private var _label:TextField;
		
		public function MCacheTitle1(label:String = "",displayTitle:DisplayObject = null)
		{
			
			if(displayTitle)
			{
				addChild(displayTitle);
			}
			_label = createLabel(label);
			if(_label)
			{
				if(displayTitle)
				{
					_label.x = (displayTitle.width - _label.width) >> 1;
					_label.y = (displayTitle.height - _label.height) >> 1;
				}
				
				addChild(_label);
			}
		}
		
		private function createLabel(label:String = ""):TextField
		{
			if(label == "")return null;
			var t:TextField = new TextField();
			t.mouseEnabled = false;
			t.text = label;
			t.width = t.textWidth;
			t.autoSize = TextFieldAutoSize.CENTER;
			t.setTextFormat(TITLE_TEXTFORMAT);
			t.filters = [TITLE_FILTER];
			return t;
		}
	}
}