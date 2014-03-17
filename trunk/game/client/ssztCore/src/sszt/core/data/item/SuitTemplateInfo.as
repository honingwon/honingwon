package sszt.core.data.item
{
	import flash.utils.ByteArray;
	
	import sszt.core.utils.PackageUtil;

	public class SuitTemplateInfo
	{
		public var id:int;
		public var suitId:int;
		public var count:int;   //部件数量
		public var property:Array;
		public var hideProperty:Array;
		public var skillId:int;
		public var descript:String;
		
		public function SuitTemplateInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			suitId = data.readInt();
			count = data.readInt();
			property = PackageUtil.parseProperty(data.readUTF());
			hideProperty = PackageUtil.parseProperty(data.readUTF());
			skillId = data.readInt();
			descript = data.readUTF();
		}
	}
}