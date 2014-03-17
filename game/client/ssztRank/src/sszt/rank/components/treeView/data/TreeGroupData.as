package sszt.rank.components.treeView.data
{
	public class TreeGroupData
	{
		private var _title:String;
		private var _treeItemDataVector:Array;
		private var _titleId:int;
		public function TreeGroupData(argTitle:String,argTreeItemData:Array ,argTitleId:int)
		{
			_title = argTitle;
			_treeItemDataVector = argTreeItemData;
			_titleId = argTitleId;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get treeItemDataVector():Array
		{
			return _treeItemDataVector;
		}

		public function set treeItemDataVector(value:Array):void
		{
			_treeItemDataVector = value;
		}
		
		public function get titleId():int
		{
			return _titleId;
		}
	}
}