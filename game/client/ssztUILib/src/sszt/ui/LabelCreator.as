package sszt.ui
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LabelCreator
	{
		public static function getLabel(label:String,format:TextFormat = null,filters:Array = null,selected:Boolean = false,autoSize:String = "left"):TextField
		{
			var t:TextField = new TextField();
			t.mouseEnabled = t.selectable = selected;
			t.text = label;
			t.autoSize = autoSize;
			if(format)
			{
				t.defaultTextFormat = format;
				t.setTextFormat(format);
			}
			if(filters)
			{
				t.filters = filters;
			}
			return t;
		}
	}
}