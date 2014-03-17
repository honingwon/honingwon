package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.tryin.TryinItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubQueryTryinSocketHandler extends BaseSocketHandler
	{
		public function ClubQueryTryinSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_QUERYTRYIN;
		}
		
		override public function handlePackage():void
		{
			if(clubModule.clubInfo.clubTryinInfo)
			{
				var total:int = _data.readInt();
				var len:int = _data.readInt();
				var result:Array = [];
				for(var i:int = 0; i < len; i++)
				{
					var item:TryinItemInfo = new TryinItemInfo();
//					item.serverId = _data.readShort();
					item.id = _data.readNumber();
					item.vipType = _data.readByte();
					item.name = _data.readString();
					item.career = _data.readByte();
					item.level = _data.readByte();
					item.sex = _data.readBoolean();
					item.date = _data.readDate();
					result.push(item);
				}
				clubModule.clubInfo.clubTryinInfo.totalListNum = total;
				clubModule.clubInfo.clubTryinInfo.list = result;
				clubModule.clubInfo.clubTryinInfo.update();
			}
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(page:int,pageCount:int = 11):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_QUERYTRYIN);
			pkg.writeByte(page);
			pkg.writeByte(pageCount);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}