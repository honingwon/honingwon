package sszt.core.data.pet
{
	import flash.utils.ByteArray;

	public class PetQualificationTemplate
	{
		public var templateId:int;
		public var qualification:int;
		public var magicAttack:int;
		public var farAttack:int;
		public var mumpAttack:int;
		public var powerHit:int;
		public var hit:int;
		public var mumpDefense:int;
		
		public function PetQualificationTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			qualification = data.readInt();
			magicAttack = data.readInt();
			farAttack = data.readInt();
			mumpAttack = data.readInt();
			hit = data.readInt();
			powerHit = data.readInt();
		}
	}
}