package sszt.core.data.copy.duplicate
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class DuplicateMissionList
	{
		
		public static var list:Dictionary = new Dictionary();
		
		public static function setup(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var item:DuplicatMissionInfo = new DuplicatMissionInfo();
				item.parseDate(data);
				list[item.mapId] = item;
			}
		}
		
		public function DuplicateMissionList()
		{
			super();
		}
		
		public static function getDuplicateMission(id:int):DuplicatMissionInfo
		{			
			return list[id];
		}
		
		public static function getDuplicateMissionCount(id:int):int
		{
			var item:DuplicatMissionInfo = list[id];
			if(item)
			{
				var id:int = item.duplicateId;
				var count:int = 0;
				for each(var i:DuplicatMissionInfo in list)
				{
					if(i.duplicateId == id)
						++count;
				}
				return count;
			}
			else
				return 0;
		}
	}
}