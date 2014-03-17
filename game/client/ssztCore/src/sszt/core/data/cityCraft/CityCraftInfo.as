package sszt.core.data.cityCraft
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.socketHandlers.cityCraft.CityCraftAuctionStateSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	
	public class CityCraftInfo extends EventDispatcher
	{		
		public var attackGuild:String='';
		public var defenseGuild:String='';
		public var cityMaster:String='';
		public var defenseDays:int;
		public var nowPrice:int;
		public var selfPrice:int;
		public var guildNick:String="";//竞拍第一名工会名字
		public var auctionState:int;
		public var rankList:Array;//积分排名
		public var HP:int;
		public var selfPoint:int;
		public var selfCamp:int;
		public var selfIndex:int;
		public var awardItem:int;
		public var result:int;
		public var auctionArray:Array;
		public var guardList:Array;
		public var continueTime:int=1800;
		
		public function CityCraftInfo()
		{
			super();			
		}
		
		public function updateAuction(guildMoney:int,guildNick:String):void
		{
			nowPrice = guildMoney;
			this.guildNick = guildNick;
			if(this.auctionState==1&&guildNick!=GlobalData.selfPlayer.clubName)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CITY_CRAFT_NEW_AUCTION));
			}
			else
			{
				CityCraftAuctionStateSocketHandler.send();
			}
		}		
		
//		public function updateMasterInfo(day:int,defNick:String,cityMaster:String):void
//		{
//			defenseDays = day;
//			if(cityMaster == "")
//				cityMaster = "城主雕像";
//			this.cityMaster = cityMaster;
//			if(defNick == "")
//				defNick = "NPC军队"
//			defenseGuild = defNick;
//			dispatchEvent(new CityCraftEvent(CityCraftEvent.MASTER_UPDATE));
//		}
		
		public function showGuildEnter():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CITY_CRAFT_GUILD_ENTER));
		}
		
		public function updateGuardList(list:Array):void
		{
			this.guardList = list;			
			dispatchEvent(new CityCraftEvent(CityCraftEvent.GUARD_UPDATE));
		}
		public function updateReloadTime(time:int):void
		{
			continueTime = time;
			dispatchEvent(new CityCraftEvent(CityCraftEvent.RELOAD_UPDATE));
		}
		
		public function updateDaysInfo(day:int,defNick:String,masterNick:String,atkNick:String):void
		{
			defenseDays = day;
			if(atkNick == "null")
				atkNick = "竞拍中..";
			attackGuild = atkNick;
			if(masterNick == "")
				masterNick = "城主雕像";
			this.cityMaster = masterNick;
			if(defNick == "")
				defNick = "NPC军队"
			defenseGuild = defNick;
			dispatchEvent(new CityCraftEvent(CityCraftEvent.DAYS_UPDATE));
			dispatchEvent(new CityCraftEvent(CityCraftEvent.MASTER_UPDATE));
		}
		
		public function updateSelfAuctionInfo(guildArray:Array,guildNick:String,myGuildMoney:int,guildMoney:int):void
		{
			auctionArray = guildArray;
			this.guildNick = guildNick;
//			if(auctionArray.length>0)
//				attackGuild =(auctionArray[0] as CityCraftAuctionItemInfo).nick;
			selfPrice = myGuildMoney;
			nowPrice = guildMoney;
		}
		
		public function updateAuctionState(state:int):void
		{
			auctionState = state;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CITY_CRAFT_AUCTION_VIEW,auctionState == 1));
		}
		
		public function updateTopList(HP:int,myPoint:int,myCamp:int,rankList:Array):void
		{
			this.HP = HP;
			selfPoint = myPoint;
			selfCamp = myCamp;
			this.rankList = rankList;
			dispatchEvent(new CityCraftEvent(CityCraftEvent.RANK_LIST_UPDATE));
		}
		
		public function updateResultList(myPoint:int,myIndex:int,itemID:int,rankList:Array):void
		{
			selfPoint = myPoint;
			selfIndex = myIndex;
			awardItem = itemID;
			this.rankList = rankList;
			dispatchEvent(new CityCraftEvent(CityCraftEvent.RESULT_UPDATE));
		}
	}
}