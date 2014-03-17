package sszt.core.data.openActivity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class SevenActivityTemplateList
	{
		
		public static var activityDic:Dictionary = new Dictionary();
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var activityInfo:SevenActivityTemplateListInfo = new SevenActivityTemplateListInfo();
				activityInfo.parseData(data);
				activityDic[activityInfo.id] = activityInfo;
			}
		}
		
		public static function getActivity(id:int):SevenActivityTemplateListInfo
		{
			return activityDic[id];
		}
	}
}