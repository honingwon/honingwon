package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class PickStoneInfo
	{
		public var stoneLevel:int;                      // 石头等级	
		public var copperModulus:int;                  // 金钱系数	
		public var successRates:int                    // 摘取成功率
		public function parseData(argData:ByteArray):void
		{
			stoneLevel = argData.readInt();
			copperModulus = argData.readInt();
			successRates = argData.readInt();
		}
	}
}