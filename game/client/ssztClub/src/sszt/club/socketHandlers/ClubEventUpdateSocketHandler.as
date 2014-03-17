package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.eventInfo.ClubEventItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubEventUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubEventUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
//		override public function getCode():int
//		{
//			return ProtocolType.CLUB_EVENT_UPDATE;
//		}
		
		override public function handlePackage():void
		{
			var total:int = _data.readInt();
			var len:int = _data.readInt();
			var result:Array = [];
			for(var i:int = 0; i < len; i++)
			{
				var info:ClubEventItemInfo = new ClubEventItemInfo();
				info.mes = _data.readString();
				info.date = _data.readDate();
				result.push(info);
			}
			if(clubModule.clubInfo.clubEventInfo)
			{
				clubModule.clubInfo.clubEventInfo.total = total;
				clubModule.clubInfo.clubEventInfo.updateList(result);
			}
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
//		public static function send(page:int,pagesize:int):void
//		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_EVENT_UPDATE);
//			pkg.writeByte(page);
//			pkg.writeByte(pagesize);
//			GlobalAPI.socketManager.send(pkg);
//		}
	}
}