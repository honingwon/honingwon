package sszt.sevenActivity.components
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.SevenActivityItemInfo;
	import sszt.core.data.activity.SevenActivityUserItemInfo;
	import sszt.core.data.challenge.ChallengeInfo;
	import sszt.core.data.challenge.ChallengeTemplateList;
	import sszt.core.data.challenge.ChallengeTemplateListInfo;

	public class SevenActivityUtils
	{
		
		public static var sevenNum:int = 7;
		/**
		 * 判断用户(我自己)是否可以领取该奖励 
		 * @param userId 用户id
		 * @param actId 七天嘉年华活动id
		 * @return 
		 * 
		 */		
		public static function isGetReward(userId:int,actId:int):Boolean
		{
			var reBoolean:Boolean;
			var sevenActivityItemInfo:SevenActivityItemInfo = GlobalData.sevenActInfo.activityDic[actId];
			var actIsEnd:Boolean = sevenActivityItemInfo.isEnd;
			var uersArray:Array = sevenActivityItemInfo.userArray;
			var sevenActivityUserItemInfo:SevenActivityUserItemInfo;
			for(var i:int=0;i<uersArray.length;i++)
			{
				sevenActivityUserItemInfo = uersArray[i];
				if(actIsEnd && sevenActivityUserItemInfo.userId == userId && !sevenActivityUserItemInfo.isGet)
				{
					reBoolean = true;
					break;
				}
			}
			return reBoolean;
		}
		
		/**
		 * 判断用户（我自己）是否已经领取该奖励 (前三名的奖励)
		 * @param userId 用户id
		 * @param actId 七天嘉年华活动id
		 * @return 
		 * 
		 */		
		public static function isRewardGot(userId:int,actId:int):Boolean
		{
			var reBoolean:Boolean;
			var sevenActivityItemInfo:SevenActivityItemInfo = GlobalData.sevenActInfo.activityDic[actId];
			var actIsEnd:Boolean = sevenActivityItemInfo.isEnd;
			var uersArray:Array = sevenActivityItemInfo.userArray;
			var sevenActivityUserItemInfo:SevenActivityUserItemInfo;
			for(var i:int=0;i<uersArray.length;i++)
			{
				sevenActivityUserItemInfo = uersArray[i];
				if(actIsEnd && sevenActivityUserItemInfo.userId == userId && sevenActivityUserItemInfo.isGet)
				{
					reBoolean = true;
					break;
				}
			}
			return reBoolean;
		}
		
		/**
		 * 判断七天嘉年华活动是否结束 
		 * @return 
		 * 
		 */		
		public static function isActOver():Boolean
		{
			var reBoolean:Boolean = false;
			var obj:Object;
			var actIsEnd:Boolean = false;
			for(var j:int=1;j<=sevenNum;j++)
			{
				obj = GlobalData.sevenActInfo.activityDic[j];
				actIsEnd = obj.isEnd as Boolean;
				if(actIsEnd)
				{
					reBoolean = true;
					break;
				}
			}
			return reBoolean;
		}
	}
}