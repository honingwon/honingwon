package sszt.core.socketHandlers.worldBoss
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GetWorldBossNumSocketHandler extends BaseSocketHandler
	{
		public function GetWorldBossNumSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BOSS_ALIVE_NUM;
		}
		
		override public function handlePackage():void
		{
			var num:int = _data.readInt();
			GlobalData.worldBossInfo.remainingNum = num;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BOSS_ALIVE_NUM);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}