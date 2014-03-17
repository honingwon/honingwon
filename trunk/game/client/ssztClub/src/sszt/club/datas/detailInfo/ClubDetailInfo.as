package sszt.club.datas.detailInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	
	public class ClubDetailInfo extends EventDispatcher
	{
		public var clubName:String = "";
		public var masterServerId:int;
		public var masterName:String = "";
		public var masterType:int;
		public var viceMasterServerId:int;
		public var viceMasterName:String = "";
		public var viceMasterType:int;												//vip
		public var clubLevel:int = 0;
		public var clubRank:int;
		public var currentCount:int = 0;
		public var totalCount:int = 0;
		public var clubRich:int = 0;												//财富
		public var maintainFee:int = 0;                                           //维护费用
//		public var Q_group:String = "";											//Q群
//		public var YY_group:String = "";											//YY
		public var notice:String = "";												//公告


//		public var enemy1:String = "";												//敌对
//		public var enemy2:String = "";
//		public var enemy3:String = "";
		public var onlineCount:int;
		public var enounce:String = "";
		public var totalHonor:int = 0;												//荣誉成员
		public var currentHonor:int = 0;
		public var totalNormal:int = 0;												//正式成员
		public var currentNormal:int = 0;
		public var totalPrepare:int = 0;											//预备成员
		public var camp:int;
		public var clubContribute:int;
		public var clubLiveness:int;
		public var currentPrepare:int = 0;
		public var mailTotalNum:int = 0;
		public var mailTadayNum:int = 0;
		
		public function ClubDetailInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			dispatchEvent(new ClubDetailInfoUpdateEvent(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE));
		}
	}
}