package sszt.core.data.furnace
{
	import flash.utils.ByteArray;

	public class StrengParametersInfo
	{
		public var id:int;
		public var equipQuality:int;
		public var equipMinLevel:int;
		public var equipMaxLevel:int;
		public var equipParameter:int;
		
		public function StrengParametersInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			equipQuality = data.readInt();
			equipMinLevel = data.readInt();
			equipMaxLevel = data.readInt();
			equipParameter = data.readInt();
		}
	}
}