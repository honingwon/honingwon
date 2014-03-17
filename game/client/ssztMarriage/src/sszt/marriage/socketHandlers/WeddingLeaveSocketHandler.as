package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WeddingLeaveSocketHandler extends BaseSocketHandler
	{
		public function WeddingLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WEDDING_QUIT_HALL;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WEDDING_QUIT_HALL);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}