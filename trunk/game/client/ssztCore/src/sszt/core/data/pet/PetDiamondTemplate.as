package sszt.core.data.pet
{
	import flash.utils.ByteArray;

	public class PetDiamondTemplate
	{
		public var templateId:int;
		public var diamond:int;
		public var magicAttack:int;
		public var farAttack:int;
		public var mumpAttack:int;
		public var powerHit:int;
		
		public function PetDiamondTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			diamond = data.readInt();
			magicAttack = data.readInt();
			farAttack = data.readInt();
			mumpAttack = data.readInt();
			powerHit = data.readInt();
		}
	}
}