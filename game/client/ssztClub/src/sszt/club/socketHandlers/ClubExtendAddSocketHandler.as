package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubExtendAddSocketHandler extends BaseSocketHandler
	{
		public function ClubExtendAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_EXTEND_ADD;
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_EXTEND_ADD);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}