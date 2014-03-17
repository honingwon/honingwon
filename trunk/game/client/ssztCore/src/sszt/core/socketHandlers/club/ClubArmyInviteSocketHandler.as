package sszt.core.socketHandlers.club
{
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubArmyInviteSocketHandler extends BaseSocketHandler
	{
		public function ClubArmyInviteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ARMY_INVITE;
		}
		
		override public function handlePackage():void
		{
			var nick:String = _data.readString();
			var clubName:String = _data.readString();
			var armyName:String = _data.readString();
			var clubId:Number = _data.readNumber();
			var armyId:Number = _data.readNumber();
			
			if(GlobalData.armyInviteAlert)
			{
				GlobalData.armyInviteAlert.dispose();
			}
			if(clubName == "")
			{
				GlobalData.armyInviteAlert = MAlert.show(LanguageManager.getWord("ssztl.common.inviteArmy",nick,armyName),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			}
			else
			{
				GlobalData.armyInviteAlert = MAlert.show(LanguageManager.getWord("ssztl.common.inviteClubArmy",nick,clubName,armyName),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			}
			
			
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					ClubArmyInviteResponseSocketHandler.send(true,clubId,armyId);
				}
				else
				{
					ClubArmyInviteResponseSocketHandler.send(false,clubId,armyId);
				}
				GlobalData.armyInviteAlert = null;
			}
			
			handComplete();
		}
		
		public static function send(armyName:String,nick:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ARMY_INVITE);
			pkg.writeString(armyName);
			pkg.writeString(nick);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}