package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreGetSocketHandler extends BaseSocketHandler
	{
		public function ClubStoreGetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_GET;
		}
		
		public static function send(itemId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_GET);
			pkg.writeNumber(itemId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}