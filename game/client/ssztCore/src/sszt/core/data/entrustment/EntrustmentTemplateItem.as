package sszt.core.data.entrustment
{
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class EntrustmentTemplateItem
	{
		public var id:int;
		public var duplicateId:int;
		public var floor:int;
		public var level:int;
		public var fightNeeded:int;
		public var copperCost:int;
		public var timeCost:int;
		public var yuanbaoCost:int;
		public var cooperReward:int;
		public var expReward:int;
		public var lifeExpReward:int;
		public var itemRewardIdArr:Array = [];
		public var itemRewardCountArr:Array = [];
		
		public function EntrustmentTemplateItem()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			duplicateId = data.readInt();
			floor = data.readInt();
			level = data.readInt();
			fightNeeded = data.readInt();
			copperCost = data.readInt();
			timeCost = data.readInt();
			yuanbaoCost = data.readInt();
			cooperReward = data.readInt();
			expReward = data.readInt();
			lifeExpReward = data.readInt();
			var itemRewardsStr:String = data.readUTF();
			var itemRewardsArr:Array = itemRewardsStr.split('|');
			var rewardItem:String;
			var rewardItemArr:Array;
			var rewardId:int;
			var rewardCount:int;
			for each(rewardItem in itemRewardsArr)
			{
				rewardItemArr = rewardItem.split(',');
				rewardId = rewardItemArr[0];
				rewardCount = rewardItemArr[1];
				itemRewardIdArr.push(rewardId);
				itemRewardCountArr.push(rewardCount);
			}
			
		}
	}
}