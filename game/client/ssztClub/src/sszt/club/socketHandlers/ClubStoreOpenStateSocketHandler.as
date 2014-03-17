package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreOpenStateSocketHandler extends BaseSocketHandler
	{
		public function ClubStoreOpenStateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
//		override public function getCode():int
//		{
//			return ProtocolType.CLUB_STORE_OPEN_STATE;
//		}
//		
//		public static function send(state:Boolean):void
//		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_OPEN_STATE);
//			pkg.writeBoolean(state);
//			GlobalAPI.socketManager.send(pkg);
//		}
	}
}