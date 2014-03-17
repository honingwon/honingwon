package sszt.core.socketHandlers.club.camp
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubCampLeaveSocketHandler extends BaseSocketHandler
	{
		public function ClubCampLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_LEAVE_SCENCE;
		}
		
		override public function handlePackage():void
		{
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_LEAVE_SCENCE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}