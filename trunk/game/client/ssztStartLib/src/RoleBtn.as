package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import ssztui.createRole.BtnAsset;
	
	
	public class RoleBtn extends Sprite
	{
		private var _label:String;
		private var _field:TextField;
		
		public function RoleBtn(label:String = "")
		{
			_label = label;
			super();
			init();
		}
		
		private function init():void
		{
			var bg:Bitmap = new Bitmap(new BtnAsset());
			addChild(bg);
			buttonMode = true;
			
			_field = new TextField();
			_field.text = _label;
			_field.width = 53;
			_field.height = 20;
			_field.x = 10;
			_field.y = 5;
			_field.selectable = _field.mouseEnabled = _field.mouseWheelEnabled = false;
			var format:TextFormat = new TextFormat("宋体",12,0xfffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_field.setTextFormat(format);
			_field.defaultTextFormat = format;
			addChild(_field);
		}
	}
}