package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TeamKickSocketHandler extends BaseSocketHandler
	{
		public function TeamKickSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_KICK;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendTeamKick(id:Number):void
		{
			var pkg:IPackageOut =  GlobalAPI.socketManager.getPackageOut(ProtocolType.TEAM_KICK);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}