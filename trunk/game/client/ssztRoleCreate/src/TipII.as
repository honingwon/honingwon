package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import ssztui.createRole.ErrorIconAsset;
	
	
	public class TipII extends Sprite
	{
		private var _field:TextField;
		
		private var _bg:Bitmap;
		
		public function TipII()
		{
			super();
			init();
		}
		
		public function setValue(mes:String):void
		{
			mouseChildren = mouseEnabled = false;
			_field.text = mes;
			_field.mouseEnabled = false;
			if(mes !== "")
				_bg.visible = true;
			else
				_bg.visible = false;
		}
		
		private function init():void
		{
			_bg = new Bitmap(new ErrorIconAsset() as BitmapData);
			addChild(_bg);
			
			_field = new TextField();
			_field.defaultTextFormat = new TextFormat("Tahoma",12,0xff6c1c,null,null,null,null,null,TextFormatAlign.LEFT);
			_field.x = 24;
			_field.y = 2;
			_field.width = 300;
			_field.height = 20;
			addChild(_field);
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}
	}
}