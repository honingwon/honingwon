package sszt.scene.socketHandlers.bigBossWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BigBossWarQuitSocketHandler extends BaseSocketHandler
	{
		public function BigBossWarQuitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BIG_BOSS_WAR_QUIT;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BIG_BOSS_WAR_QUIT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}