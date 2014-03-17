package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubArmyInviteResponseSocketHandler extends BaseSocketHandler
	{
		public function ClubArmyInviteResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ARMY_INVITERESPONSE;
		}
		
		public static function send(result:Boolean,clubId:Number,armyId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ARMY_INVITERESPONSE);
			pkg.writeBoolean(result);
			pkg.writeNumber(clubId);
			pkg.writeNumber(armyId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}