package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubArmyKickOutSocketHandler extends BaseSocketHandler
	{
		public function ClubArmyKickOutSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ARMY_KICKOUT;
		}
		
		public static function send(userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ARMY_KICKOUT);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}