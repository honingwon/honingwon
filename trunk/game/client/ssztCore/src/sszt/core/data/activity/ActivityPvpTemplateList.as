package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ActivityPvpTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var activityPvpTemplateInfo:ActivityPvpTemplateInfo = new ActivityPvpTemplateInfo();
				activityPvpTemplateInfo.parseData(data);
				list[activityPvpTemplateInfo.id] = activityPvpTemplateInfo;
			}
		}
	}
}