package sszt.rank.components.treeView.data
{
	public class TreeItemData
	{
		private var _itemName:String;
//		private var _itemCategoryIdVector:Vector.<int>;
		private var _itemId:int;
//		public function CAccordionItemData(argItemName:String,argItemCategoryIdVector:Vector.<int>)
		public function TreeItemData(argItemName:String,itemId:int)
		{
			_itemName = argItemName;
			_itemId = itemId;
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
		public function get itemId():int
		{
			return _itemId;
		}

//		public function set itemCategoryIdVector(value:Vector.<int>):void
		public function set itemId(value:int):void
		{
			_itemId = value;
		}

	}
}