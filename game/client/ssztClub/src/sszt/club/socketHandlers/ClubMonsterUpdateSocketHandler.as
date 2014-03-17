package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubMonsterUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubMonsterUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_MONSTER;
		}
		
		override public function handlePackage():void
		{
			var tmpMonsterLevel:int = _data.readByte();
			var tmpCurrentClubLevel:int = _data.readByte();
			var tmpCurrentClubRich:int = _data.readInt();
			if(clubModule.clubInfo.clubMonsterInfo)
			{
				clubModule.clubInfo.clubMonsterInfo.monsterLevel = tmpMonsterLevel;
				clubModule.clubInfo.clubMonsterInfo.currentClubLevel = tmpCurrentClubLevel;
				clubModule.clubInfo.clubMonsterInfo.currentClubRich = tmpCurrentClubRich;
				clubModule.clubInfo.clubMonsterInfo.update();
			}
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_MONSTER);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
	}
}