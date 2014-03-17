package sszt.core.data.club
{
	import flash.utils.ByteArray;

	public class ClubLotteryTemplateInfo
	{
		public var id:int;
		public var itemTemplateId:int;
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			itemTemplateId =  data.readInt();
		}
	}
}