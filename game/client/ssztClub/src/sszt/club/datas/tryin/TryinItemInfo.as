package sszt.club.datas.tryin
{
	import sszt.core.data.GlobalData;

	public class TryinItemInfo
	{
		public var serverId:int;
		public var id:Number;
		public var name:String;
		public var vipType:int;
		public var career:int;
		public var level:int;
		public var sex:Boolean = true;
		public var date:Date = GlobalData.systemDate.getSystemDate();
		
		public function TryinItemInfo()
		{
		}
	}
}