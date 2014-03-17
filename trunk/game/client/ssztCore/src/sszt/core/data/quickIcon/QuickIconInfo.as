package sszt.core.data.quickIcon
{
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.quickIcon.iconInfo.ClubIconInfo;
	import sszt.core.data.quickIcon.iconInfo.ClubNewcomerIconInfo;
	import sszt.core.data.quickIcon.iconInfo.DoubleSitIconInfo;
	import sszt.core.data.quickIcon.iconInfo.FriendIconInfo;
	import sszt.core.data.quickIcon.iconInfo.TeamIconInfo;
	import sszt.core.data.quickIcon.iconInfo.TradeIconInfo;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.interfaces.tick.ITick;

	public class QuickIconInfo extends EventDispatcher implements ITick
	{
		public var friendIconInfoList:Array;
		public var tradeIconInfoList:Array;
		public var doubleSitIconInfoList:Array;
		public var clubIconInfoList:Array;
		public var teamIconInfoList:Array;
		public var skillIconInfoList:Array;
		public var clubNewcomerList:Array;
		
		public function QuickIconInfo()
		{
			friendIconInfoList = [];
			tradeIconInfoList = [];
			 doubleSitIconInfoList = [];
			 clubIconInfoList = [];
			 teamIconInfoList = [];
			 skillIconInfoList = [];
			 clubNewcomerList = [];
		}
		
		public function addToClubNewcomerList(argClubNewcomerInfo:ClubNewcomerIconInfo):void
		{
			if(getClubNewcomerIconInfo(argClubNewcomerInfo.id))
			{
				return;
			}
			clubNewcomerList.push(argClubNewcomerInfo);
			argClubNewcomerInfo.startTime = getTimer();
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.CLUB_NEWCOMER_ICON_ADD));
		}
		
		public function removeAllFromClubNewcomerList():void
		{
			clubNewcomerList = [];
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.CLUB_NEWCOMER_ICON_REMOVE));
		}
		
		/**************************好友图标**************************************/
		public function addToFriendList(argFriendInfo:FriendIconInfo):void
		{
			if(getFriendIconInfo(argFriendInfo.id))
			{
				return;
			}
			friendIconInfoList.push(argFriendInfo);
			argFriendInfo.startTime = getTimer();
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_ADD));
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_CHANGE));
		}
		public function removeFromFriendList(argId:Number):void
		{
			var tmpInfo:FriendIconInfo = getFriendIconInfo(argId);
			if(tmpInfo)
			{
				friendIconInfoList.splice(friendIconInfoList.indexOf(tmpInfo),1);
			}
			if(friendIconInfoList.length == 0)
			{
				dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_REMOVE));
			}
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_CHANGE));
		}
		public function setFriendIconInfoList():void
		{
			friendIconInfoList = [];
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_REMOVE));
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_CHANGE));
		}
		
		public function getClubNewcomerIconInfo(argId:Number):ClubNewcomerIconInfo
		{
			for each(var i:ClubNewcomerIconInfo in clubNewcomerList)
			{
				if(i.id == argId)
				{
					return i;	
				}
			}
			return null;
		}
		
		public function getFriendIconInfo(argId:Number):FriendIconInfo
		{
			for each(var i:FriendIconInfo in friendIconInfoList)
			{
				if(i.id == argId)
				{
					return i;	
				}
			}
			return null;
		}
		
		/*******************************交易图标************************************************/
		public function addToTradeList(argTradeInfo:TradeIconInfo):void
		{
			if(getTradeIconInfo(argTradeInfo.id))
			{
				return;
			}
			tradeIconInfoList.push(argTradeInfo);
			argTradeInfo.startTime = getTimer();
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.TRADE_ICON_ADD));
		}
		public function removeFromTradeList(argId:Number):void
		{
			var tmpInfo:TradeIconInfo = getTradeIconInfo(argId);
			if(tmpInfo)
			{
				tradeIconInfoList.splice(tradeIconInfoList.indexOf(tmpInfo),1);
			}
			if(tradeIconInfoList.length == 0)
			{
				dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.TRADE_ICON_REMOVE));
			}
		}
		public function getTradeIconInfo(argId:Number):TradeIconInfo
		{
			for each(var i:TradeIconInfo in tradeIconInfoList)
			{
				if(i.id == argId)
				{
					return i;	
				}
			}
			return null;
		}
		
		/*******************************双修图标************************************************/
		public function addToDoubleSitList(argDoubleSitIconInfo:DoubleSitIconInfo):void
		{
			if(getDoubleSitIconInfo(argDoubleSitIconInfo.id))
			{
				return;
			}
			doubleSitIconInfoList.push(argDoubleSitIconInfo);
			argDoubleSitIconInfo.startTime = getTimer();
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.DOUBLESIT_ICON_ADD));
		}
		public function removeFromDoubleSitList(argId:Number):void
		{
			var tmpInfo:DoubleSitIconInfo = getDoubleSitIconInfo(argId);
			if(tmpInfo)
			{
				doubleSitIconInfoList.splice(doubleSitIconInfoList.indexOf(tmpInfo),1);
			}
			if(doubleSitIconInfoList.length == 0)
			{
				dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.DOUBLESIT_REMOVE));
			}
		}
		
		public function removeAllDoubleSitList():void
		{
			doubleSitIconInfoList.length = 0;
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.DOUBLESIT_REMOVE));
		}
		public function getDoubleSitIconInfo(argId:Number):DoubleSitIconInfo
		{
			for each(var i:DoubleSitIconInfo in doubleSitIconInfoList)
			{
				if(i.id == argId)
				{
					return i;	
				}
			}
			return null;
		}
		
		/*******************************帮会图标************************************************/
		public function addToClubIconInfoList(argClubIconInfo:ClubIconInfo):void
		{
			if(getClubIconInfo(argClubIconInfo.clubId))
			{
				return;
			}
			clubIconInfoList.push(argClubIconInfo);
			argClubIconInfo.startTime = getTimer();
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.CLUB_ICON_ADD));
		}
		public function removeFromClubIconInfoList(argClubId:Number):void
		{
			var tmpInfo:ClubIconInfo = getClubIconInfo(argClubId);
			if(tmpInfo)
			{
				clubIconInfoList.splice(clubIconInfoList.indexOf(tmpInfo),1);
			}
			if(clubIconInfoList.length == 0)
			{
				dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.CLUB_ICON_REMOVE));
			}
		}
		public function getClubIconInfo(argId:Number):ClubIconInfo
		{
			for each(var i:ClubIconInfo in clubIconInfoList)
			{
				if(i.clubId == argId)
				{
					return i;	
				}
			}
			return null;
		}
		
		/*******************************组队图标************************************************/
		public function addToTeamIconInfoList(argTeamIconInfo:TeamIconInfo):void
		{
			if(getTeamIconInfo(argTeamIconInfo.id))
			{
				return;
			}
			teamIconInfoList.push(argTeamIconInfo);
			argTeamIconInfo.startTime = getTimer();
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.TEAM_ICON_ADD));
		}
		public function removeFromTeamIconInfoList(argId:Number):void
		{
			var tmpInfo:TeamIconInfo = getTeamIconInfo(argId);
			if(tmpInfo)
			{
				teamIconInfoList.splice(teamIconInfoList.indexOf(tmpInfo),1);
			}
			if(teamIconInfoList.length == 0)
			{
				dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.TEAM_ICON_REMOVE));
			}
		}
		public function removeTeamIconInfoList():void
		{
			teamIconInfoList.length = 0;
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.TEAM_ICON_REMOVE));
		}
		public function getTeamIconInfo(argId:Number):TeamIconInfo
		{
			for each(var i:TeamIconInfo in teamIconInfoList)
			{
				if(i.id == argId)
				{
					return i;	
				}
			}
			return null;
		}
		
		public function start():void
		{
			GlobalAPI.tickManager.addTick(this);
		}
		
		
		public function update(times:int,dt:Number = 0.04):void
		{
			//好友
//			for each(var i:FriendIconInfo in friendIconInfoList)
//			{
//					if(getTimer() - i.startTime > 15000)
//					{
//						removeFromFriendList(i.id);
//					}
//			}
//			//交易
//			for each(var j:TradeIconInfo in tradeIconInfoList)
//			{
//				if(getTimer() - j.startTime > 15000)
//				{
//					removeFromTradeList(j.id);
//				}
//			}
//			//双修
//			for each(var k:DoubleSitIconInfo in doubleSitIconInfoList)
//			{
//				if(getTimer() - k.startTime > 15000)
//				{
//					removeFromDoubleSitList(k.id);
//				}
//			}
//			//帮会
//			for each(var m:ClubIconInfo in clubIconInfoList)
//			{
//				if(getTimer() - m.startTime > 15000)
//				{
//					removeFromClubIconInfoList(m.clubId);
//				}
//			}
//			//队伍
//			for each(var n:TeamIconInfo in teamIconInfoList)
//			{
//				if(getTimer() - n.startTime > 15000)
//				{
//					removeFromTeamIconInfoList(n.id);
//				}
//			}
//			//技能
//			for each(var i:FriendIconInfo in skillIconInfoList)
//			{
//				if(getTimer() - i.startTime > 15000)
//				{
//					removeFromClubIconInfoList((i.id);
//				}
//			}
		}
	}
}