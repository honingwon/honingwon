package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.utils.PackageUtil;
	
	public class StrengthenInfo
	{
		public var level:int;
		public var minStrengthenNum:int;
		public var maxStrengthenNum:int;
		public var successRate:int;
		public var needCopper:int;
		public var needStone:int;
		public var perfectStone:int;
		public var growUp:int;
		public var addition:int;
		
		public function StrengthenInfo()
		{
		}
		public function parseData(data:ByteArray):void
		{
			level = data.readInt();
			minStrengthenNum = data.readInt();
			maxStrengthenNum = data.readInt();
			successRate = data.readInt();
			needCopper = data.readInt();
			needStone = data.readInt();
			perfectStone = data.readInt();
			growUp = data.readInt();
			addition = data.readInt();
		}
		
	}
}