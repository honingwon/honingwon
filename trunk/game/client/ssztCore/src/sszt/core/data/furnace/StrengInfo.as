package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.utils.PackageUtil;

	public class StrengInfo
	{
		public var id:int;
		/**对应categoryId**/
		public var equipType:int;
		public var equipLevel:int;
		public var strengSuccessRate:int;
		/**对应属性表**/
//		public var propertyInfoList:Vector.<PropertyInfo> = new Vector.<PropertyInfo>();;
		public var propertyInfoList:Array = [];
		public var purpleList:Array = [];
		public var orangeList:Array = [];
		
		public function StrengInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			equipType = data.readInt();
			equipLevel = data.readInt();
			strengSuccessRate = data.readInt();
			propertyInfoList = PackageUtil.parseProperty(data.readUTF());
			purpleList = PackageUtil.parseProperty(data.readUTF());
			orangeList = PackageUtil.parseProperty(data.readUTF());
		}
	}
}