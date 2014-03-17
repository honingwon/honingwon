package sszt.core.data.club
{
	import flash.utils.ByteArray;

	public class ClubMonsterTemplateInfo
	{
		public var monsterId:int;
		public var clubMonsterLevel:int;
		public var needClubLevel:int;
		public var needClubRich:int;
		public var dropList:Array;
		
		public function ClubMonsterTemplateInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			monsterId = data.readInt();
			clubMonsterLevel = data.readInt();
			needClubLevel = data.readInt();
			needClubRich = data.readInt();
//			dropList = [107203,109221,107004,109080,109082,107002,109075];
			dropList = data.readUTF().split(",");
		}
	}
}