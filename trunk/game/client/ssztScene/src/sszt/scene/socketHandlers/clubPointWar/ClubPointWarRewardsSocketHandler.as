package sszt.scene.socketHandlers.clubPointWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubPointWarRewardsSocketHandler extends BaseSocketHandler
	{
		public function ClubPointWarRewardsSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_POINT_REWARDS;
		}
		
		public static function send(argType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_POINT_REWARDS);
			pkg.writeInt(argType);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}