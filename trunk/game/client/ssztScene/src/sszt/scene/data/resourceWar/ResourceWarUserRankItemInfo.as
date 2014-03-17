package sszt.scene.data.resourceWar
{
	import sszt.interfaces.socket.IPackageIn;

	public class ResourceWarUserRankItemInfo
	{
		public var place:int;
		public var nick:String;
		public var campType:int;
		public var totalPoint:int;
		
		public function parseData(data:IPackageIn):void
		{
			nick = data.readUTF();
			campType = data.readShort();
			totalPoint = data.readInt();
		}
	}
}