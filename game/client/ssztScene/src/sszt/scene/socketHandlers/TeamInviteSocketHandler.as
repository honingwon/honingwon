package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class TeamInviteSocketHandler extends BaseSocketHandler
	{
		public function TeamInviteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_INVITE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function sendInvite(serverId:int,name:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TEAM_INVITE);
//			pkg.writeShort(serverId);
			pkg.writeString(name);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}