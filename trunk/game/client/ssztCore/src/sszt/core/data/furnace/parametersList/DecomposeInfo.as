package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class DecomposeInfo
	{
		public var quality:int;//装备品质
		public var needCopper:int;//装备分解费用消耗
		public var succRate:int;//装备分解成功率	
		public function parseData(argData:ByteArray):void
		{
			quality = argData.readInt();
			needCopper = argData.readInt();
			succRate = argData.readInt();
		}
	}
}