package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class PlayerBreakAwaySocketHandler extends BaseSocketHandler
	{
		public function PlayerBreakAwaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_BREAK_AWAY;
		}
		
		override public function handlePackage():void
		{			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_BREAK_AWAY);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}		
	}
}