package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStorePutSocketHandler extends BaseSocketHandler
	{
		public function ClubStorePutSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_PUT;
		}
		
		public static function send(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_PUT);
			pkg.writeByte(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}