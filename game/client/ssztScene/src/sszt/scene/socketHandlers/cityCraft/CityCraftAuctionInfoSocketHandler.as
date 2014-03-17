package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.cityCraft.CityCraftAuctionItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CityCraftAuctionInfoSocketHandler extends BaseSocketHandler
	{
		public function CityCraftAuctionInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var guildMoney:int  = _data.readInt();
			var myGuildMoney:int  = _data.readInt();
			var guildNick:String  = _data.readUTF();
			var len:int = _data.readShort();
			var i:int =0;
			var item:CityCraftAuctionItemInfo;
			var array:Array = new Array();
			for(i;i<len;i++)
			{
				item = new CityCraftAuctionItemInfo();
				item.nick = _data.readUTF();
				item.money = _data.readInt();
				array.push(item);
			}
			GlobalData.cityCraftInfo.updateSelfAuctionInfo(array,guildNick,myGuildMoney,guildMoney);
			var sceneModule:SceneModule = _handlerData as SceneModule;
			sceneModule.cityCraftAuctionPanel.updateAuction();
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_AUCTION_INFO;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_AUCTION_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}