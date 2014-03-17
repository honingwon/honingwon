package sszt.core.data.petpvp
{
	import sszt.interfaces.socket.IPackageIn;
	
	public class PetPVPLogItemInfo
	{
		public var petId:Number;
		public var petNick:String;
		public var nick:String;
		public var opponentPetId:Number;
		public var opponentPetNick:String;
		public var opponentNick:String;
		public var place:int;
		public var state:int;
		public var winning:int;
		
		public function parseData(data:IPackageIn):void
		{
			petId = data.readNumber();
			petNick = data.readUTF();
			nick = data.readUTF();
			opponentPetId = data.readNumber();
			opponentPetNick = data.readUTF();
			opponentNick = data.readUTF();
			place = data.readInt();
			state = data.readByte();
			winning = data.readInt();
		}
	}
}