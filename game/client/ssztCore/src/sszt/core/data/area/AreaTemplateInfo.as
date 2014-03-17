package sszt.core.data.area
{
	import flash.utils.ByteArray;

	public class AreaTemplateInfo
	{
		/**1是摆摊区  2是安全区**/
		public var type:int;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		
		public function AreaTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			type = data.readByte();
			x = data.readShort();
			y = data.readShort();
			width = data.readShort();
			height = data.readShort();
		}
	}
}
