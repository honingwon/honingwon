package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.contributeInfo.ClubContributeItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubContributeUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubContributeUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_CONTRIBUTE_UPDATE;
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
				var info:ClubContributeItemInfo = new ClubContributeItemInfo();
				info.serverId = _data.readShort();
				info.name = _data.readString();
				info.career = _data.readByte();
				info.copper = _data.readInt();
				info.yuanbao = _data.readInt();
				list.push(info);
			}
			if(clubModule.clubInfo.contributeInfo)
			{
				clubModule.clubInfo.contributeInfo.total = total;
				clubModule.clubInfo.contributeInfo.updateList(list);
			}
			
			handComplete();
		}
		
		public static function send(page:int,pagesize:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_CONTRIBUTE_UPDATE);
			pkg.writeByte(page);
			pkg.writeByte(pagesize);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}