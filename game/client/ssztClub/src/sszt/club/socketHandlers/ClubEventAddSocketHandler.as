package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubEventAddSocketHandler extends BaseSocketHandler
	{
		public function ClubEventAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
//		override public function getCode():int
//		{
//			return ProtocolType.CLUB_EVENT_ADD;
//		}
//		
//		public static function send(mes:String):void
//		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_EVENT_ADD);
//			pkg.writeString(mes);
//			GlobalAPI.socketManager.send(pkg);
//		}
	}
}