package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class ActiveBagTemplateInfo
	{
		public var id:int;
		public var tempalteId:int;
		public var count:int;
		public var isBind:Boolean;
		public var activeNum:int;
		public function ActiveBagTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			tempalteId = data.readInt();
			count = data.readInt();
			isBind = data.readBoolean();
			activeNum = data.readInt();
		}
	}
}