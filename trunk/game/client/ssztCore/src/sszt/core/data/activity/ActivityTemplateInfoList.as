package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class ActivityTemplateInfoList
	{
		public static var list:Dictionary = new Dictionary();
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:ActivityTemplateInfo = new ActivityTemplateInfo();
				info.parseData(data);
				list[info.id] = info;
			}
		}
		
		public static function getActivityTemplateInfo(id:int):ActivityTemplateInfo
		{
			return list[id];
		}
		
	}
}