package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.storeInfo.ClubStoreRecordInfo;
	import sszt.club.datas.storeInfo.StoreEventItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreEventSocketHandler extends BaseSocketHandler
	{
		public function ClubStoreEventSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_EVENT;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			
			var record:Array = new Array(len);
			for(var i:int = 0; i < len; i++)
			{
				var info:ClubStoreRecordInfo = new ClubStoreRecordInfo();
				info.type = _data.readInt();
				info.date = _data.readDate();
				info.content = _data.readString();
				record[i] = info;
			}
			
			if(clubModule.clubInfo.clubStoreInfo)
			{
				clubModule.clubInfo.clubStoreInfo.updateEventList(record);
			}
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_EVENT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}