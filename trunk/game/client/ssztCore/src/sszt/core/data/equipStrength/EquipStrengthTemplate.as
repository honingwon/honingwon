package sszt.core.data.equipStrength
{
	import flash.utils.ByteArray;
	
	import sszt.core.utils.PackageUtil;

	/**
	 *全身强化加成属性模板 
	 * @author Administrator
	 * 
	 */	
	public class EquipStrengthTemplate
	{
		public var level:int;
		public var attack:int;
		public var defence:int;
		public var attrAttack:int;
		public var attrDefence:int;
		public var hp:int;
		public var mp:int;
		public var defenceSuppress:int;
		public var attrAttackPer:int;
		public var mumpDefence:int;
		public var magicDefence:int;
		public var farDefence:int;
		
		
		public function EquipStrengthTemplate()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			level = data.readInt();
			attack = data.readInt();
//			defence = data.readInt();
			attrAttack = data.readInt();
			mumpDefence = data.readInt();
			magicDefence = data.readInt();
			farDefence = data.readInt();
			hp = data.readInt();
//			mp = data.readInt();
//			defenceSuppress = data.readInt();
//			attrAttackPer = data.readInt();

		}
	}
}