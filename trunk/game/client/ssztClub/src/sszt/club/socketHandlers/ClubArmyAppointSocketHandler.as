package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubArmyAppointSocketHandler extends BaseSocketHandler
	{
		public function ClubArmyAppointSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ARMY_APPOINT;
		}
		
		public static function send(armyId:Number,userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ARMY_APPOINT);
			pkg.writeNumber(armyId);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}