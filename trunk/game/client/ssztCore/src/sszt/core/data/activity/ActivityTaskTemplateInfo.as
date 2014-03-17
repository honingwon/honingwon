package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class ActivityTaskTemplateInfo
	{
		public var taskId:int;
		public var description:String;
//		public var activityTimes:int;
		public var days:int;
		public var awards:Array;
		public var type:int;
		
		public function ActivityTaskTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			taskId = data.readInt();
			description = data.readUTF();
//			activityTimes = data.readInt();
			days = data.readInt();
			awards = data.readUTF().split(",");
			type = data.readInt();
		}
	}
}