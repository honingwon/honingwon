package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubArmyRenameSocketHandler extends BaseSocketHandler
	{
		public function ClubArmyRenameSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ARMY_RENAME;
		}
		
		public static function send(armyName:String,name:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ARMY_RENAME);
			pkg.writeString(armyName);
			pkg.writeString(name);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}