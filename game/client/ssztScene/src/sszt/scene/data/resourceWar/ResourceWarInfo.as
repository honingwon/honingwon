package sszt.scene.data.resourceWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	
	public class ResourceWarInfo extends EventDispatcher
	{
		public static const CAMP_REWARDS:Array = [290600,290601,290602];
		public static const REWARDS_FIRST:int = 290603;
		public static const REWARDS_SECOND:int = 290604;
		public static const REWARDS_THIRD:int = 290605;
		public static const REWARDS_FORTH:int = 290606;
		public static const REWARDS_FIFTH:int = 290607;
		
		public var myPoint:int;
		public var myCollectPoint:int;
		public var myKillPoint:int;
		public var myCombo:int;
		
		/**
		 * 个人排名当前页码
		 * */
		public var currentPage:int = 1;
		/**
		 * 个人排名信息  最多10个
		 * */
		public var rankList:Array;
		public var campRankList:Array;
		
		public var myRankInfo:ResourceWarUserRankItemInfo;
		public var myRewards:Array;
		public var winningCampType:int;
		public var exploit:int;
		
		public function ResourceWarInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getCurrPageRankList():Array
		{
			var ret:Array;
			if(currentPage == 1)
			{
				ret = rankList.slice(0,5);
			}
			if(currentPage == 2)
			{
				ret = rankList.slice(5);
			}
			return ret;
		}
		
		public function updateRankList(list:Array,campList:Array):void
		{
			rankList = list;
			campRankList = campList;
			dispatchEvent(new ResourceWarInfoUpdateEvent(ResourceWarInfoUpdateEvent.RANK_INFO_UPDATE));
		}
		
		public function updateMyPoint(totalPoint:int, collectPoint:int, killPoint:int,combo:int):void
		{
			myPoint = totalPoint;
			myCollectPoint = collectPoint;
			myKillPoint = killPoint;
			myCombo = combo;
			dispatchEvent(new ResourceWarInfoUpdateEvent(ResourceWarInfoUpdateEvent.MY_POINT_UPDATE));
		}
		
		public function updateWarResult(list:Array,campList:Array,exploit:int):void
		{
			winningCampType = getWinningCampType();
			myRewards = getMyRewards();
			this.exploit = exploit;

			dispatchEvent(new ResourceWarInfoUpdateEvent(ResourceWarInfoUpdateEvent.RESULT_UPDATE));
		}
		
		private function getMyRewards():Array
		{
			var ret:Array = [];
			var myCampType:int =GlobalData.selfPlayer.camp;
			var campRankItem:ResourceWarCampRankItemInfo;
			var myCampRankPlace:int;
			
			for each(campRankItem in campRankList)
			{
				if(campRankItem.campType == myCampType)
				{
					myCampRankPlace = campRankItem.place;
					break;
				}
			}
			ret.push(CAMP_REWARDS[myCampRankPlace-1]);
			
			//检查玩家自己有无进入个人排行
			var myNick:String = GlobalData.selfPlayer.nick;
			myRankInfo = getUserRankItemInfoByNick(myNick);
			var myRankReward:int;
			if(myRankInfo)
			{
				switch(myRankInfo.place)
				{
					case 1 : 
						myRankReward = REWARDS_FIRST;
						break;
					case 2 : 
						myRankReward = REWARDS_SECOND;
						break;
					case 3 : 
						myRankReward = REWARDS_THIRD;
						break;
					case 4 : 
						myRankReward = REWARDS_FORTH;
						break;
					case 5 : 
						myRankReward = REWARDS_FIFTH;
						break;
				}
			}
			ret.push(myRankReward);
			return ret;
		}
		
		private function getWinningCampType():int
		{
			return (campRankList[0] as ResourceWarCampRankItemInfo).campType;
		}
		
		private function getUserRankItemInfoByNick(nick:String):ResourceWarUserRankItemInfo
		{
			var ret:ResourceWarUserRankItemInfo;
			var item:ResourceWarUserRankItemInfo;
			for each(item in rankList)
			{
				if(item.nick == nick)
				{
					ret = item;
					break;
				}
			}
			return ret;
		}
	}
}