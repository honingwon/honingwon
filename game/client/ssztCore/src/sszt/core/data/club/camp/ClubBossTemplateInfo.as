package sszt.core.data.club.camp
{
	public class ClubBossTemplateInfo
	{
		public var bossId:int;
		public var type:int;
		public var name:String;
		public var guild_level:int;
		public var drop:Array;
		public var cost:int;
		
		public function ClubBossTemplateInfo(bossId:int,type:int, level:int, name:String,drop:Array,cost:int)
		{
			this.bossId = bossId;
			this.type = type;
			this.name = name;
			this.guild_level = level;
			this.drop = drop;
			this.cost = cost;
		}
	}
}