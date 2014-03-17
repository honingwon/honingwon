package sszt.consign.components.searchItemTypeView.data
{
	public class CAccordionGroupData
	{
		private var _title:String;
//		private var _accordionItemDataVector:Vector.<CAccordionItemData>;
		private var _accordionItemDataVector:Array;
//		public function CAccordionGroupData(argTitle:String,argAccordionItemData:Vector.<CAccordionItemData>)
		public function CAccordionGroupData(argTitle:String,argAccordionItemData:Array)
		{
			_title = argTitle;
			_accordionItemDataVector = argAccordionItemData;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

//		public function get accordionItemDataVector():Vector.<CAccordionItemData>
		public function get accordionItemDataVector():Array
		{
			return _accordionItemDataVector;
		}

//		public function set accordionItemDataVector(value:Vector.<CAccordionItemData>):void
		public function set accordionItemDataVector(value:Array):void
		{
			_accordionItemDataVector = value;
		}


	}
}