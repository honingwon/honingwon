package sszt.core.data.club.camp
{
	public class ClubCollectionTemplateInfo
	{
		public var collectionId:int;
		public var type:int;
		public var name:String;
		public var guild_level:int;
		public var drop:Array;
		public var cost:int;
		
		public function ClubCollectionTemplateInfo(collectionId:int,type:int,level:int, name:String,drop:Array,cost:int)
		{
			this.collectionId = collectionId;
			this.type = type;
			this.name = name;
			this.guild_level = level;
			this.drop = drop;
			this.cost = cost;
		}
	}
}