package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	
	public class PetGrowupExpTemplate
	{
		public var level:int;
		public var exp:int;
		public var totalExp:int;
		
		public function PetGrowupExpTemplate()
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