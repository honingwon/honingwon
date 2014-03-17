package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class ActivityTemplateInfo
	{
		public var id:int;
		public var name:String;
		public var openTime:String;
		public var minLevel:int;
		public var npcId:int;
		public var description:String;
		public var awards:Array;      //活动掉落物品
		public var isOpen:Boolean;
		public var awardType:int;
		public var maps:Array;
//		public var maxCount:int;
//		public var maxLevel:int;
//		public var expLevel:int;      //经验分级
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
			isOpen = data.readBoolean();
			openTime = data.readUTF();
			minLevel = data.readInt();
			npcId = data.readInt();
			description = data.readUTF();
			awards = data.readUTF().split(",");
			awardType = data.readInt();
			var mapsTmp:Array = data.readUTF().split(",");
			if(mapsTmp[0])
			{
				maps = mapsTmp;
			}
//			maxCount = data.readInt();
//			openDay = data.readInt();
//			maxLevel = data.readInt();
//			expLevel = data.readInt();
		}
	}
}