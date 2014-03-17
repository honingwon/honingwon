package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class StrengAddsuccrateInfo
	{
		public var failCount:int;//连续失败次数
		public var addSuccrate:int;//附加成功率
		
		public function parseData(argData:ByteArray):void
		{
			failCount = argData.readInt();
			addSuccrate = argData.readInt();
		}
	}
}