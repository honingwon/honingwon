package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TeamLeaderChangeSocketHandler extends BaseSocketHandler
	{
		public function TeamLeaderChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_LEADER_CHANGE;
		}
		
		public static function sendLeaderChange(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TEAM_LEADER_CHANGE);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}