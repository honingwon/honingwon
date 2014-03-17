package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.manageInfo.ClubExtendInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubExtendUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubExtendUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_EXTEND_UPDATE;
		}
		
		override public function handlePackage():void
		{
			if(clubModule.clubInfo.extendInfo)
			{
				var info:ClubExtendInfo = clubModule.clubInfo.extendInfo;
				var level:int = _data.readByte();
				info.total = level * 5 + 10;
				info.currentHonor = _data.readByte();
				info.currentNormal = _data.readByte();
				info.currentPrepare = _data.readByte();
				info.leftHonor = info.total - info.currentHonor;
				info.leftNormal = info.total - info.currentNormal;
				info.leftPrepare = info.total - info.currentPrepare;
				info.update();
			}
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_EXTEND_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}