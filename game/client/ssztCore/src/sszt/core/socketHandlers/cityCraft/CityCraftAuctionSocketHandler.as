package sszt.core.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftAuctionSocketHandler extends BaseSocketHandler
	{
		public function CityCraftAuctionSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_AUCTION;
		}
		
		override public function handlePackage():void
		{
			var guildMoney:int  = _data.readInt();
			var guildNick:String = _data.readUTF();
			GlobalData.cityCraftInfo.updateAuction(guildMoney,guildNick);
			handComplete();
		}
		
		public static function send() : void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_AUCTION);
			GlobalAPI.socketManager.send(pkg);
		} 
	}
}