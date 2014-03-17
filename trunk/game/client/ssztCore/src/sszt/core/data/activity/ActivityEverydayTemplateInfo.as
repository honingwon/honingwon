package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class ActivityEverydayTemplateInfo
	{
		public var id:int;
		public var type:int;
		public var activityId:int;
		public var copyId:int;
		public var bossId:int;
		public var taskId:int;
		public function ActivityEverydayTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			type = data.readInt();
			activityId = data.readInt();
			copyId = data.readInt();
			bossId = data.readInt();
			taskId = data.readInt();
		}
	}
}