package sszt.core.data.mounts
{
	import flash.utils.ByteArray;

	public class MountsGrowupTemplate
	{
		public var templateId:int;
		public var grow_up:int;
		public var hp:int;
		public var mp:int;
		public var attack:int;
		public var defence:int;
		
		public function MountsGrowupTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			grow_up = data.readInt();
			hp = data.readInt();
			mp = data.readInt();
			attack = data.readInt();
			defence = data.readInt();
		}
	}
}