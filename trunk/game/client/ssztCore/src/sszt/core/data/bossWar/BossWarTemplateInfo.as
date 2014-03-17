package sszt.core.data.bossWar
{
	import flash.utils.ByteArray;

	public class BossWarTemplateInfo
	{
		public var id:int;
		public var type:int;
		public var description:String;
		public var dropList:Array;
		public var picId:int;
		public var mapId:int;
		public var posX:int;
		public var posY:int;
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			type = data.readInt();
			description = data.readUTF();
			dropList = data.readUTF().split(",");
			picId = data.readInt();
			mapId = data.readInt();
			posX = data.readInt();
			posY = data.readInt();
		}
	}
}