package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.contributeLogInfo.ClubContributeLogItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubContributeLogSocketHandler extends BaseSocketHandler
	{
		public function ClubContributeLogSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_CONTRIBUTE_LOG;
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		override public function handlePackage():void
		{
			var total:int = _data.readByte();
			var len:int = _data.readByte();
			var list:Array = [];
			for(var i:int = 0; i < len; i++)
			{
				var info:ClubContributeLogItemInfo = new ClubContributeLogItemInfo();
				info.mes = _data.readString();
				info.date = _data.readDate();
				list.push(info);
			}
			if(clubModule.clubInfo.contributeLogInfo)
			{
				clubModule.clubInfo.contributeLogInfo.total = total;
				clubModule.clubInfo.contributeLogInfo.updateList(list);
			}
			
			handComplete();
		}
		
		public static function send(page:int,pagesize:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_CONTRIBUTE_LOG);
			pkg.writeByte(page);
			pkg.writeByte(pagesize);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}