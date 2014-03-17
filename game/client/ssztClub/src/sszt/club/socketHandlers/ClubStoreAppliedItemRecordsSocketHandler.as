package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.storeInfo.AppliedItemRecordInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreAppliedItemRecordsSocketHandler extends BaseSocketHandler
	{
		public function ClubStoreAppliedItemRecordsSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_MY_REQUEST_LIST;
		}
		
		override public function handlePackage():void
		{
			var total:int = _data.readInt();
			var len:int = _data.readInt();
			
			var list:Array = new Array(len);
			for(var i:int = 0; i < len; i++)
			{
				var appliedItemRecord:AppliedItemRecordInfo = new AppliedItemRecordInfo();	
				
				var itemInfo:ItemInfo = new ItemInfo();
				PackageUtil.readItem(itemInfo, _data);
				appliedItemRecord.itemInfo = itemInfo;
				
				var recordId:Number = _data.readNumber();
				appliedItemRecord.recordId = recordId;
				
				list[i] = appliedItemRecord;
			}
			if(clubModule.clubInfo.clubStoreInfo)
			{
				clubModule.clubInfo.clubStoreInfo.updateAppliedItemRecords(total, list);
			}
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(page:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_MY_REQUEST_LIST);
			pkg.writeByte(page);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}