package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStorePageUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubStorePageUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_PAGEUPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var item:ItemInfo;
//			var list:Vector.<ItemInfo> = new Vector.<ItemInfo>(36);
			var list:Array = new Array(10*5);
			for(var i:int = 0; i < len; i++)
			{
				item = new ItemInfo();
				PackageUtil.readItem(item,_data);
				list[i] = item;
			}
			if(clubModule.clubInfo.clubStoreInfo)
				clubModule.clubInfo.clubStoreInfo.updateItems(list);
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(page:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_PAGEUPDATE);
			pkg.writeByte(page);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}