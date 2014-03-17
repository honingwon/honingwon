package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.quickIcon.iconInfo.ClubNewcomerIconInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubNewcomerSocketHandler extends BaseSocketHandler
	{
		public function ClubNewcomerSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_NEWCOMER;
		}
		
		override public function handlePackage():void
		{
			var userId:Number = _data.readNumber();
			var nick:String = _data.readUTF();
			if(userId == GlobalData.selfPlayer.userId)return;
			GlobalData.quickIconInfo.addToClubNewcomerList(new ClubNewcomerIconInfo(0,userId,nick));
			handComplete();
		}
		
		public static function send(userId:Number,type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_NEWCOMER);
			pkg.writeNumber(userId);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}