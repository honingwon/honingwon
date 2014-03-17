package sszt.core.data.mounts
{
	import flash.utils.ByteArray;

	public class MountsUpgradeTemplate
	{
		public var level:int;
		public var exp:int;
		public var totalExp:int;
		
		public function MountsUpgradeTemplate()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			level = data.readInt();
			exp = data.readInt();
			totalExp = data.readInt();
		}
	}
}