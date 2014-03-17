package sszt.core.data.pet
{
	import flash.utils.ByteArray;

	public class PetUpgradeTemplate
	{
		public var level:int;
		public var exp:int;
		public var totalExp:int;
		
		public function PetUpgradeTemplate()
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