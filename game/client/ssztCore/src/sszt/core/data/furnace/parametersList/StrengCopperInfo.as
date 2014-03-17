package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class StrengCopperInfo
	{
		public var strengLevel:int;//强化等级
		public var needcopper:int;//消耗金钱
		
		public function parseData(argData:ByteArray):void
		{
			strengLevel = argData.readInt();
			needcopper = argData.readInt();
		}
	}
}