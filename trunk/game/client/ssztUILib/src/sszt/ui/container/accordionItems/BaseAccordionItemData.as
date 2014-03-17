package sszt.ui.container.accordionItems
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BaseAccordionItemData extends EventDispatcher implements IAccordionItemData
	{
		private var _data:String;
		
		public function BaseAccordionItemData(data:String = "")
		{
			_data = data;
		}
		
		public function getAccordionItem(width:int):DisplayObject
		{
			var field:TextField = new TextField();
			field.defaultTextFormat = new TextFormat("SimSun",12,0xFFFFFF);
			field.filters = [new GlowFilter(0x17380F,1,2,2,10)];
			field.width = width;
			field.height = 20;
			field.mouseEnabled = false;
			field.htmlText = _data;
			return field;
		}
	}
}