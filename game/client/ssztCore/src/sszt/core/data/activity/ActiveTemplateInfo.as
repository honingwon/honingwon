package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class ActiveTemplateInfo
	{
		public var id:int;
		public var activeName:String;
		public var count:int;
		public var activeTime:String;
		public var npcId:Array;
		public var activeNum:int;
		public var type:int;
		public var minLevel:int;
		//		public var activeId:int;
		
		public function ActiveTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			activeName = data.readUTF();
			count = data.readInt();
			activeTime = data.readUTF();
			npcId = data.readUTF().split('|');
			activeNum = data.readInt();
			type = data.readInt();
			minLevel = data.readInt();
		}
	}
}