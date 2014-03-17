package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class StoneComposeInfo
	{
		public var stoneLevel:int;//材料宝石等级
		public var copper:int;//消耗铜币
		public function parseData(argData:ByteArray):void
		{
			stoneLevel = argData.readInt();
			copper = argData.readInt();
		}
	}
}