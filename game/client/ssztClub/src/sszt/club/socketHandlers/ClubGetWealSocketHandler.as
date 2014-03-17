package sszt.club.socketHandlers
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubGetWealSocketHandler extends BaseSocketHandler
	{
		public function ClubGetWealSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_GETWEAL;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_GETWEAL);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}