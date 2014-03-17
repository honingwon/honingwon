package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	
	import sszt.core.utils.PackageUtil;

	public class ForgeInfo
	{
		public var id:int;
		public var name:String;
		public var sortOnList:Array;
		
		public function parseData(argData:ByteArray):void
		{
			id = argData.readInt();
			name = argData.readUTF();
			sortOnList = PackageUtil.parseFireBoxSort(argData.readUTF());
		}
	}
}