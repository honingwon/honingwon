package sszt.rank.data.item
{
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.rank.util.RankDataUtil;

	public class IndividualRankItem
	{
		public var place:int;
		
		/**
		 * 个人排行类型编号
		 * 等级 
		 * 穴位
		 * 气海
		 * */
		public var type:int;
		
		public var userId:Number;
		
		public var userName:String;
		
		public var vipId:int;
		
		public var career:int;
		
		public var guildName:String;
		
		public var value:int;
		
		public function readData(data:IPackageIn):void
		{
			type = data.readShort();
			userId = data.readNumber();
			userName = data.readUTF();
			vipId = data.readShort();
			career = data.readByte();
			guildName = data.readUTF();
			value = data.readInt();
		}
		
		
//		//服务器ID
		public var serverId:int;
		
//		//角色
		public var roleId:Number;
		public var roleName:String;
//		//性别
//		public var sexType:int;
//		public var sex:String;
//		//职业
//		public var careerType:int;
		public var careerName:String;
//		//帮会
//		public var clubId:Number;
//		public var clubName:String;
//		//等级
//		public var level:int;
//		//铜币
		public var money:int;
//		//战斗力
		public var strike:int;
//		
//		public var playerInfo:DetailPlayerInfo;
//		
//		public var equipList:Array = [];
		
//		public function IndividualRankItem()
//		{
//		}
		
//		public function readData(xml:XML):void
//		{
//			serverId = parseInt(xml.@server_id);
//			place = parseInt(xml.@rank);
//			roleId = parseInt(xml.@id);
//			roleName = xml.@nick_name;
//			sex = xml.@sex;
//			careerName = xml.@career;
//			clubName = xml.@club_name;
//			level = xml.@level;
//			money = xml.@copper;
//			strike = parseInt(xml.@fighting_effect);
//			playerInfo = new DetailPlayerInfo();
//			RankDataUtil.readDetailPlayer(playerInfo,xml);
//			if(xml.children().length()>0)
//			{
//				var equipXmlList:XMLList = xml.children()[0].children();
//				for each(var el:XML in equipXmlList)
//				{
//					var itemInfo:ItemInfo = new ItemInfo();
//					RankDataUtil.readItem(itemInfo,el);
//					equipList.push(itemInfo);
//				}
//			}
//		}
		
	}
}