package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class ActivityPvpTemplateInfo
	{
		public var id:int;
		public var name:String;
		public var description:String;
		public var minLevel:int;
		public var openTime:String;
		public var npcId:int;
		public var awards:Array;
		public var awardType:int;
		
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
			minLevel = data.readInt();
			openTime = data.readUTF();
			npcId = data.readInt();
			description = data.readUTF();
			awards = data.readUTF().split(",");
			awardType = data.readInt();
		}
	}
}