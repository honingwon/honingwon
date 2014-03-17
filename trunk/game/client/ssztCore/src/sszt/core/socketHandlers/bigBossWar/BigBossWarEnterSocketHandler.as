package sszt.core.socketHandlers.bigBossWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BigBossWarEnterSocketHandler extends BaseSocketHandler
	{
		public function BigBossWarEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BIG_BOSS_WAR_ENTER;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BIG_BOSS_WAR_ENTER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}