package sszt.core.data.mounts
{
	import flash.utils.ByteArray;

	public class MountsStarTemplate
	{
		public var templateId:int;
		public var star:int;
		public var magicAttack:int;
		public var farAttack:int;
		public var mumpAttack:int;
		public var magicDefense:int;
		public var farDefense:int;
		public var mumpDefense:int;
		
		public function MountsStarTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			star = data.readInt();
			magicAttack = data.readInt();
			farAttack = data.readInt();
			mumpAttack = data.readInt();
			magicDefense = data.readInt();
			farDefense = data.readInt();
			mumpDefense = data.readInt();
		}
	}
}