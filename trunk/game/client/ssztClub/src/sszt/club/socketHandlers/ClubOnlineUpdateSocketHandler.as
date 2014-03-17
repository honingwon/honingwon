package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ClubOnlineUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubOnlineUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ONLINE_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var userId:Number = _data.readNumber();
			var outTime:Date = _data.readDate();
			var isOnline:Boolean = _data.readBoolean();
//			if(clubModule.clubInfo.clubMemberInfo)
//			{
//				var list:Vector.<ClubMemberItemInfo> = clubModule.clubInfo.clubMemberInfo.list;
				var list:Array = GlobalData.clubMemberInfo.list;
				for each(var info:ClubMemberItemInfo in list)
				{
					if(info.id == userId)
					{
						info.outTime = outTime;
						info.isOnline = isOnline;
						info.update();
					}
				}
//			}
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
	}
}