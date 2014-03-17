package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubClearTryinPageSocketHandler extends BaseSocketHandler
	{
		public function ClubClearTryinPageSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_CLEARTRYIN_PAGE;
		}
		
		public static function send(page:int,pagesize:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_CLEARTRYIN_PAGE);
			pkg.writeByte(page);
			pkg.writeByte(pagesize);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}