package sszt.rank.data.item
{
	import sszt.interfaces.socket.IPackageIn;

	public class OtherRankItem
	{
		
		public var place:int;
		/**
		 * 排行类型编号
		 * 
		 * 
		 * 
		 * */
		public var type:int;
		
		public var userId:Number;
		
		public var nick:String;
		
		public var itemId:Number;
		
		public var itemName:String;
		
		public var value:int;
		
		public function readData(data:IPackageIn):void
		{
			type = data.readShort();
			userId = data.readNumber();//如果是公会，公会等级
			nick = data.readUTF();//如果是公会，空
			itemId = data.readNumber();//如果是公会，公会id
			itemName = data.readUTF();//如果是公会，公会名称
			value = data.readInt();
		}

	}
}