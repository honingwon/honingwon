package sszt.club.datas.war
{
	import flash.events.EventDispatcher;
	
	import sszt.club.events.ClubWarInfoUpdateEvent;
	
	public class ClubWarInfo extends EventDispatcher
	{
		public var warDeclearList:Array;
		public var warDealList:Array;
		public var warEnemyList:Array;
		
		public var declearListTotalNum:int;
		public var dealListTotalNum:int;
		public var enemyListTotalNum:int;
		
		public function ClubWarInfo()
		{
			warDeclearList = [];
			warDealList = [];
			warEnemyList = [];
		}
		
//		public function updateWarDeclearList(argListId:int,argState:int):void
//		{
//			var tmpInfo:ClubWarItemInfo = getWarDeclearList(argListId);
//			if(!tmpInfo)return;
//			tmpInfo.updateState(argState);
//		}
		
		public function setWarDeclearList(argList:Array):void
		{
			warDeclearList = argList;
			dispatchEvent(new ClubWarInfoUpdateEvent(ClubWarInfoUpdateEvent.WAR_DECLEAR_INFO_INIT));
		}
		
		public function setWarDealList(argList:Array):void
		{
			warDealList = argList;
			dispatchEvent(new ClubWarInfoUpdateEvent(ClubWarInfoUpdateEvent.WAR_DEAL_INFO_INIT));
		}
		
		public function deleteWarDealList(argListId:int):void
		{
			var tmpInfo:ClubWarItemInfo = getWarDealItem(argListId);
			if(!tmpInfo)return;
			warDealList.splice(warDealList.indexOf(tmpInfo),1);
			dispatchEvent(new ClubWarInfoUpdateEvent(ClubWarInfoUpdateEvent.WAR_DEAL_INFO_DELETE,argListId));
		}
		
		public function setWarEnemyList(argList:Array):void
		{
			warEnemyList = argList;
			dispatchEvent(new ClubWarInfoUpdateEvent(ClubWarInfoUpdateEvent.WAR_ENEMY_INFO_INIT));
		}
		
		public function deleteWarEnemyList(argListId:int):void
		{
			var tmpInfo:ClubWarItemInfo = getWarEnemyItem(argListId);
			if(!tmpInfo)return;
			warEnemyList.splice(warEnemyList.indexOf(tmpInfo),1);
			dispatchEvent(new ClubWarInfoUpdateEvent(ClubWarInfoUpdateEvent.WAR_ENEMY_INFO_DELETE,argListId));
		}
		
		
		
		public function getWarDeclearList(argListId:int):ClubWarItemInfo
		{
			for each(var i:ClubWarItemInfo in warDeclearList)
			{
				if(i.clubListId == argListId)
				{
					return i;
				}
			}
			return null;
		}
		
		public function getWarDealItem(argListId:int):ClubWarItemInfo
		{
			for each(var i:ClubWarItemInfo in warDealList)
			{
				if(i.clubListId == argListId)
				{
					return i;
				}
			}
			return null;
		}
		
		public function getWarEnemyItem(argListId:int):ClubWarItemInfo
		{
			for each(var i:ClubWarItemInfo in warEnemyList)
			{
				if(i.clubListId == argListId)
				{
					return i;
				}
			}
			return null;
		}
	}
}