package sszt.core.data.club
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ClubLotteryTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function ClubLotteryTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:ClubLotteryTemplateInfo = new ClubLotteryTemplateInfo();
				info.parseData(data);
				list[info.id] = info;
			}
		}
	}
}