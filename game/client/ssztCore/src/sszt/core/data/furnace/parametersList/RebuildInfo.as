package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class RebuildInfo
	{
		public var id:int;//Id
		public var categoryId:int;//装备类型
		public var quality:int;//装备品质
		public var successRates:int;//重铸成功几率
		
		public function parseData(argData:ByteArray):void
		{
			id = argData.readInt();
			categoryId = argData.readInt();
			quality = argData.readInt();
			successRates = argData.readInt();
		}
	}
}