package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubUpgradeDeviceSocketHandler extends BaseSocketHandler
	{
		public function ClubUpgradeDeviceSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_UPGRADE_DEVICE;
		}
		
		
		//1演武堂，2商城
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_UPGRADE_DEVICE);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}