package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubMonsterUpgradeSocketHandler extends BaseSocketHandler
	{
		public function ClubMonsterUpgradeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_MONSTER_UPGRADE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_MONSTER_UPGRADE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
	}
}