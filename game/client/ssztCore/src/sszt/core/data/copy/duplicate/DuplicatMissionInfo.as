package sszt.core.data.copy.duplicate
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	import sszt.core.data.MoneyType;
	
	public class DuplicatMissionInfo
	{
		public var mapId:int;
		public var missionId:int;
		public var duplicateId:int;
		public var needTime:int;
		public var totalExp:int;
		public var monsterNum:int;
		public var totalLilian:int;
		public var passInfo:String;
		public var name:String;
		public var awardExp:int;
		public var awardLilian:int;
		public var dorpList:Array;		
		
		public function DuplicatMissionInfo()
		{
			super();
			dorpList = [];
		}
		
		public function parseDate(data:ByteArray):void
		{
			mapId = data.readInt();
			missionId = data.readInt();
			duplicateId = data.readInt();
			needTime = data.readInt();
			monsterNum = data.readInt();
			totalExp = data.readInt();
			totalLilian = data.readInt();
			name = data.readUTF();
			passInfo = data.readUTF();
			var award:Array = data.readUTF().split("|");
			for each(var str:String in award)
			{
				var item:Array = str.split(",");
				if(item.length == 2)
				{
					switch(int(item[0]))
					{
						case MoneyType.CURRENCY_TYPE_EXP:
							awardExp = int(item[1]);
							break;
						case MoneyType.CURRENCY_TYPE_LIFE:
							awardLilian = int(item[1]);
							break;
						default:
							trace("error money type of duplicate mission award!{1}", missionId);						
					}
				}					
			}
			dorpList = data.readUTF().split(",");			
		}
	}
}