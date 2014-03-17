package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class DecomposeCopperInfo
	{
		public var quality:int;//装备品质
		public var needCopper:int;//洗练花费金钱
		public function parseData(argData:ByteArray):void
		{
			quality = argData.readInt();
			needCopper = argData.readInt();
		}
	}
}