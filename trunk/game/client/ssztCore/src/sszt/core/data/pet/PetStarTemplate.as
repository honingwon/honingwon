package sszt.core.data.pet
{
	import flash.utils.ByteArray;

	public class PetStarTemplate
	{
		public var templateId:int;
		public var star:int;
		public var attack:int;
		public var hit:int;
		
		public function PetStarTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			star = data.readInt();
			attack = data.readInt();
			hit = data.readInt();
		}
	}
}