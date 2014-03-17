package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.storeInfo.ExamineAndVerifyRecordInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreExamineAndVerifySocketHandler extends BaseSocketHandler
	{
		public function ClubStoreExamineAndVerifySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_REQUEST_LIST;
		}
		
		override public function handlePackage():void
		{
			var total:int = _data.readInt();
			var len:int = _data.readInt();
			
			var list:Array = new Array(len);
			for(var i:int = 0; i < len; i++)
			{
				var examineAndVerifyRecordInfo:ExamineAndVerifyRecordInfo = new ExamineAndVerifyRecordInfo();	
				
				var itemInfo:ItemInfo = new ItemInfo();
				PackageUtil.readItem(itemInfo, _data);
				examineAndVerifyRecordInfo.itemInfo = itemInfo;
				
				var name:String = _data.readString();
				examineAndVerifyRecordInfo.name = name;
				
				var recordId:Number = _data.readNumber();
				examineAndVerifyRecordInfo.recordId = recordId;
				
				var date:Date = _data.readDate();
				examineAndVerifyRecordInfo.date = date;
				
				list[i] = examineAndVerifyRecordInfo;
			}
			if(clubModule.clubInfo.clubStoreInfo)
			{
				clubModule.clubInfo.clubStoreInfo.updateExamineAndVerify(total, list);
			}
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(page:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_REQUEST_LIST);
			pkg.writeByte(page);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}