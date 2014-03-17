package sszt.core.data.task
{
	import flash.utils.ByteArray;

	public class TaskAwardTemplateInfo
	{
		public var awardId:int;
		/**
		 * 0所有，1尚武，2逍遥，3流星
		 */		
		public var career:int;
		public var count:int;
		public var isBind:Boolean;
		/**
		 * 0所有，1男，2女
		 */		
		public var sex:int;
		public var templateId:int;
		public var validDate:int;
		
		public function TaskAwardTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			awardId = data.readInt();
			sex = data.readInt();
			career = data.readInt();
			templateId = data.readInt();
			count = data.readInt();
			validDate = data.readInt();
			isBind = data.readBoolean();
		}
	}
}