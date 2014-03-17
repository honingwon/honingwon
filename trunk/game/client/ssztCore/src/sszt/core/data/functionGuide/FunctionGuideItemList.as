package sszt.core.data.functionGuide
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;

	public class FunctionGuideItemList
	{
		private static var _itemInfoList:Array = [];
		
		public function FunctionGuideItemList()
		{
		}
		
		public static function setup(data:ByteArray):void 
		{
			if(!data.readBoolean())
			{
				MAlert.show(data.readUTF());
				return;
			}
			data.readUTF();
			var len:int = data.readInt();
			for( var i:int=0;i<len;i++)
			{
				var info:FunctionGuideItemInfo = new FunctionGuideItemInfo();
				info.loadData(data);
				info.place = i;
				_itemInfoList.push(info);
			}
		}
		
		public static function get itemInfoList():Array
		{
			return _itemInfoList;
		}
		
		public static function getItemInfoByLevel(level:int):FunctionGuideItemInfo
		{
			for each(var item:FunctionGuideItemInfo in _itemInfoList)
			{
				if(item.level == level)
				{
					return item;
				}
			}
			return null;
		}
	}
}