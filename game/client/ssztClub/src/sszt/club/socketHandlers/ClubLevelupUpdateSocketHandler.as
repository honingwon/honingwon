package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.levelup.ClubLevelUpInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubLevelupUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubLevelupUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_LEVELUP_UPDATE;
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule
		}
		
		override public function handlePackage():void
		{
			if(clubModule.clubInfo.clubLevelUpInfo)
			{
				var info:ClubLevelUpInfo = clubModule.clubInfo.clubLevelUpInfo;
				info.level = _data.readByte();
				info.needContribute = _data.readInt();
				info.needLiveness = _data.readInt();
				info.needRich = _data.readInt();
				info.clubContribute = _data.readInt();
				info.clubLiveness = _data.readInt();
				info.clubRich = _data.readInt();
//				info.honorNum = _data.readInt();
//				info.formalNum = _data.readInt();
//				info.prepareNum = _data.readInt();
				info.update();
			}
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_LEVELUP_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}