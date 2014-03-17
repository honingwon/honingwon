package sszt.core.data.challenge
{
	import flash.utils.ByteArray;

	public class ChallengeTemplateListInfo
	{
		/**
		 * 试炼关卡序号
		 */
		public var challengeId:int;
		/**
		 * 关口人物头像 
		 */
		public var headPic:int;
		/**
		 * 前置完成id；如果没为0 
		 */
		public var limit_id:int;
		/**
		 * 层数 
		 */
		public var storey:int;
		/**
		 * 霸主礼包
		 */
		public var gift:int;
		/**
		 *掉落物品数据
		 */
		public var dropArray:Array;
		
		/**
		 * 关联副本关卡id 
		 */		
		public var duplicateId:int;
		
		public var star_timeArray:Array;
		
		public var threeTime:int;
		
		public function parseData(data:ByteArray):void
		{
			challengeId = data.readInt();
			headPic = data.readInt();
			limit_id = data.readInt();
			storey = data.readInt();
			gift = data.readInt();
			dropArray= data.readUTF().split(",");
			duplicateId = data.readInt();
			star_timeArray = data.readUTF().split("|");
			threeTime = int(star_timeArray[0].toString().split(",")[1]);
		}
	}
}