package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class StoneEnchaseInfo
	{
		public var stoneLevel:int;//镶嵌宝石的等级
		public var copper:int;//金钱消耗系数
		
		public function parseData(argData:ByteArray):void
		{
			stoneLevel = argData.readInt();
			copper = argData.readInt();
		}
	}
}