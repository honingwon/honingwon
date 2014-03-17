package sszt.ui.mcache.labelField
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class MLabelField extends Sprite
	{
		private var _label:String;
		private var _field1:TextField;
		private var _field2:TextField;
		private var _totalWidth:int;
		private var _valueWidth:int;
		private var _style:int;
		
		public function MLabelField(label:String,totalWidth:int,valueWidth:int,style:int = 0)
		{
			_label = label;
			_totalWidth = totalWidth;
			_valueWidth = valueWidth;
			_style = style;
			super();
			init();
		}
		
		private function init():void
		{
			_field1 = new TextField();
			_field1.width = _totalWidth - _valueWidth;
			_field1.text=_label;
			_field2 = new TextField();
			_field2.x = _field1.width;
			_field2.width = _valueWidth;
			_field1.mouseEnabled = _field2.mouseEnabled = false;
			addChild(_field1);
			addChild(_field2);
		}
		
		public function move(x:int,y:int):void
		{
			this.x=x;
			this.y=y;
		}
		
		public function setValue(value:String):void
		{
			_field2.text = value;
		}
	}
}