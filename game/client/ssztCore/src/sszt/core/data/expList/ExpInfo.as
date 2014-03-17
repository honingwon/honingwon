package sszt.core.data.expList
{
	import flash.utils.ByteArray;
	
	import sszt.core.utils.PackageUtil;

	public class ExpInfo
	{
		public var level:int;
		public var exp:int;
		public var totalExp:Number;
		
		public function ExpInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			level = data.readInt();
			exp = data.readUnsignedInt();
			totalExp = Number(data.readUTF());
		}
	}
}