package sszt.core.data.veins
{
	import flash.utils.ByteArray;
	public class VeinsExtraTemplateInfo
	{
		public var id:int;
		public var name:String;
		public var needLevel:int;
		public var hp:int;
		public var defense:int;
		public var mumpDefense:int;
		public var magicDefense:int;
		public var farDefense:int;
		public var attack:int;
		public var attributeAttack:int;
		public var damage:int;
		
		public function VeinsExtraTemplateInfo()
		{
			
		}
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
			needLevel = data.readInt();
			hp = data.readInt();
			defense = data.readInt();
			mumpDefense = data.readInt();
			magicDefense  = data.readInt();
			farDefense = data.readInt();
			attack = data.readInt();
			attributeAttack = data.readInt();
			damage = data.readInt();
		}
	}
}