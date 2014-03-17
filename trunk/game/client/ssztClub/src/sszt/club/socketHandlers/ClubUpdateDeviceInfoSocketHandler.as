package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubUpdateDeviceInfoSocketHandler extends BaseSocketHandler
	{
		public function ClubUpdateDeviceInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ClUB_UPDATE_DEVICE_INFO;
		}
		
		public static function send(shop1:int,shop2:int,shop3:int,shop4:int,shop5:int,furnace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ClUB_UPDATE_DEVICE_INFO);
			pkg.writeInt(shop1);
			pkg.writeInt(shop2);
			pkg.writeInt(shop3);
			pkg.writeInt(shop4);
			pkg.writeInt(shop5);
			pkg.writeInt(furnace);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}