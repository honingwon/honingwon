package sszt.club.datas.list
{
	public class ClubListItemInfo
	{
		public var name:String;
		public var id:Number;
		public var level:int;
		public var masterServerId:int;					//帮主服务器id
		public var masterId:Number;
		public var masterName:String;
		public var masterType:int;
		/**
		 * 财富
		 */		
		public var rich:int;
		/**
		 * 活跃度
		 */		
		public var activity:int;
		public var totalMember:int;
		public var currentMember:int;
		
			
		public var requestsNumber:int;
		
		public var shopLevel:int;
		public var furnaceLevel:int;
		/**
		 * 宣言
		 */		
		public var notice:String;
		
		public function ClubListItemInfo()
		{
		}
	}
}