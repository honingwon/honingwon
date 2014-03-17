package sszt.core.data.swordsman
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class SwordsmanTemplateList
	{
		public static var _list:Dictionary = new Dictionary();
		
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:SwordsmanTemplateInfo = new SwordsmanTemplateInfo();
				info.parseData(data);
				_list[info.type] = info;
			}
		}
		
		public static function getSwordsmanTemplateInfoById(id:int):SwordsmanTemplateInfo
		{
			return _list[id];
		}
	}
}