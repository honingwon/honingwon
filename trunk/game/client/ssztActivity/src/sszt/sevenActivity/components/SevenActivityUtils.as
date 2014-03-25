package sszt.sevenActivity.components
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.SevenActivityItemInfo;
	import sszt.core.data.activity.SevenActivityUserItemInfo;
	import sszt.core.data.challenge.ChallengeInfo;
	import sszt.core.data.challenge.ChallengeTemplateList;
	import sszt.core.data.challenge.ChallengeTemplateListInfo;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.pet.PetItemInfo;

	public class SevenActivityUtils
	{
		
		public static var sevenNum:int = 7;
		
		/**
		 * 判断我自己是否可以领取橙装奖励，以及有没有领取
		 */		
		public static function canGetReward2(id:int):Array
		{
			var ret:Array = [];
			var state:int = GlobalData.sevenActInfo.gotState2;
			//有没有领取过
			var hasGot:Boolean;
			switch(id)
			{
				case 1 :
					hasGot = Boolean(2 & state);
					ret[0] = hasGot;
					if(!hasGot && GlobalData.selfPlayer.level >= 45)
					{
						ret[1] = true;
					}
					break;
				case 2 :
					hasGot = Boolean(4 & state);
					ret[0] = hasGot;
					if(!hasGot && GlobalData.selfPlayer.fight >= 20000)
					{
						ret[1] = true;
					}
					break;
				case 3 :
					hasGot = Boolean(8 & state);
					ret[0] = hasGot;
					var mount:MountsItemInfo = GlobalData.mountsList.getFightPet();
					if(!hasGot && mount && mount.fight >= 15000)
					{
						ret[1] = true;
					}
					break;
				case 4 :
					hasGot = Boolean(16 & state);
					ret[0] = hasGot;
					var pet:PetItemInfo = GlobalData.petList.getFightPet();
					if(!hasGot && pet && pet.fight >= 20000)
					{
						ret[1] = true;
					}
					break;
				case 5 :
					hasGot = Boolean(32 & state);
					ret[0] = hasGot;
					var totalGengu:int = GlobalData.veinsInfo.getTotalGengu();
					if(!hasGot && totalGengu >= 35)
					{
						ret[1] = true;
					}
					break;
				case 6 :
					hasGot = Boolean(64 & state);
					ret[0] = hasGot;
					var total:int = GlobalData.bagInfo.getTotalStrengthenLevel();
					if(!hasGot && total >= 65)
					{
						ret[1] = true;
					}
					break;
				case 7 :
					hasGot = Boolean(128 & state);
					ret[0] = hasGot
					if(!hasGot && GlobalData.selfPlayer.money >= 5000)
					{
						ret[1] = true;
					}
					break;
			}			
			return ret;
		}
		
		/**
		 * 判断我自己是否可以领取全民奖励，以及有没有领取
		 */		
		public static function canGetReward(id:int):Array
		{
			var ret:Array = [];
			var state:int = GlobalData.sevenActInfo.gotState;
			//有没有领取过
			var hasGot:Boolean;
			switch(id)
			{
				case 1 :
					hasGot = Boolean(2 & state);
					ret[0] = hasGot;
					if(!hasGot && GlobalData.selfPlayer.level >= 43)
					{
						ret[1] = true;
					}
					break;
				case 2 :
					hasGot = Boolean(4 & state);
					ret[0] = hasGot;
					if(!hasGot && GlobalData.selfPlayer.fight >= 13500)
					{
						ret[1] = true;
					}
					break;
				case 3 :
					hasGot = Boolean(8 & state);
					ret[0] = hasGot;
					var mount:MountsItemInfo = GlobalData.mountsList.getFightPet();
					if(!hasGot && mount && mount.fight >= 10000)
					{
						ret[1] = true;
					}
					break;
				case 4 :
					hasGot = Boolean(16 & state);
					ret[0] = hasGot;
					var pet:PetItemInfo = GlobalData.petList.getFightPet();
					if(!hasGot && pet && pet.fight >= 13500)
					{
						ret[1] = true;
					}
					break;
				case 5 :
					hasGot = Boolean(32 & state);
					ret[0] = hasGot;
					var totalGengu:int = GlobalData.veinsInfo.getTotalGengu();
					if(!hasGot && totalGengu >= 16)
					{
						ret[1] = true;
					}
					break;
				case 6 :
					hasGot = Boolean(64 & state);
					ret[0] = hasGot;
					var total:int = GlobalData.bagInfo.getTotalStrengthenLevel();
					if(!hasGot && total >= 50)
					{
						ret[1] = true;
					}
					break;
				case 7 :
					hasGot = Boolean(128 & state);
					ret[0] = hasGot;
					if(!hasGot && GlobalData.selfPlayer.money >= 50)
					{
						ret[1] = true;
					}
					break;
				
			}			
			return ret;
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