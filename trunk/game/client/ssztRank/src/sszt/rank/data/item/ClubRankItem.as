package sszt.rank.data.item
{
	public class ClubRankItem
	{
		//排名
		public var place:int;
		//服务器id
		public var serverId:int;
		//帮会
		public var clubId:Number;
		public var clubName:String;
		//人数
		public var memberCount:int;
		//最大人数
		public var maxMeberNum:int;
		//帮会等级
		public var clubLevel:int;
		
		public function ClubRankItem()
		{
		}
		
		public function readData(xml:XML):void
		{
			serverId = parseInt(xml.@server_id);
			place = parseInt(xml.@rank);
			clubId = parseInt(xml.@id);
			clubName = xml.@guild_name;
			memberCount = parseInt(xml.@current_member);
			clubLevel = xml.@guild_level;
			maxMeberNum = parseInt(xml.@max_member);
		}
	}
}