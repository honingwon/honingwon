package sszt.core.socketHandlers.club
{
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.quickIcon.iconInfo.ClubIconInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubInviteSocketHandler extends BaseSocketHandler
	{
		public function ClubInviteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_INVITE;
		}
		
		override public function handlePackage():void
		{
//			var serverId:int = _data.readShort();
			var nick:String = _data.readString();
			var clubName:String = _data.readString();
			var clubId:Number = _data.readNumber();
			
			GlobalData.quickIconInfo.addToClubIconInfoList(new ClubIconInfo(clubId,0,nick,clubName));
			
			handComplete();
		}
		
		public static function send(serverId:int,nick:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_INVITE);
//			pkg.writeShort(serverId);
			pkg.writeString(nick);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}