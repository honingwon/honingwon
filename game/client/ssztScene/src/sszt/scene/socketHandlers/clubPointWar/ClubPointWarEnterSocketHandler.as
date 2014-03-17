package sszt.scene.socketHandlers.clubPointWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubPointWarEnterSocketHandler extends BaseSocketHandler
	{
		public function ClubPointWarEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_POINT_ENTER;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_POINT_ENTER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}