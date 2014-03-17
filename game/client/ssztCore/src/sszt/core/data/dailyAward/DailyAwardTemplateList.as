package sszt.core.data.dailyAward
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class DailyAwardTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function DailyAwardTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:DailyAwardTemplateInfo = new DailyAwardTemplateInfo();
				info.parseData(data);
				list[info.awardId] = info;
			}
		}
		
		public static function getTemplate(awardId:int):DailyAwardTemplateInfo
		{
			return list[awardId];
		}
	}
}