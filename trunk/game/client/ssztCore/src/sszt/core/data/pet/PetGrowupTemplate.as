package sszt.core.data.pet
{
	import flash.utils.ByteArray;

	public class PetGrowupTemplate
	{
		public var templateId:int;
		public var grow_up:int;
		public var hit:int;
		public var powerHit:int;
		public var attack:int;
		
		public function PetGrowupTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			grow_up = data.readInt();
			attack = data.readInt();
			hit = data.readInt();
			powerHit = data.readInt();
		}
	}
}