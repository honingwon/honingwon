package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.weal.ClubWealInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubWealUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubWealUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_WEAL_UPDATE;
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule
		}
		
		override public function handlePackage():void
		{
			if(clubModule.clubInfo.clubWealInfo)
			{
				var info:ClubWealInfo = clubModule.clubInfo.clubWealInfo;
//				info.weekWeal = _data.readInt();
				info.dayWeal = _data.readInt();
				info.needExploit = _data.readInt();
				info.canGetWeal = _data.readBoolean();
				GlobalData.selfPlayer.updateExploit(_data.readInt(),_data.readInt());
//				info.needRich = _data.readInt();
				info.update();
			}
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_WEAL_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}