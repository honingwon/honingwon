package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubInviteResponseSocketHandler extends BaseSocketHandler
	{
		public function ClubInviteResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_INVITE_RESPONSE;
		}
		
		public static function send(result:Boolean,clubId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_INVITE_RESPONSE);
			pkg.writeBoolean(result);
			pkg.writeNumber(clubId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}