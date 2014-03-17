package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	/**进入帮会场景协议**/
	public class ClubEnterClubScenceSocketHandler extends BaseSocketHandler
	{
		public function ClubEnterClubScenceSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ENTER_SCENCE;
		}
		
		override public function handlePackage():void
		{
			
		}
		
		public static function sendEnter():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ENTER_SCENCE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}