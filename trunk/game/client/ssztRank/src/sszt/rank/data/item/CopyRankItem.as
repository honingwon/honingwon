package sszt.rank.data.item
{
	import sszt.core.utils.DateUtil;
	import sszt.interfaces.socket.IPackageIn;

	public class CopyRankItem
	{
		/**
		 * 副本玩家列表
		 */
		public var users:Array;
		
		/**
		 * 关卡数
		 */
		public var passId:int;
		
		/**
		 * 花费的时间字符串
		 */
		public var timeUsedStr:String;
		
		/**
		 * 花费的时间
		 */
		public var timeUsed:int;
		
		/**
		 * 排名
		 */
		public var place:int;
		
		public function CopyRankItem()
		{
			users = [];
		}
		
		public function readData(data:IPackageIn):void
		{
			passId = data.readInt();
			
			var userInfoListPack:String = data.readString();
			var userInfoPackList:Array = userInfoListPack.split('|');
			var userInfoMeta:Array;
			var userInfo:UserInfo;
			for each(var userInfoPack:String in userInfoPackList)
			{
				userInfoMeta = userInfoPack.split(',');
				userInfo = new UserInfo;
				userInfo.name = userInfoMeta[0];
				userInfo.id = userInfoMeta[1];
				userInfo.vipType = getVipType(userInfoMeta[2]);
				users.push(userInfo);
			}
			
			timeUsed = data.readInt();
			
			var hours:Number = DateUtil.millisecondsToHours(timeUsed * 1000);
			var mins:Number = DateUtil.hoursToMinutes(hours % 1);
			var secs:Number = DateUtil.minutesToSeconds(mins % 1);
			timeUsedStr = "";
			if(hours < 10)
				timeUsedStr += "0" + int(hours);
			else
				timeUsedStr += int(hours);
			if(mins < 10)
				timeUsedStr += ":0" + int(mins);
			else
				timeUsedStr += ":" + int(mins);
			if(secs < 10)
				timeUsedStr += ":0" + int(secs);
			else
				timeUsedStr += ":" + int(secs);
		}
		
		
		private function getVipType(vipType:int):int
		{
			var type:int = 0;
			if((vipType & 4) > 0)type = 1;
			else if((vipType & 8) > 0)type = 2;
			else if((vipType & 16) > 0)type = 3;
			return type;
		}
		
//		public function readData(xml:XML):void
//		{
//			place = parseInt(xml.@rank);
//			rolesString = xml.@name_list;
//			total = parseInt(xml.@pass_number);
//			useTime = xml.@pass_time;
//			
//			leader = rolesString.split("，")[0];
////			rolesString = rolesString.replace(/，/g,"\n");
//			
//			var hours:Number = DateUtil.millisecondsToHours(useTime * 1000);
//			var mins:Number = DateUtil.hoursToMinutes(hours % 1);
//			var secs:Number = DateUtil.minutesToSeconds(mins % 1);
//			useTimeString = "";
//			if(hours < 10)
//				useTimeString += "0" + int(hours);
//			else
//				useTimeString += int(hours);
//			if(mins < 10)
//				useTimeString += ":0" + int(mins);
//			else
//				useTimeString += ":" + int(mins);
//			if(secs < 10)
//				useTimeString += ":0" + int(secs);
//			else
//				useTimeString += ":" + int(secs);
//		}
	}
}
class UserInfo
{
	public var name:String;
	public var id:Number;
	public var vipType:int;
}