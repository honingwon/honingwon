package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TeamDisbandSocketHandler extends BaseSocketHandler
	{
		public function TeamDisbandSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_DISBAND;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendDisband():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TEAM_DISBAND);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}