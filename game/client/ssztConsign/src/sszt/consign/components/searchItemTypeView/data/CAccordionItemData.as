package sszt.consign.components.searchItemTypeView.data
{
	public class CAccordionItemData
	{
		private var _itemName:String;
//		private var _itemCategoryIdVector:Vector.<int>;
		private var _itemCategoryIdVector:Array;
//		public function CAccordionItemData(argItemName:String,argItemCategoryIdVector:Vector.<int>)
		public function CAccordionItemData(argItemName:String,argItemCategoryIdVector:Array)
		{
			_itemName = argItemName;
			_itemCategoryIdVector = argItemCategoryIdVector;
		}

		public function get itemName():String
		{
			return _itemName;
		}

		public function set itemName(value:String):void
		{
			_itemName = value;
		}

//		public function get itemCategoryIdVector():Vector.<int>
		public function get itemCategoryIdVector():Array
		{
			return _itemCategoryIdVector;
		}

//		public function set itemCategoryIdVector(value:Vector.<int>):void
		public function set itemCategoryIdVector(value:Array):void
		{
			_itemCategoryIdVector = value;
		}

	}
}