package sszt.core.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftAuctionStateSocketHandler extends BaseSocketHandler
	{
		public function CityCraftAuctionStateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var state:int = _data.readByte();
			GlobalData.cityCraftInfo.updateAuctionState(state);
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_AUCTION_STATE;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_AUCTION_STATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}