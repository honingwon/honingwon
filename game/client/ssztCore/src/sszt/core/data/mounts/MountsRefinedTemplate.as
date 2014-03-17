package sszt.core.data.mounts
{
	import flash.utils.ByteArray;
	
	public class MountsRefinedTemplate
	{
		public var templateId:int;//坐骑ID
		public var level:int;//坐骑等级
		public var totalHp:int;//血量
		public var totalMp:int;//魔法值
		public var attack:int;//攻击
		public var defence:int;//防御
		public var propertyAttack:int;//属攻
		public var magicDefense:int;//内防
		public var farDefense:int;//远防
		public var mumpDefense:int;//外防
		
		public function MountsRefinedTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			level = data.readInt();
			totalHp = data.readInt();
			totalMp = data.readInt();
			attack = data.readInt();
			defence = data.readInt();
			propertyAttack = data.readInt();
			magicDefense = data.readInt();
			farDefense = data.readInt();
			mumpDefense = data.readInt();
		}
	}
}