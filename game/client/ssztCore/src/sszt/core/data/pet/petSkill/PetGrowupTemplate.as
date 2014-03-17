package sszt.core.data.pet.petSkill
{
	import flash.utils.ByteArray;

	public class PetGrowupTemplate
	{
		public var level:int;
		public var type:int;
		public var attack:int;
		public var defense:int;
		public var mumpDefense:int;
		public var magicDefense:int;
		public var farDefense:int;
		public var totalHp:int;
		
		public function PetGrowupTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			level = data.readInt();
			type = data.readInt();
			attack = data.readInt();
			defense = data.readInt();
			mumpDefense = data.readInt();
			magicDefense = data.readInt();
			farDefense = data.readInt();
			totalHp = data.readInt();
		}
	}
}