package sszt.core.data.mounts
{
	import flash.utils.ByteArray;

	public class MountsDiamondTemplate
	{
		public var templateId:int;
		public var diamond:int;
		public var hp:int;
		public var mp:int;
		public var attack:int;
		public var defence:int;
		
		public function MountsDiamondTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			diamond = data.readInt();
			hp = data.readInt();
			mp = data.readInt();
			attack = data.readInt();
			defence = data.readInt();
		}
	}
}