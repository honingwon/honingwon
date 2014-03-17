package sszt.petpvp.data
{
	import sszt.interfaces.socket.IPackageIn;

	public class PetPVPPetItemInfo
	{
		public var place:int;
		public var id:Number;
		public var templateId:int;
		public var replaceId:int;
		public var nick:String;
		public var stairs:int;
		public var level:int;
		public var quality:int;
		public var fight:int;
		public var win:int;
		public var total:int;
		
		public function parseData(data:IPackageIn):void
		{
			id = data.readNumber();
			templateId = data.readInt();
			replaceId = data.readInt();
			stairs = data.readByte();
			level = data.readByte();
			quality = data.readByte();
			fight = data.readInt();
			place = data.readShort();
			win = data.readShort();
			total = data.readShort();
			nick = data.readUTF();
		}
	}
}